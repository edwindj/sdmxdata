library(tinytest)

library(sdmxdata)
library(cbsodataR)

# data ophalen cbsodataR
data_wide_selectie_cbsodataR <- cbsodataR::cbs_get_data(id = "83102NED", Nationaliteit = "NAT9351  ", Perioden = "2013JJ00")

# data ophalen sdmxdata
# endpoint cbs
CBSbeta <- get_endpoint("NL1")
data_wide_selectie_sdmx <- sdmxdata::get_data(CBSbeta, "NL1.CNVT", id = "DF_83102NED", pivot="Topics", filter_on = list("Nationaliteit" = "NAT9351", "Perioden" = "2013JJ00"), dim_contents = "id")

data_wide_selectie_sdmx
