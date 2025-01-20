if (interactive()){
  dfs <- list_dataflows()

  flowRef <- paste0(dfs[2, c("agencyID", "id", "version")], sep=",")

  # json
  d <-
    sdmx_v2_1_data_request(flowRef = flowRef) |>
    as.data.frame()

}
