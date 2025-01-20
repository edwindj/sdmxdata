#' Retrieve data from a SDMX data API
#'
#' Retrieve data from an SDMX data API.
#' The function retrieves data from the SDMX data API and returns it as a data.frame.
#'
#' `get_data` is similar to [get_observations()], but its differs in two aspects:
#' - it returns only data columns, no attribute columns
#' - it can pivot the observations, i.e. it can return the data in a wide format, which
#' is useful feature when the data has multiple measures or when the data is to
#' presented as a time series.
#' @export
#' @importFrom utils tail
#' @inheritParams get_observations
#' @param pivot `character` The name of the column to pivot the data on.
#' If `NULL` (default) the data is returned in a long format.
#' @return a data.frame
get_data <- function(
    req = NULL,
    agencyID,
    id,
    version = "latest",
    ref = NULL,
    startPeriod = NULL,
    endPeriod = NULL,
    filter_on = list(),
    ...,
    dim_contents = c("label", "both", "id"),
    obs_value_numeric = TRUE,
    raw = FALSE,
    language = NULL,
    cache_dir = tempdir(),
    pivot = NULL,
    verbose = getOption("sdmxdata.verbose", FALSE)
    ){


    dfi <- get_dataflow_structure(
      req = req,
      agencyID = agencyID,
      id = id,
      version = version,
      ref = ref,
      cache_dir = cache_dir,
      verbose = verbose,
      language = language
    )
    dim_contents <- match.arg(dim_contents)
    # maybe add the attributes here too
    dims <- names(dfi$dimensions)

    if (missing(pivot)){
      pivot <- dfi$dimensions |> names() |> tail(1)
      message("`pivot` is missing, selecting last dimension as pivot: ",
              dQuote(pivot))
    }
    has_pivot <- (length(pivot) > 0)
    # check before retrieving the data, to reduce frustration :-)
    if (has_pivot) {
      chk <- pivot %in% dims
      if (!all(chk)){
        stop("* 'pivot'=",pivot[!chk] |> dQuote() |> paste(collapse = ", "),
             " not found in dimensions: ", dims |> dQuote() |> paste(collapse = ", ")
        )
      }
    }

    obs <- get_observations(
      req = req,
      agencyID = agencyID,
      id = id,
      version = version,
      ref = ref,
      startPeriod = startPeriod,
      language = language,
      endPeriod = endPeriod,
      filter_on = filter_on,
      cache_dir = cache_dir,
      verbose = verbose,
      raw = TRUE
    )

    data.table::setDT(obs)

    # pivot if asked for
    if (has_pivot) {
      dims <- dims[dims != pivot]
      f <- "%s ~ %s" |>
          sprintf(
            dims |> paste(collapse = " + "),
            pivot |> paste(collapse = " + ")
          ) |>
          stats::as.formula()

      for (pv in pivot){
        obs[[pv]] <- sprintf("%s:%s", pv, obs[[pv]])
      }

      measure <- dfi$measure$id
      dta <- data.table::dcast(obs, f, value.var = measure)
      data.table::setDF(dta)
    } else {
      dta <- obs[, c(dims, dfi$measure$id), with = FALSE]
    }
    data.table::setDF(dta)

    # recode the dimension columns:
    for (id in dims){
      code <- dfi$dimensions[[id]]$codes
      if (!is.null(code)){
        labels <- switch(
          dim_contents,
          both  = sprintf("%s: %s", code$id, code$name),
          label = code$name,
          id    = code$id,
          code$id
        )
        dta[[id]] <- dta[[id]] |>
          factor(levels = code$id, labels=labels)
      }
    }


    # add labels to the columns
    clmn <- dfi$columns$name |> stats::setNames(dfi$columns$id)

    if (has_pivot){
      d <- dfi$dimensions[[pivot]]
      if (!is.null(d)){
        code <- d$codes
        code_id <- sprintf("%s:%s", pivot, code$id)
        clmn <- c(clmn, code$name |> stats::setNames(code_id))
      }
    }

    # only keep the columns that are in the data
    clmn <- clmn[names(clmn) %in% names(dta)]

    for (n in names(clmn)){
      attr(dta[[n]], "label") <- clmn[[n]]
    }


    dta
}
