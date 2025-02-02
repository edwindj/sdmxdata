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
      cache_dir = tempdir(),
      verbose = getOption("sdmxdata.verbose", FALSE)
    ) {
      if (nchar(id) > 0 && !is.null(cache_dir)) {
        cache_dir <- file.path(cache_dir, "sdmxdata", id)
      }
      self$url <- url
      self$id <- id
      self$name <- name
      self$language = language
      self$verbose <- verbose
      self$cache_dir <- cache_dir

      self$req <- httr2::request(url)
    },

    #' @description list the dataflows of an endpoint
    #' Same as [list_dataflows()].
    #' @param agencyID character, the agencyID to filter on
    #' @param language character, the language to use for the text used in the response
    #' @param raw logical, if `TRUE` return the raw SDMX json data.
    #' @param ... additional parameters to pass to the [list_dataflows()] function
    #' @param verbose logical, if `TRUE` print information about the dataflows
    #' @return a [data.frame()] with the dataflows,
    list_dataflows = function(
      agencyID = NULL,
      ...,
      raw = FALSE,
      language = self$language,
      verbose = self$verbose
    ) {
      list_dataflows(
        endpoint = self,
        agencyID = agencyID,
        language = language,
        raw = raw,
        ...,
        verbose = verbose
      )
    },

    #' get the dataflow structure of an endpoint
    #'
    #' get the dataflow structure of an endpoint
    #' @inheritParams get_dataflow_structure
    get_dataflow_structure = function(
      ref = NULL,
      id = NULL,
      agencyID = NULL,
      version = "latest",
      cache = (!is.null(self$cache_dir)),
      language = self$language
    ){
      dsd <- get_dataflow_structure(
        endpoint = self,
        ref = ref,
        id = id,
        cache = cache,
        agencyID = agencyID,
        version = version,
        language = language %||% self$language,
        verbose = self$verbose
      )

      attr(dsd, "call") <- sys.call()
      attr(dsd, "provider") <- self$id

      dsd
    },

    #' get the observations of an endpoint
    #'
    #' get the observations of an endpoint
    #' @inheritParams get_observations
    get_observations = function(
      agencyID = NULL,
      id = NULL,
      version = "latest",
      ref = NULL,
      filter_on = list(),
      ...,
      cache = (!is.null(self$cache_dir)),
      language = self$language
    ) {
      get_observations(
        endpoint = self,
        ref = ref,
        agencyID = agencyID,
        id = id,
        version = version,
        filter_on = filter_on,
        ...,
        cache = cache,
        verbose = self$verbose
      )
    },

    #' get the data of an endpoint
    #'
    #' get the data of an endpoint
    #' @inheritParams get_data
    get_data = function(
      agencyID = NULL,
      id = NULL,
      ref = NULL,
      filter_on = list(),
      pivot = NULL,
      ...,
      cache = (!is.null(self$cache_dir)),
      language = self$language,
      verbose = self$verbose
    ){
      get_data(
        endpoint = self,
        ref = ref,
        agencyID = agencyID,
        id = id,
        filter_on = filter_on,
        pivot = pivot,
        language = language,
        verbose = verbose
      )
    },

    #' list the agencies of an endpoint
    #'
    #' list the agencies of an endpoint
    #' @inheritParams list_agencies
    list_agencies = function(
      ...,
      cache = (!is.null(self$cache_dir)),
      raw = FALSE
    ) {
      list_agencies(
        endpoint = self,
        language = self$language,
        ...,
        raw = raw,
        cache = cache,
        verbose = self$verbose
      )
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
  cat("methods:",
      "$%s()" |>
        sprintf(
          c("list_dataflows", "get_dataflow_structure", "get_observations",
            "get_data"
          )
        ) |>
        paste(collapse = ", "), "\n"
  )
  invisible(x)
}

# cbsdata <- SDMXEndpoint$new("https://sdmx-api.beta.cbs.nl/rest")
# dfs <- cbsdata$list_dataflows()
#
# cbsdata
