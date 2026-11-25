// Query: fct_payments
// Source: olist_order_payments_dataset.csv
// Grain: ONE row per order (aggregated from the multi-row payment installments).
// Keeps: total paid, max installments, number of payment rows, main payment type.
let
Source = Csv.Document(
    File.Contents(DataFolder & "olist_order_payments_dataset.csv"),
    [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(PromotedHeaders, {
        {"order_id", type text},
        {"payment_sequential", Int64.Type},
        {"payment_type", type text},
        {"payment_installments", Int64.Type},
        {"payment_value", type number}}),
        // Drop zero-value rows (e.g. "not_defined" vouchers worth 0) - they carry no money
        PositiveOnly = Table.SelectRows(Typed, each [payment_value] > 0),
        // Aggregate to the order grain; pull the main payment type from the largest row
        Grouped = Table.Group(PositiveOnly, {"order_id"}, {
            {"payment_value_total", each Number.Round(List.Sum([payment_value]), 2), type number},
            {"payment_installments_max", each List.Max([payment_installments]), Int64.Type},
            {"payment_sequential_count", each List.Max([payment_sequential]), Int64.Type},
            {"payment_type_main", each Table.Sort(_, {{"payment_value", Order.Descending}}){0}[payment_type], type text}})
            in
            Grouped
            