## code to prepare `providers` dataset goes here
providers <-
"id,name,endpoint,language,json
ESTAT,EUROSTAT,https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1,en,2.0.0
LU1,STATEC,https://lustat.statec.lu/rest/,fr,2.0.0
NL1,Centraal Bureau voor de Statistiek,https://sdmx-api.beta.cbs.nl/rest,nl,2.0.0
OECD,OECD,https://sdmx.oecd.org/public/rest,en,2.0.0
ABS,AUSTRALIA,https://data.api.abs.gov.au/rest,en,2.0.0
BIS,BIS,https://stats.bis.org/api/v1,en,2.0.0
FAO,FAO,https://nsi-release-ro-statsuite.fao.org/rest,en,2.0.0
ILO,ILO,https://sdmx.ilo.org/rest,en,1.0.0
UN,UN,https://data.un.org/ws/rest,en,2.0.0
" |>
  data.table::fread() |>
  as.data.frame()


usethis::use_data(providers, overwrite = TRUE)
