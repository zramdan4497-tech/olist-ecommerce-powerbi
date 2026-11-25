// Query: dim_date
// Calendar table generated fully in Power Query (no source file needed).
// Covers the full analysis window: Sep 2016 - Dec 2018.
let
StartDate = #date(2016, 9, 1),
EndDate = #date(2018, 12, 31),
DayCount = Duration.Days(EndDate - StartDate) + 1,
Source = List.Dates(StartDate, DayCount, #duration(1, 0, 0, 0)),
ToTable = Table.FromList(Source, Splitter.SplitByNothing(), {"date"}),
Typed = Table.TransformColumnTypes(ToTable, {{"date", type date}}),
AddYear = Table.AddColumn(Typed, "year", each Date.Year([date]), Int64.Type),
AddQuarter = Table.AddColumn(AddYear, "quarter", each "Q" & Text.From(Date.QuarterOfYear([date])), type text),
AddYearQuarter = Table.AddColumn(AddQuarter, "year_quarter", each Text.From(Date.Year([date])) & "-Q" & Text.From(Date.QuarterOfYear([date])), type text),
AddMonth = Table.AddColumn(AddYearQuarter, "month", each Date.Month([date]), Int64.Type),
AddMonthName = Table.AddColumn(AddMonth, "month_name", each Date.MonthName([date]), type text),
AddYearMonth = Table.AddColumn(AddMonthName, "year_month", each Text.From(Date.Year([date])) & "-" & Text.PadStart(Text.From(Date.Month([date])), 2, "0"), type text),
AddWeek = Table.AddColumn(AddYearMonth, "week", each Date.WeekOfYear([date]), Int64.Type),
AddDay = Table.AddColumn(AddWeek, "day", each Date.Day([date]), Int64.Type),
AddDayOfWeek = Table.AddColumn(AddDay, "day_of_week", each Date.DayOfWeekName([date]), type text)
in
AddDayOfWeek
