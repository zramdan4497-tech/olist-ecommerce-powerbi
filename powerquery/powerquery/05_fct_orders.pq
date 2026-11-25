// Query: fct_orders
// Source: olist_orders_dataset.csv
// One row per order. Adds analysis flags and duration columns.
let
Source = Csv.Document(
    File.Contents(DataFolder & "olist_orders_dataset.csv"),
    [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(PromotedHeaders, {
        {"order_id", type text},
        {"customer_id", type text},
        {"order_status", type text},
        {"order_purchase_timestamp", type datetime},
        {"order_approved_at", type datetime},
        {"order_delivered_carrier_date", type datetime},
        {"order_delivered_customer_date", type datetime},
        {"order_estimated_delivery_date", type datetime}}),
        // Keep all order statuses: canceled/unavailable orders are part of the story (cancel-rate KPI).
        // Null delivery dates are expected for non-delivered orders and stay null.
        // Date-only columns (used for the relationships to dim_date)
        AddPurchaseDate = Table.AddColumn(Typed, "order_purchase_date", each DateTime.Date([order_purchase_timestamp]), type date),
        AddDeliveredDate = Table.AddColumn(AddPurchaseDate, "order_delivered_date", each
        if [order_delivered_customer_date] = null then null else DateTime.Date([order_delivered_customer_date]), type date),
        AddEstimatedDate = Table.AddColumn(AddDeliveredDate, "order_estimated_delivery_date_only", each DateTime.Date([order_estimated_delivery_date]), type date),

        // Durations
        AddDeliveryDays = Table.AddColumn(AddEstimatedDate, "delivery_days", each
        if [order_delivered_customer_date] = null then null
        else Duration.Days([order_delivered_customer_date] - [order_purchase_timestamp]), Int64.Type),
        AddEstimatedDays = Table.AddColumn(AddDeliveryDays, "estimated_days", each
        Duration.Days([order_estimated_delivery_date] - [order_purchase_timestamp]), Int64.Type),
        AddApprovalHours = Table.AddColumn(AddEstimatedDays, "approval_hours", each
        if [order_approved_at] = null then null
        else Number.Round(Duration.TotalHours([order_approved_at] - [order_purchase_timestamp]), 2), type number),

        // Flags
        AddOnTime = Table.AddColumn(AddApprovalHours, "on_time", each
        if [order_delivered_customer_date] = null then null
        else if [order_delivered_customer_date] <= [order_estimated_delivery_date] then 1 else 0, Int64.Type),
        AddIsDelivered = Table.AddColumn(AddOnTime, "is_delivered", each if [order_status] = "delivered" then 1 else 0, Int64.Type),
        AddIsCanceled = Table.AddColumn(AddIsDelivered, "is_canceled", each if [order_status] = "canceled" then 1 else 0, Int64.Type),

        // Drop the raw timestamp columns; the date-only versions are the model columns
        Removed = Table.RemoveColumns(AddIsCanceled, {
            "order_purchase_timestamp", "order_approved_at",
            "order_delivered_carrier_date", "order_delivered_customer_date"}),
            RenamedEstimated = Table.RenameColumns(Removed, {{"order_estimated_delivery_date", "order_estimated_delivery_datetime"}}),
            Renamed2 = Table.RenameColumns(RenamedEstimated, {{"order_estimated_delivery_date_only", "order_estimated_delivery_date"}}),
            RemovedDupes = Table.Distinct(Renamed2, {"order_id"})
            in
            RemovedDupes
            