if (interactive()){
  dfs <- sdmx_get_dataflows_v2_1()
  flowRef <- dfs$flowRefs[1]

  d <-
    sdmx_req_data_v2_1(flowRef = flowRef) |>
    sdmx_get_data()

  head(d)


  # json
  d <-
    sdmx_req_data_v2_1(flowRef = flowRef) |>
    sdmx_get_data(format = "json")

}
