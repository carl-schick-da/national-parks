let
    Source = Web.BrowserContents("https://en.wikipedia.org/wiki/List_of_national_parks_of_the_United_States"),
    #"Extracted Table From Html" = Html.Table(Source, {{"Column1", ".plainrowheaders TBODY TH"}, {"Column2", ".image:nth-child(1):nth-last-child(1)", each [Attributes][href]?}, {"Column3", "SMALL:nth-child(3) > .plainlinks > SPAN[style*=""white-space\:nowrap""]:nth-child(1):nth-last-child(1) > .external", each [Attributes][href]?}}, [RowSelector=".plainrowheaders TBODY TH"]),
    #"Changed Type" = Table.TransformColumnTypes(#"Extracted Table From Html",{{"Column1", type text}, {"Column2", type text}, {"Column3", type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Column1", "Name"}, {"Column2", "Image Link"}, {"Column3", "GPS Coordinates"}}),
    #"Appended Query" = Table.Combine({#"Renamed Columns", #"Park Media II"}),
    #"Sorted Rows" = Table.Sort(#"Appended Query",{{"Name", Order.Ascending}}),
    #"Reordered Columns" = Table.ReorderColumns(#"Sorted Rows",{"Name", "GPS Coordinates", "Image Link"}),
    #"Renamed Columns1" = Table.RenameColumns(#"Reordered Columns",{{"Image Link", "Image Link Param"}}),
    #"Split Column by Delimiter" = Table.SplitColumn(#"Renamed Columns1", "Image Link Param", Splitter.SplitTextByEachDelimiter({"/wiki/"}, QuoteStyle.Csv, false), {"Empty", "Image Link Param"}),
    #"Removed Columns" = Table.RemoveColumns(#"Split Column by Delimiter",{"Empty"}),
    #"Invoked Custom Function" = Table.AddColumn(#"Removed Columns", "Image Link", each fnGetImageLink([Image Link Param])),
    #"Expanded Image Link" = Table.ExpandTableColumn(#"Invoked Custom Function", "Image Link", {"Image Link"}, {"Image Link"})
in
    #"Expanded Image Link"