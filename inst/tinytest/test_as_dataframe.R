library(tinytest)

dfs <- list_dataflows()
ref <- dfs$ref[2]

dat <- sdmx_v2_1_data_request(flowRef = ref)  |>
  as.data.frame()
dat
