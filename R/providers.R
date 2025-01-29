PROVIDER_v2_1 <-
"id,name,endpoint,language,json
ESTAT,EUROSTAT,https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1,en,2.0.0
LU1,STATEC,https://lustat.statec.lu/rest/,fr,2.0.0
NL1,Centraal Bureau voor de Statistiek,https://sdmx-api.beta.cbs.nl/rest,nl,2.0.0
OECD,OECD,https://sdmx.oecd.org/public/rest,en,2.0.0
ABS,AUSTRALIA,https://data.api.abs.gov.au/rest,en,2.0.0
BIS,BIS,https://stats.bis.org/api/v1,en,2.0.0
FAO,FAO,https://nsi-release-ro-statsuite.fao.org/rest,en,2.0.0
ILO,ILO,https://sdmx.ilo.org/rest,en,1.0.0
UN,United Nations,https://data.un.org/ws/rest,en,2.0.0
" |>
  data.table::fread() |>
  as.data.frame()

#' Connect to a SDMX provider
#'
#' Connect to an SDMX provider
#' @param provider character, one of the available providers
#' @param language character, the language to use for the text used in the response.
#' @param verbose logical, if `TRUE` print information about the dataflows.
#' @return a SDMXProvider object\
#' @export
get_provider <- function(
    provider,
    language = NULL,
    verbose = FALSE
  ){

  provider <- match.arg(provider, choices = PROVIDER_v2_1$id)
  idx <- match(provider, PROVIDER_v2_1$id)
  provider <- PROVIDER_v2_1[idx,] |> as.list()

  SDMXProvider$new(
    provider$endpoint,
    id = provider$id,
    name = provider$name,
    language = language %||% provider$language,
    verbose = verbose
  )
}
