let
    Source = Web.BrowserContents("https://en.wikipedia.org/w/api.php?action=query&titles=" & image_lookup & "&prop=imageinfo&iiprop=url"),
    #"Extracted Table From Html" = Html.Table(Source, {{"Column1", ".p + .s2"}, {"Column2", ".o + *"}, {"Column3", ".s2 + .p"}}, [RowSelector=".p + .s2"]),
    #"Changed Type" = Table.TransformColumnTypes(#"Extracted Table From Html",{{"Column1", type text}, {"Column2", type text}, {"Column3", type text}}),
    #"Filtered Rows" = Table.SelectRows(#"Changed Type", each ([Column1] = """url""")),
    #"Removed Columns" = Table.RemoveColumns(#"Filtered Rows",{"Column3"}),
    #"Renamed Columns" = Table.RenameColumns(#"Removed Columns",{{"Column1", "Parameter"}, {"Column2", "Image Link"}}),
    #"Replaced Value" = Table.ReplaceValue(#"Renamed Columns","""","",Replacer.ReplaceText,{"Image Link"})
in
    #"Replaced Value"