PROVIDERS_v2_1 <-
  list(
    EUSTAT = "https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1"
  )


# d <- sdmx_endpoint(PROVIDERS_v2_1$EUSTAT) |>
#   sdmx_v2_1_data_request(flowRef="NAMA_10_GDP", key = "all") |>
#   httr2::req_dry_run()
#   sdmx_v2_1_as_data_frame()
