dfs <- get_dataflows()
flowRef <- dfs$flowRefs[2]

df <- sdmx_req_structure_v2_1(
  agencyID = "NL1_DOUT",
  resource = "dataflow",
  references = "all"
) |>
  httr2::req_perform() |>
  httr2::resp_body_json(simplifyDataFrame = TRUE)

View(df$data)
