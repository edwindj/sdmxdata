dfs <- list_dataflows()
ref <- dfs$ref[4]

obs <- get_observations(
  ref = ref,
  filter_on = list(
    "RegioS" = c("NL01"),
    "Perioden" = c("2024MM01")
  )
)

obs
