let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45WMlaK1YlWMgOTlmDS0AhMGZmAKWOgVCwA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [#"Number of Months" = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Number of Months", Int64.Type}})
in
    #"Changed Type"