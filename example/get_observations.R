dfs <- sdmx_v2_1_get_dataflows()
dflw <- dfs[5,c("id", "agencyID")]

get_observations(
  agencyID = dflw$agencyID,
  id = dflw$id
)
