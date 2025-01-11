library(tinytest)
dfs <- get_dataflows()
ref <- dfs$ref[2]
sdmx_v2_1_data_request(flowRef = ref)  |>
 as.data.frame()
