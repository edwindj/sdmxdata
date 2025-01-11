dfs <- get_dataflows()
flowRef <- dfs$ref[2]

df <- sdmx_v2_1_structure_request(
  agencyID = "NL1_DOUT",
  resource = "dataflow",
  resourceID = dfs$id[2],,
  references = "all"
) |> sdmx_v2_1_as_xml()

s <- xml_parse_structure(df)

View(s)
