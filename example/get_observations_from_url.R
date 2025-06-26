# retrieve an external url pointing to sdmx data

url <-
  "https://sdmx.oecd.org/public/rest/data/OECD.TAD.ARP,DSD_FISH_PROD@DF_FISH_AQUA,1.0/.A.._T.T?startPeriod=2010&dimensionAtObservation=AllDimensions"

obs <- get_observations_from_url(url)
head(obs)

query <- get_observations_from_url(url, return_query = TRUE)
query
