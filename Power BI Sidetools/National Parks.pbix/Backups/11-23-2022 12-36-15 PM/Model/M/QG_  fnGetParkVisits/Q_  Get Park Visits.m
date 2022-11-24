let
    #"Set Park Parameter" = if park_unit = null then "" else park_unit,
    #"Retrieved Script" = File.Contents("R:\OneDrive\Documents\Microsoft Power BI\Projects\National Parks\national_parks_pbi.py"),
    #"Generated Script" = "pbi_args = [" & """" & #"Set Park Parameter" & """" & "]" & "#(lf)#(lf)" & Text.FromBinary(#"Retrieved Script"),
    #"Executed Script" = Python.Execute(#"Generated Script"),
    #"Retrieved Dataframe" = #"Executed Script"{[Name="park_visits_df"]}[Value],
    #"Changed Type" = Table.TransformColumnTypes(#"Retrieved Dataframe",{{"0", type text}, {"1", type text}, {"2", type text}, {"3", type text}, {"4", type text}, {"5", type text}, {"6", type text}, {"7", type text}, {"8", type text}, {"9", type text}, {"10", type text}, {"11", type text}, {"12", type text}, {"13", type text}}),
    #"Promoted Headers" = Table.PromoteHeaders(#"Changed Type", [PromoteAllScalars=true]),
    #"Removed Columns" = Table.RemoveColumns(#"Promoted Headers",{"Total"}),
    #"Changed Type1" = Table.TransformColumnTypes(#"Removed Columns",{{"Year", Int64.Type}, {"JAN", Int64.Type}, {"FEB", Int64.Type}, {"MAR", Int64.Type}, {"APR", Int64.Type}, {"MAY", Int64.Type}, {"JUN", Int64.Type}, {"JUL", Int64.Type}, {"AUG", Int64.Type}, {"SEP", Int64.Type}, {"OCT", Int64.Type}, {"NOV", Int64.Type}, {"DEC", Int64.Type}})
in
    #"Changed Type1"