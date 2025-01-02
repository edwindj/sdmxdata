# dfs <- sdmx_v2_1_get_dataflows()
# ref <- dfs$ref[4]
#
# dfi <- get_dataflow_info(ref)
# saveRDS(dfi, "inst/extdata/dfi.rds")

dfi <-
  "extdata/dfi.rds" |>
  system.file(package = "cbsopendata") |>
  readRDS()

get_units(dfi)
