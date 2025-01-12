library(tinytest)

dfs <- get_dataflows()
dfs$ref

ref <- dfs$ref[2]
req <- sdmx_v2_1_structure_request(ref)

expect_equal(
  names(dfs),
  c("id", "version", "agencyID", "isFinal", "name", "names", "annotations",
    "structure", "description", "descriptions", "ref", "flowRef"
  )
)
