// Query: dim_customers
// Source: olist_customers_dataset.csv
let
Source = Csv.Document(
    File.Contents(DataFolder & "olist_customers_dataset.csv"),
    [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(PromotedHeaders, {
        {"customer_id", type text},
        {"customer_unique_id", type text},
        {"customer_zip_code_prefix", Int64.Type},
        {"customer_city", type text},
        {"customer_state", type text}}),
        // Clean text: trim spaces, title-case city, upper-case state code
        CleanCity = Table.TransformColumns(Typed, {{"customer_city", each Text.Proper(Text.Trim(_)), type text}}),
        CleanState = Table.TransformColumns(CleanCity, {{"customer_state", each Text.Upper(Text.Trim(_)), type text}}),
        // No duplicate customer_id and no nulls in this table (verified), nothing to remove
        RemovedDupes = Table.Distinct(CleanState, {"customer_id"})
        in
        RemovedDupes