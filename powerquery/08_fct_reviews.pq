// Query: fct_reviews
// Source: olist_order_reviews_dataset.csv
// Grain: ONE row per order (latest review wins).
// The raw file has duplicated review_ids and multiple reviews per order;
// keeping the latest by review_answer_timestamp is the standard fix.
// Comment text columns are dropped: not used in the model and they bloat it.
let
    Source = Csv.Document(
        File.Contents(DataFolder & "olist_order_reviews_dataset.csv"),
        [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    Typed = Table.TransformColumnTypes(PromotedHeaders, {
        {"review_id", type text},
        {"order_id", type text},
        {"review_score", Int64.Type},
        {"review_comment_title", type text},
        {"review_comment_message", type text},
        {"review_creation_date", type datetime},
        {"review_answer_timestamp", type datetime}}),
    RemovedText = Table.RemoveColumns(Typed, {"review_comment_title", "review_comment_message"}),
    SortedByAnswer = Table.Sort(RemovedText, {{"review_answer_timestamp", Order.Ascending}}),
    DedupReviewId = Table.Distinct(SortedByAnswer, {"review_id"}),   // keeps latest per review_id
    DedupOrder = Table.Distinct(DedupReviewId, {"order_id"}),        // keeps latest per order
    AddCreationDate = Table.TransformColumns(DedupOrder, {{"review_creation_date", each DateTime.Date(_), type date}}),
    AddAnswerDate = Table.AddColumn(AddCreationDate, "review_answer_date", each DateTime.Date([review_answer_timestamp]), type date),
    RemovedTimestamp = Table.RemoveColumns(AddAnswerDate, {"review_answer_timestamp"})
in
    RemovedTimestamp
