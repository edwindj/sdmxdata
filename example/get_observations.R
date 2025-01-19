if (interactive()) {

  dfs <- list_dataflows()
  flowRef <- dfs$flowRef[4]

  obs <- get_observations(
    flowRef = flowRef,
    filter_on = list(
      "RegioS" = c("NL01"),
      "Perioden" = c("2024MM01")
    )
  )

  obs
}
