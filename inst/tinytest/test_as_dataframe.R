library(tinytest)

dfs <- list_dataflows()
ref <- dfs$ref[10]

expect_message({
  dat <- sdmx_v2_1_data_request(flowRef = ref)  |>
    as.data.frame()
})
