let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("LcmxDcAgDAXRXVyzxCdEFJgUBimF5f3XiG1SnZ5Oldr9dCoRkBWlDoQ9csw1zfX/0tKyjgd22DPTjCvs4fQrK+zZZPYB", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"IRMA Unit" = _t, #"NPA Unit" = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"NPA Unit", type text}, {"IRMA Unit", type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"IRMA Unit", "IRMA Unit Code"}, {"NPA Unit", "NPA Unit Code"}})
in
    #"Renamed Columns"