#' Get data from a SDMX API
#'
#' Retrieve data from an sdmx api and return it as a data.frame
#' @param req An httr2 request object
#' @param format The format of the data. Either "csv" or "json"
#' @param labels The labels to include in the data. Either "both" or "id"
#' @param as.data.table if TRUE return a [data.table::data.table()].
#' @param ... reserved for future use
#' @return a data.frame or data.table depending on the value of `as.data.table`
#' @example example/sdmx_get_data.R
#' @export
sdmx_get_data <- function(
    req,
    format = c("csv", "json"),
    labels = c("both", "id"),
    ...,
    as.data.table = FALSE
){

  format <- match.arg(format)

  if (format == "json"){
    browser()
    req <- req |>
      httr2::req_headers(accept = "application/vnd.sdmx.data+json; version=1.0; charset=utf-8")

    path <- tempfile("sdmx", fileext = ".json")

    resp <-
      req |>
      httr2::req_perform(path = path)

    print(resp)

    a <- resp |> httr2::resp_body_json(simplifyVector = TRUE)
    print(a)

  }

  labels <- missing_or_match(labels)
  # if (missing(labels)){
  #   labels <- NULL
  # }
  # if (is.null(labels)){
  #   labels <- match.arg(labels)
  # }


  req <- req |>
      httr2::req_headers(accept = "application/vnd.sdmx.data+csv; version=1.0.0; charset=utf-8") |>
      add_header_accept(labels = labels)

  path <- tempfile("sdmx", fileext = ".csv")

  resp <- req |>
    httr2::req_perform(path = path)

  print(resp)

  d <- data.table::fread(file = path)
  if (isTRUE(as.data.table)){
    return(d)
  }
  data.table::setDF(d)
  d
}
