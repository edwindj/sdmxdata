library(tinytest)
get_dataflow_info <- cbsopendata:::get_dataflow_info

dfs <- sdmx_v2_1_get_dataflows()
ref <- dfs$ref[4]

x <- get_dataflow_info(ref)
