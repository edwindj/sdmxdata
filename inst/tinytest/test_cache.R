library(tinytest)

dfs <- sdmx_v2_1_get_dataflows()
ref <- dfs$ref[1]

x <- get_dataflow_info(ref)
