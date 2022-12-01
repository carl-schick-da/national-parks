let
    Source = #"Park Data Source",
    #"Removed Columns" = Table.RemoveColumns(Source,{"Park Name", "State", "Latitude", "Longitude", "Alternate Name", "Date Established", "Area in Acres"})
in
    #"Removed Columns"