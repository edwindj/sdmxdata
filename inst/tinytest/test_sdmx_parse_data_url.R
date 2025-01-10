library(tinytest)

q <- "https://sdmx-api.beta.cbs.nl/rest/data/NL1,DF_TESTSET_X01,1.0/?startPeriod=2010&endPeriod=2011"

sdmx_parse_data_url <- cbsopendata:::sdmx_parse_data_url

u <- httr2::url_parse(q)
res <- sdmx_parse_data_url(q)

res$args |> expect_equal(
  list(
    req = "https://sdmx-api.beta.cbs.nl/rest",
    resource = "data",
    flowRef = "NL1,DF_TESTSET_X01,1.0",
    startPeriod = "2010",
    endPeriod = "2011"
  )
)
