library(tinytest)

q <- "https://sdmx-api.beta.cbs.nl/rest/data/NL1,DF_TESTSET_X01,1.0/?startPeriod=2010&endPeriod=2011"

sdmx_parse_data_url <- sdmxdata:::sdmx_parse_data_url

u <- httr2::url_parse(q)
res <- sdmx_parse_data_url(q)

res$args |> expect_equal(
  list(
    endpoint = "https://sdmx-api.beta.cbs.nl/rest",
    resource = "data",
    flowRef = "NL1,DF_TESTSET_X01,1.0",
    startPeriod = "2010",
    endPeriod = "2011"
  )
)


q2 <- "https://sdmx-api.beta.cbs.nl/rest/data/NL1.CNVT,DF_85264NED,1.0/....TOPIC_GROUP_7+WerkzameBeroepsbevolking_3+TOPIC_GROUP_5+Beroepsbevolking_2?dimensionAtObservation=AllDimensions"

a <- q2 |>  sdmxdata:::consume_sdmx_url()
