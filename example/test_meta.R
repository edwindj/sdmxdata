dfs <- get_dataflows()
flowRef <- dfs$ref[2]

df <- sdmx_v2_1_structure_request(
  agencyID = "NL1_DOUT",
  resource = "dataflow",
  references = "all"
) |>
  httr2::req_perform() |>
  httr2::resp_body_json(simplifyDataFrame = TRUE)

View(df$data)
