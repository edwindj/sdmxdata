if (interactive()){
  dfs <- list_dataflows()
  flowRef <- dfs$ref[2]

  system.time({
    d <-
      sdmx_v2_1_data_request(flowRef = flowRef)

    sdmx_v2_1_as_data_frame()
  })


  # json
  d <-
    sdmx_v2_1_data_request(flowRef = flowRef) |>
    sdmx_v2_1_as_data_frame(format = "json")

}
