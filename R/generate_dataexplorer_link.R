generate_dataexplorer_link <- function(dsd){
  url <-
    "https://data-explorer.beta.cbs.nl/vis?lc=nl&df[ds]=cbs-production&df[id]=%s&df[ag]=%s&df[vs]=%s" |>
    sprintf(dsd$id, dsd$agencyID, dsd$version)
}
