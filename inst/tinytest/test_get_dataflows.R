library(tinytest)

dfs <- list_dataflows()
expect_true(
  all(names(dfs) %in% c("id", "version", "agencyID", "isFinal", "name", "names", "annotations",
    "structure", "description", "descriptions", "ref", "flowRef"
  ))
)
