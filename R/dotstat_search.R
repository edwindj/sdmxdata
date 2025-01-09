dotstat_search <- function(req = NULL, tenant = "cbs", q = ""){
  search_endpoint(req, tenant = tenant)
}


dotstat_dataflows <- function(){
  req <- search_endpoint()

  resp <- req |>
    httr2::req_perform() |>
    httr2::resp_body_json(simplifyVector = TRUE)

  # View(resp)
  resp
}

