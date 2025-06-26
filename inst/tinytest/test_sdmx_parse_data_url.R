library(tinytest)

q <- "https://sdmx-api.beta.cbs.nl/rest/data/NL1.CNVT,DF_85929NED,1.0/..2022JJ00+2023JJ00?dimensionAtObservation=AllDimensions"

sdmx_parse_data_url <- sdmxdata:::sdmx_parse_data_url

res <- sdmx_parse_data_url(q)

res |> expect_equal(
  list(
    endpoint = "https://sdmx-api.beta.cbs.nl/rest",
    resource = "data",
    flowRef = "NL1.CNVT,DF_85929NED,1.0",
    key = "..2022JJ00+2023JJ00",
    dimensionAtObservation = "AllDimensions"
  )
)

# a <- q2 |>  sdmxdata:::consume_sdmx_url()
