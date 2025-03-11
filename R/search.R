search_api <- function(
    endpoint = NULL,
    query = "",
    start = 0,
    rows = 10
  ){
  if(is.null(endpoint)){
    endpoint <- "https://search.beta.cbs.nl/api/search?tenant=cbs"
  }

  req <- httr2::request(endpoint)

  body <- list(
    lang = "nl",
    search = query,
    start = start,
    rows = rows,
    facets = list(
      datasourceId = I("ds-cbs-production")
    )
  )

  resp <-
    req |>
    httr2::req_body_json(body) |>
    httr2::req_method("POST") |>
    httr2::req_perform()

  resp |>
    httr2::resp_body_json(simplifyVector = TRUE)
}
