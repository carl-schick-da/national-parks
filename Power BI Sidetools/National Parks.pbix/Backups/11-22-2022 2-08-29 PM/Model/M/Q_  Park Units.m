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
    #"Renamed Columns1" = Table.RenameColumns(#"Sorted Rows",{{"NPA Unit Code", "Park Unit"}})
in
    #"Renamed Columns1"