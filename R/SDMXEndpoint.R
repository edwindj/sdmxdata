#' @title Base class for SDMX endpoints
#'
#' @description
#' Base class for SDMX endpoints
#' @importFrom R6 R6Class
#' @export
SDMXEndpoint <- R6::R6Class("SDMXEndpoint",
  public = list(

    #' @field req [httr2::request()] object, can be adjusted to add headers or proxy settings
    req = NULL,

    #' @field version character, the SDMX version of the endpoint
    version = "2.1",

    #' @field id character, the id of the endpoint
    id = "",

    #' @field name character, the name of the endpoint
    name = "",

    #' @field url character, the url of the endpoint
    url = "",

    #' @field verbose logical, if `TRUE` print information the connection
    verbose = FALSE,

    #' @field cache_dir character, the directory to cache the metadata in
    cache_dir = NULL,

    #' @field language character, the language to use for the text used in the response
    language = NULL,

    #' @description create a new SDMXEndpoint object
    #' @param url character, the url of the endpoint
    #' @param id character, the id of the endpoint
    #' @param name character, the name of the endpoint
    #' @param language character, the language to use for the text used in the response
    #' @param cache_dir character, the directory to cache the metadata in
    #' @param verbose logical, if `TRUE` print information on the connection
    initialize = function(
      url,
      id = gsub("\\W+", "_", url),
      name = url,
      language = NULL,
      cache_dir = file.path(tempdir(), "sdmxdata", id),
      verbose = getOption("sdmxdata.verbose", FALSE)
    ) {
      self$url <- url
      self$id <- id
      self$name <- name
      self$language = language
      self$verbose <- verbose
      self$cache_dir <- cache_dir

      req <- httr2::request(url)
      if (!is.null(language)){
        req <- req |> httr2::req_headers("Accept-Language" = language)
      }
      self$req <- req
    }
  )
)

#' @export
print.SDMXEndpoint <- function(x, ...) {
  cat("SDMXEndpoint ", x$id |> dQuote(), "\n")
  cat("  name:", x$name |> dQuote(), "\n")
  cat("  url:", x$req$url |> dQuote(), "\n")
  cat("  language: ", x$language |> dQuote(), "\n")
  cat("  cache_dir: ", x$cache_dir |> dQuote(), "\n")
  cat("  verbose: ", x$verbose, "\n")
  cat("  version: ", x$version, "\n")
  cat("\nproperties:",
      "$%s" |>
        sprintf(
          c("id", "url", "req", "name", "language", "cache_dir", "verbose", "version")
        ) |>
        paste(collapse = ", "), "\n"
  )
  # cat("methods:",
  #     "$%s()" |>
  #       sprintf(
  #         c("list_dataflows", "get_dataflow_structure", "get_observations",
  #           "get_data"
  #         )
  #       ) |>
  #       paste(collapse = ", "), "\n"
  # )
  invisible(x)
}

# cbsdata <- SDMXEndpoint$new("https://sdmx-api.beta.cbs.nl/rest")
# dfs <- cbsdata$list_dataflows()
#
# cbsdata
