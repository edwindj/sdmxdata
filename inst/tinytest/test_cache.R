library(tinytest)
get_dataflow_info_xml <- cbsopendata:::get_dataflow_info_xml

dfs <- get_dataflows()
ref <- dfs$ref[4]

x <- get_dataflow_info_xml(ref)
