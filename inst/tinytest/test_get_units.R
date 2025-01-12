# dfs <- get_dataflows()
# ref <- dfs$ref[4]
#
# dfi <- get_dataflow_info_xml(ref)
# saveRDS(dfi, "inst/extdata/dfi.rds")
get_units <- cbsopendata:::get_units

dfi <-
  "extdata/dfi.rds" |>
  system.file(package = "cbsopendata") |>
  readRDS()

get_units(dfi)
