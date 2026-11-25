// Query: dim_products
// Source: olist_products_dataset.csv + product_category_name_translation.csv
// Result: one row per product, category translated to English, nulls handled
let
// --- products ---
Source = Csv.Document(
    File.Contents(DataFolder & "olist_products_dataset.csv"),
    [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
    PromotedHeaders = Table.PromoteHeaders(Source, [PromoteAllScalars = true]),
    // fix the two misspelled source columns
    Renamed = Table.RenameColumns(PromotedHeaders, {
        {"product_name_lenght", "product_name_length"},
        {"product_description_lenght", "product_description_length"}}),
        Typed = Table.TransformColumnTypes(Renamed, {
            {"product_id", type text},
            {"product_category_name", type text},
            {"product_name_length", Int64.Type},
            {"product_description_length", Int64.Type},
            {"product_photos_qty", Int64.Type},
            {"product_weight_g", Int64.Type},
            {"product_length_cm", Int64.Type},
            {"product_height_cm", Int64.Type},
            {"product_width_cm", Int64.Type}}),

            // --- translation table ---
            TransSource = Csv.Document(
                File.Contents(DataFolder & "product_category_name_translation.csv"),
                [Delimiter = ",", Encoding = 65001, QuoteStyle = QuoteStyle.Csv]),
                TransHeaders = Table.PromoteHeaders(TransSource, [PromoteAllScalars = true]),
                TransTyped = Table.TransformColumnTypes(TransHeaders, {
                    {"product_category_name", type text},
                    {"product_category_name_english", type text}}),

                    // --- merge: bring the English category name ---
                    Merged = Table.NestedJoin(Typed, {"product_category_name"}, TransTyped, {"product_category_name"}, "t", JoinKind.LeftOuter),
                    Expanded = Table.ExpandTableColumn(Merged, "t", {"product_category_name_english"}, {"product_category_name_english"}),

                    // English name: fall back to the Portuguese name when no translation exists
                    AddEnglish = Table.AddColumn(Expanded, "product_category_english", each
                    if [product_category_name_english] <> null then [product_category_name_english]
                    else if [product_category_name] <> null then [product_category_name]
                    else "uncategorized", type text),
                    // 610 products have no category at all -> label them
                    RemovedHelper = Table.RemoveColumns(AddEnglish, {"product_category_name_english"}),

                    // 2 products have null physical attributes -> fill with column medians (computed from the raw file)
                    FillWeight = Table.ReplaceValue(RemovedHelper, null, 700, Replacer.ReplaceValue, {"product_weight_g"}),
                    FillLength = Table.ReplaceValue(FillWeight, null, 25, Replacer.ReplaceValue, {"product_length_cm"}),
                    FillHeight = Table.ReplaceValue(FillLength, null, 13, Replacer.ReplaceValue, {"product_height_cm"}),
                    FillWidth  = Table.ReplaceValue(FillHeight, null, 20, Replacer.ReplaceValue, {"product_width_cm"}),
                    FillNameLen = Table.ReplaceValue(FillWidth, null, 51, Replacer.ReplaceValue, {"product_name_length"}),
                    FillDescLen = Table.ReplaceValue(FillNameLen, null, 595, Replacer.ReplaceValue, {"product_description_length"}),
                    FillPhotos  = Table.ReplaceValue(FillDescLen, null, 1, Replacer.ReplaceValue, {"product_photos_qty"}),
                    RemovedDupes = Table.Distinct(FillPhotos, {"product_id"})
                    in
                    RemovedDupes
                    