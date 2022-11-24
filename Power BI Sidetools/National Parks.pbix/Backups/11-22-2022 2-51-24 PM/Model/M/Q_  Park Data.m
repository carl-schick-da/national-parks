let
    Source = Web.BrowserContents("https://en.wikipedia.org/wiki/List_of_national_parks_of_the_United_States"),
    #"Extracted Table From Html" = Html.Table(Source, {{"Column1", "TABLE.wikitable.sortable.plainrowheaders > * > TR > :nth-child(1)"}, {"Column2", "TABLE.wikitable.sortable.plainrowheaders > * > TR > :nth-child(2)"}, {"Column3", "TABLE.wikitable.sortable.plainrowheaders > * > TR > :nth-child(3)"}, {"Column4", "TABLE.wikitable.sortable.plainrowheaders > * > TR > :nth-child(4)"}, {"Column5", "TABLE.wikitable.sortable.plainrowheaders > * > TR > :nth-child(5)"}, {"Column6", "TABLE.wikitable.sortable.plainrowheaders > * > TR > :nth-child(6)"}, {"Column7", "TABLE.wikitable.sortable.plainrowheaders > * > TR > :nth-child(7)"}}, [RowSelector="TABLE.wikitable.sortable.plainrowheaders > * > TR"]),
    #"Promoted Headers" = Table.PromoteHeaders(#"Extracted Table From Html", [PromoteAllScalars=true]),
    #"Changed Type" = Table.TransformColumnTypes(#"Promoted Headers",{{"Name", type text}, {"Image", type text}, {"Location", type text}, {"Date established as park[7][12]", type text}, {"Area (2021)[13]", type text}, {"Recreation visitors (2021)[11]", Int64.Type}, {"Description", type text}}),
    #"Merged Queries" = Table.NestedJoin(#"Changed Type", {"Name"}, #"Park Media", {"Name"}, "Park Media", JoinKind.LeftOuter),
    #"Expanded Park Media" = Table.ExpandTableColumn(#"Merged Queries", "Park Media", {"Image Link", "GPS Coordinates"}, {"Image Link", "GPS Coordinates"}),
    #"Merged Queries1" = Table.FuzzyNestedJoin(#"Expanded Park Media", {"Name"}, #"Park Units", {"Park Name"}, "Park Units", JoinKind.LeftOuter, [IgnoreCase=true, IgnoreSpace=true]),
    #"Expanded Park Units" = Table.ExpandTableColumn(#"Merged Queries1", "Park Units", {"Park Unit", "Park Name"}, {"Park Unit", "Park Name"})
in
    #"Expanded Park Units"