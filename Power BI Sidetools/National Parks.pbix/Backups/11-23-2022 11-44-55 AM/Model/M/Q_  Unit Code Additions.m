let
    Source = Table.FromRows(Json.Document(Binary.Decompress(Binary.FromText("i45W8nMN8lTSUfJLLVcIyixLLVJwzy9KT1WKjQUA", BinaryEncoding.Base64), Compression.Deflate)), let _t = ((type nullable text) meta [Serialized.Text = true]) in type table [Code = _t, Name = _t]),
    #"Changed Type" = Table.TransformColumnTypes(Source,{{"Code", type text}, {"Name", type text}}),
    #"Renamed Columns" = Table.RenameColumns(#"Changed Type",{{"Code", "NPA Unit Code"}, {"Name", "Park Name"}})
in
    #"Renamed Columns"