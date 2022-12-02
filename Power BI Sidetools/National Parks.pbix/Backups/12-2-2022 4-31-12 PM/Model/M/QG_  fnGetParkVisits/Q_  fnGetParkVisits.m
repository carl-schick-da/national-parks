let
    Source = (park_unit as text) => let
    #"Get Park Parameter" = if park_unit = null then "" else park_unit,
    #"Extract Script" = File.Contents("R:\OneDrive\Documents\GitHub\national-parks\national_parks_pbi.py"),
    #"Prepend Parameter" = "pbi_args = [" & """" & #"Get Park Parameter" & """" & "]" & "#(lf)#(lf)" & Text.FromBinary(#"Extract Script"),
    #"Execute Script" = Python.Execute(#"Prepend Parameter"),
    #"Retrieve Dataframe" = #"Execute Script"{[Name="park_visits_df"]}[Value],
    #"Promote Headers" = Table.PromoteHeaders(#"Retrieve Dataframe", [PromoteAllScalars=true]),
    #"Remove Columns" = Table.RemoveColumns(#"Promote Headers",{"Total"}),
    #"Change Types" = Table.TransformColumnTypes(#"Remove Columns",{{"Year", Int64.Type}, {"JAN", Int64.Type}, {"FEB", Int64.Type}, {"MAR", Int64.Type}, {"APR", Int64.Type}, {"MAY", Int64.Type}, {"JUN", Int64.Type}, {"JUL", Int64.Type}, {"AUG", Int64.Type}, {"SEP", Int64.Type}, {"OCT", Int64.Type}, {"NOV", Int64.Type}, {"DEC", Int64.Type}})
in
    #"Change Types"
in
    Source