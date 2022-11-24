let
    Source = File.Contents("R:\OneDrive\Documents\Microsoft Power BI\Projects\National Parks\national_parks_pbi.py"),
    #"Extract Script" = "pbi_args = [" & """" & park_unit & """" & "]" & "#(lf)#(lf)" & Text.FromBinary(Source),
    #"Execute Script" = Python.Execute(#"Extract Script"),
    park_visits_df = #"Execute Script"{[Name="park_visits_df"]}[Value],
    #"Changed Type" = Table.TransformColumnTypes(park_visits_df,{{"0", type text}, {"1", type text}, {"2", type text}, {"3", type text}, {"4", type text}, {"5", type text}, {"6", type text}, {"7", type text}, {"8", type text}, {"9", type text}, {"10", type text}, {"11", type text}, {"12", type text}, {"13", type text}}),
    #"Promoted Headers" = Table.PromoteHeaders(#"Changed Type", [PromoteAllScalars=true]),
    #"Changed Type1" = Table.TransformColumnTypes(#"Promoted Headers",{{"Park Unit", type text}, {"Year", Int64.Type}, {"JAN", Int64.Type}, {"FEB", Int64.Type}, {"MAR", Int64.Type}, {"APR", Int64.Type}, {"MAY", Int64.Type}, {"JUN", Int64.Type}, {"JUL", Int64.Type}, {"AUG", Int64.Type}, {"SEP", Int64.Type}, {"OCT", Int64.Type}, {"NOV", Int64.Type}, {"DEC", Int64.Type}, {"Total", Int64.Type}})
in
    #"Changed Type1"