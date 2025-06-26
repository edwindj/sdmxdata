# create a data request object from a URL
url <- "https://sdmx.oecd.org/public/rest/data/OECD.TAD.ARP,DSD_FISH_PROD@DF_FISH_AQUA,1.0/.A.._T.T?startPeriod=2010&dimensionAtObservation=AllDimensions"

# it does not execute the request, it just creates the request object
req <- data_request_from_url(url, verbose = TRUE)

# this is the raw csv output of the SDMX data request
# most users are better of using `get_observations_from_url()`
d <- req |> as.data.frame()
head(d)
