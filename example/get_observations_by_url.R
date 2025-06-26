# retrieve an external url pointing to sdmx data

url <- "https://sdmx-api.beta.cbs.nl/rest/data/NL1.CNVT,DF_85929NED,1.0/..2022JJ00+2023JJ00?dimensionAtObservation=AllDimensions"

obs <- get_observations_by_url(url)
head(obs)


query <- get_observations_by_url(url, return_query = TRUE)
query
