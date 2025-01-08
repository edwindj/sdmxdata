library(tinytest)
dfs <- sdmx_v2_1_get_dataflows()
ref <- dfs$ref[2]
sdmx_v2_1_data_request(flowRef = ref)  |>
 sdmx_v2_1_as_data_frame(format = "csv")
