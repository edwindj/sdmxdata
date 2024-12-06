get_dataflows <- function(agencyID="LU1"){
  url <- sprintf(
    "https://lustat.statec.lu/rest/dataflow/%s",
    #"https://sdmx-api.beta.cbs.nl/rest/dataflow/%s",
    agencyID
  )
  dfs <- get_meta_json(url)
  # extract extra info?

  flows <- dfs$data$dataflows

  flows
}
