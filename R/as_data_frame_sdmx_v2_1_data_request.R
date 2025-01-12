#' Get data from a SDMX API
#'
#' Retrieve data from an sdmx api and return it as a data.frame
#' @param x An httr2 request object
#' @param row.names Not used
#' @param optional Not used
#' @param format The format of the data. Either "csv" or "json"
#' @param labels The labels to include in the data. Either "both" or "id"
#' @param as.data.table if TRUE return a [data.table::data.table()].
#' @param language The language to use for the text used in the response
#' @param ... reserved for future use
#' @return a data.frame or data.table depending on the value of `as.data.table`
#' @example example/as.data.frame.R
#' @export
as.data.frame.sdmx_v2_1_data_request <- function(
    x,
    row.names = NULL,
    optional = FALSE,
    format = c("csv", "json","xml"),
    labels = c("both", "id"),
    ...,
    language = "nl",
    as.data.table = FALSE
){
  #TODO move a lot of stuff to data_request
  format <- match.arg(format)
  req <- x

  req <- switch(
    format,
    csv  = req |> httr2::req_headers(accept = "application/vnd.sdmx.data+csv; version=1.0.0; charset=utf-8"),
    json = req |> httr2::req_headers(accept = "application/vnd.sdmx.data+json; version=1.0; charset=utf-8"),
    xml  = req,
    req
  )

  if (!is.null(language)){
    req <- req |>
      httr2::req_headers("Accept-Language" = language)
  }

  # only valid for csv format
  if (!missing(labels)){
    req <-
      req |>
      add_header_accept(labels = labels)
  }

  if (format == "json"){
    req <- req |>
      httr2::req_headers(
        accept = "application/vnd.sdmx.data+json; version=1.0; charset=utf-8")

    path <- tempfile("sdmx", fileext = ".json")

    resp <-
      req |>
      httr2::req_perform(path = path)

    # print(resp)

    a <- resp |> httr2::resp_body_json(simplifyVector = TRUE)
    print(a)
    return(a)

  }

  # browser()
  labels <- missing_or_match(labels)
  # if (missing(labels)){
  #   labels <- NULL
  # }
  # if (is.null(labels)){
  #   labels <- match.arg(labels)
  # }
  req <- req |>
      httr2::req_headers(accept = "application/vnd.sdmx.data+csv; version=1.0.0; charset=utf-8") |>
      httr2::req_url_query(format="csv") |> # for EUSTAT it seems format="SDMX-CSV" is required
      add_header_accept(labels = labels)

  path <- tempfile("sdmx", fileext = ".csv")

  resp <- req |>
    httr2::req_error(
      is_error = function(x) {
        if (x$status_code == 404){
          message("** Empty data selection, you may need to adjust your query.")
          return(FALSE)
        }
        return(FALSE)
      }
    ) |>
    httr2::req_perform(path = path)

  if (resp$status_code == 404){
    return(NULL)
  }

  d <- data.table::fread(file = path)
  if (isTRUE(as.data.table)){
    return(d)
  }
  data.table::setDF(d)
  d
}
