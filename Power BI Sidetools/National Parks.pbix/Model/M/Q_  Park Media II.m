let
    Source = Web.BrowserContents("https://en.wikipedia.org/wiki/List_of_national_parks_of_the_United_States"),
    #"Extracted Table From Html" = Html.Table(Source, {{"Column1", "TD[scope=""row""] > A"}, {"Column2", ".image:nth-child(1):nth-last-child(1)", each [Attributes][href]?}, {"Column3", "[style*=""white-space\:normal""]", each [Attributes][href]?}}, [RowSelector="TD[scope=""row""] > A"]),
    #"Changed Type" = Table.TransformColumnTypes(#"Extracted Table From Html",{{"Column1", type text}, {"Column2", type text}, {"Column3", type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Column1", "Name"}, {"Column2", "Image Link"}, {"Column3", "GPS Coordinates"}})
in
    #"Renamed Columns"