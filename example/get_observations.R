dfs <- list_dataflows()
ref <- dfs$ref[4]

  dfs <- list_dataflows()
  ref <- dfs$ref[4]

  obs <- get_observations(
    ref = ref,
    filter_on = list(
      "Perioden" = c("2009JJ00")
    )
  )

obs

