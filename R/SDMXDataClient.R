#' @importFrom R6 R6Class
SDMXProvider <- R6::R6Class("SDMXProvider",
  public = list(

    req = NULL,
    version = "2.1",

    id = "",
    name = "",

    verbose = FALSE,
    cache_dir = NULL,
    language = NULL,

    initialize = function(
      endpoint,
      id = "",
      name = "",
      language = NULL,
      cache_dir = tempdir(),
      verbose = FALSE,
      version = "2.1"
    ) {
      if (nchar(name) > 0 && !is.null(cache_dir)) {
        cache_dir <- file.path(cache_dir, name)
      }
      self$req <- httr2::request(endpoint)
      self$id <- id
      self$name <- name
      self$language = language
      self$verbose <- verbose
      self$cache_dir <- cache_dir
      self$version <- version
    },

    list_dataflows = function(
      agencyID = NULL,
      ...,
      language = self$language,
      verbose = self$verbose
    ) {
      list_dataflows(
        req = self$req,
        agencyID = agencyID,
        language = language,
        ...,
        cache_dir = self$cache_dir,
        verbose = verbose
      )
    },

    get_dataflow_structure = function(
      ref = NULL,
      id = NULL,
      agencyID = NULL,
      version = "latest",
      language = NULL
    ){
      get_dataflow_structure(
        req = self$req,
        ref = ref,
        id = id,
        agencyID = agencyID,
        version = version,
        language = language %||% self$language,
        cache_dir = self$cache_dir,
        verbose = self$verbose
      )
    },

    get_observations = function(
      agencyID = NULL,
      id = NULL,
      version = "latest",
      ref = NULL,
      filter_on = list(),
      ...,
      language = NULL
    ) {
      get_observations(
        req = self$req,
        ref = ref,
        agencyID = agencyID,
        id = id,
        version = version,
        filter_on = filter_on,
        ...,
        language = language %||% self$language,
        cache_dir = self$cache_dir,
        verbose = self$verbose
      )
    },

    get_data = function(
      agencyID = NULL,
      id = NULL,
      ref = NULL,
      filter_on = list(),
      pivot = NULL,
      ...,
      language = self$language,
      cache_dir = self$cache_dir,
      verbose = self$verbose
    ){
      get_data(
        req = self$req,
        ref = ref,
        agencyID = agencyID,
        id = id,
        filter_on = filter_on,
        pivot = pivot,
        language = language,
        cache_dir = cache_dir,
        verbose = verbose
      )
    }
  )
)

#' @export
print.SDMXProvider <- function(x, ...) {
  cat("SDMXProvider ", x$id |> dQuote(), "\n")
  cat("  name:", x$name |> dQuote(), "\n")
  cat("  endpoint:", x$req$url |> dQuote(), "\n")
  cat("  language: ", x$language |> dQuote(), "\n")
  cat("  cache_dir: ", x$cache_dir |> dQuote(), "\n")
  cat("  verbose: ", x$verbose, "\n")
  cat("  version: ", x$version, "\n")
  cat("\nproperties:",
      "$%s" |>
        sprintf(
          c("id", "req", "name", "language", "cache_dir", "verbose", "version")
        ) |>
        paste(collapse = ", "), "\n"
  )
  cat("methods:",
      "$%s()" |>
        sprintf(
          c("list_dataflows", "get_dataflow_structure", "get_observations", "get_data")
        ) |>
        paste(collapse = ", "), "\n"
  )
  invisible(x)
}

# cbsdata <- SDMXProvider$new("https://sdmx-api.beta.cbs.nl/rest")
# dfs <- cbsdata$list_dataflows()
#
# cbsdata
