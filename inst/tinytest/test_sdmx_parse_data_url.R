library(tinytest)

q <- "https://sdmx-api.beta.cbs.nl/rest/data/NL1.CNVT,DF_85929NED,1.0/..2022JJ00+2023JJ00?dimensionAtObservation=AllDimensions"

sdmx_parse_data_url <- sdmxdata:::sdmx_parse_data_url

u <- httr2::url_parse(q)
res <- sdmx_parse_data_url(q)

res$args |> expect_equal(
  list(
    endpoint = "https://sdmx-api.beta.cbs.nl/rest",
    agencyID = "NL1.CNVT",
    id = "DF_85929NED",
    version = "1.0",
    verbose = FALSE,
    filter_on = list(Perioden = c("2022JJ00", "2023JJ00"))
  )
)

# a <- q2 |>  sdmxdata:::consume_sdmx_url()
