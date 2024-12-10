library(httr2)
library(tinytest)
library(cbsopendata)


req <- sdmx_req_data_v2_1(flowRef = "NL1,DF_TESTSET_X01,1.0")

if (!at_home()){
  exit_file("Not running tests outside of home")
}

d <- req |>
  req_perform() |>
  resp_body_string() |>
  data.table::fread(text = _)

expect_equal(names(d), c("DATAFLOW", "REF_AREA", "TIME_PERIOD", "OBS_VALUE"))
