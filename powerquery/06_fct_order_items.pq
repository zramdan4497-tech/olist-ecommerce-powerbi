// Query: fct_order_items
// Source: olist_order_items_dataset.csv
// Grain: one row per order line (order_id + order_item_id).
let
    Source = Csv.Document(
        File.Contents(DataFolder & "olist_order_items_dataset.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(PromotedHeaders, {
        {"order_id", type text},
        {"order_item_id", Int64.Type},
        {"product_id", type text},
        {"seller_id", type text},
        {"shipping_limit_date", type datetime},
        {"price", type number},
        {"freight_value", type number}}),
    // shipping_limit_date to date only
    AddLimitDate = Table.AddColumn(Typed, "shipping_limit_date_only", each DateTime.Date([shipping_limit_date]), type date),
    RemovedLimit = Table.RemoveColumns(AddLimitDate, {"shipping_limit_date"}),
    RenamedLimit = Table.RenameColumns(RemovedLimit, {{"shipping_limit_date_only", "shipping_limit_date"}}),
    // Line total (price + freight) for GMV
    AddItemTotal = Table.AddColumn(RenamedLimit, "item_total", each Number.Round([price] + [freight_value], 2), type number),
    // order_item_id is a sequence number, not a unique key: the key is the pair
    RemovedDupes = Table.Distinct(AddItemTotal, {"order_id", "order_item_id"})
in
    RemovedDupes
