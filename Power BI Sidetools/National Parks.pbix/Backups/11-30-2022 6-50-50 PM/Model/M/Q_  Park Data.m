let
    Source = #"Park Data Source",
    #"Removed Columns" = Table.RemoveColumns(Source,{"Description", "Image Link"})
in
    #"Removed Columns"