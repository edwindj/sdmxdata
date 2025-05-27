library(httr2)
library(tinytest)
library(sdmxdata)


req <- sdmx_v2_1_data_request(flowRef = "NL1,DF_TESTSET_X02,1.0")

if (!at_home()){
  exit_file("Not running tests outside of home")
}

d <- req |>
  httr2::req_url_query(format = "csv") |>
  req_perform() |>
  resp_body_string() |>
  data.table::fread(text = _)

expect_equal(names(d), c("DATAFLOW", "REF_AREA", "TIME_PERIOD", "OBS_VALUE"))
