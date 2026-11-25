// Query: dim_sellers
// Source: olist_sellers_dataset.csv
let
Source = Csv.Document(
    File.Contents(DataFolder & "olist_sellers_dataset.csv"),
    [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(PromotedHeaders, {
        {"seller_id", type text},
        {"seller_zip_code_prefix", Int64.Type},
        {"seller_city", type text},
        {"seller_state", type text}}),
        CleanCity = Table.TransformColumns(Typed, {{"seller_city", each Text.Proper(Text.Trim(_)), type text}}),
        CleanState = Table.TransformColumns(CleanCity, {{"seller_state", each Text.Upper(Text.Trim(_)), type text}}),
        RemovedDupes = Table.Distinct(CleanState, {"seller_id"})
        in
        RemovedDupes