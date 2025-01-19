#' @importFrom R6 R6Class
SDMXDataClient <- R6::R6Class("SDMXDataClient",
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
      flowRef,
      id,
      agencyID,
      version = "latest",
      language = NULL
    ){
      get_dataflow_structure(
        req = self$req,
        flowRef = flowRef,
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
      flowRef = NULL,
      filter_on = list(),
      ...,
      language = NULL
    ) {
      get_observations(
        req = self$req,
        flowRef = flowRef,
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
      flowRef = NULL,
      filter_on = list(),
      pivot = NULL,
      ...,
      language = NULL
    ){
      get_data(
        req = self$req,
        flowRef = flowRef,
        agencyID = agencyID,
        id = id,
        filter_on = filter_on,
        pivot = pivot,
        language = language %||% self$language,
        cache_dir = self$cache_dir,
        verbose = self$verbose
      )
    }
  )
)

# cbsdata <- SDMXDataClient$new("https://sdmx-api.beta.cbs.nl/rest")
# dfs <- cbsdata$list_dataflows()
#
# cbsdata
