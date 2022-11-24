let
    Source = Xml.Tables(Web.Contents("https://irmaservices.nps.gov/v2/rest/unit/designations")),
    Table0 = Source{0}[Table],
    #"Changed Type" = Table.TransformColumnTypes(Table0,{{"Code", type text}, {"Name", type text}}),
    Units = #"Changed Type"{12}[Units],
    Value = Units{0}[Value],
    #"Renamed Columns" = Table.RenameColumns(Value,{{"Code", "IRMA Unit Code"}, {"Name", "Park Name"}}),
    #"Merged Queries" = Table.NestedJoin(#"Renamed Columns", {"IRMA Unit Code"}, #"Unit Code Transforms", {"IRMA Unit Code"}, "Unit Code Transforms", JoinKind.LeftOuter),
    #"Expanded Unit Code Transforms" = Table.ExpandTableColumn(#"Merged Queries", "Unit Code Transforms", {"NPA Unit Code"}, {"NPA Unit Code"}),
    #"Replaced Value1" = Table.ReplaceValue(#"Expanded Unit Code Transforms",null, each _[IRMA Unit Code],Replacer.ReplaceValue,{"NPA Unit Code"}),
    #"Removed Columns" = Table.RemoveColumns(#"Replaced Value1",{"IRMA Unit Code"}),
    #"Reordered Columns" = Table.ReorderColumns(#"Removed Columns",{"NPA Unit Code", "Park Name"}),
    #"Appended Query" = Table.Combine({#"Reordered Columns", #"Unit Code Additions"}),
    #"Sorted Rows" = Table.Sort(#"Appended Query",{{"NPA Unit Code", Order.Ascending}}),
    #"NPA Unit Code1" = #"Sorted Rows"[NPA Unit Code],
    #"Converted to Table" = Table.FromList(#"NPA Unit Code1", Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Renamed Columns1" = Table.RenameColumns(#"Converted to Table",{{"Column1", "Park Unit"}}),
    #"Invoked Custom Function" = Table.AddColumn(#"Renamed Columns1", "Park Visits", each fnGetParkVisits([Park Unit])),
    #"Expanded Park Visits" = Table.ExpandTableColumn(#"Invoked Custom Function", "Park Visits", {"Year", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"}, {"Year", "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"})
in
    #"Expanded Park Visits"