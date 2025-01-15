PROVIDER_v2_1 <-
  list(
    ESTAT = "https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1",
    LU1 = "https://lustat.statec.lu/rest/",
    NL1 = "https://sdmx-api.beta.cbs.nl/rest"
  )

get_endpoint <- function(provider = getOption("cbsopendata", "NL1")){
  provider <- match.arg(provider, choices = names(PROVIDER_v2_1))
  sdmx_endpoint(PROVIDER_v2_1[[provider]])
}
