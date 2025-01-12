#' Get data from a SDMX API
#'
#' Get data from a SDMX API
#' @param agencyID The agency ID
#' @param id The id of the dataflow
#' @param version The version of the dataflow
#' @param flowRef The flow reference can be used in stead of agencyID, id and version
#' @param startPeriod The start period for which the data should be returned
#' @param endPeriod The end period for which the data should be returned
#' @param filter_on A named list of filters to apply to the data, if not speficied, it is the default selection, set to NULL to select all.
#' @param ... Additional parameters to pass to the request
#' @param dim_contents The contents of the dimension columns, either "label", "id" or "both"
#' @param attributes_contents The contents of the attribute columns, either "label", "id" or "both"
#' @param obs_value_numeric Should the OBS_VALUE column be coerced to numeric? Default is `TRUE`
#' @param raw If `TRUE` return the raw data.frame from the SDMX, otherwise the data.frame is processed
#' @param drop_first_column Should the first column be dropped? Default is `TRUE` (if not raw)
#' @param cache_dir The directory to cache the meta data, set to `NULL` to disable caching
#' @param verbose if `TRUE` print information about the caching.
#' @param as.data.table If `TRUE` return a [data.table()], otherwise a [data.frame()]
#' @return [data.frame()] or [data.table::data.table()] depending on `as.data.table`
#' @example example/get_observations.R
#' @export
get_observations <- function(
    agencyID,
    id,
    version = "latest",
    flowRef = NULL,
    startPeriod = NULL,
    endPeriod = NULL,
    filter_on = NULL,
    ...,
    as.data.table = FALSE,
    dim_contents = c("label", "both", "id"),
    attributes_contents = c("label", "id", "both"),
    obs_value_numeric = TRUE,
    raw = FALSE,
    drop_first_column = !raw,
    cache_dir = tempdir(),
    verbose = getOption("cbsopendata.verbose", FALSE)
  ){

  if (missing(flowRef) && (missing(agencyID) || missing(id))){
    return(NULL)
  }
  dim_contents <- match.arg(dim_contents)
  attributes_contents <- match.arg(attributes_contents)

  dfi <- get_dataflow_info(
    flowRef = flowRef,
    agencyID = agencyID,
    id = id,
    version = version,
    verbose = verbose,
    cache_dir = cache_dir
  )

  # dims <- get_dimensions(dfi)
  if (missing(filter_on)){
    filter_on <- get_default_selection(dfi)
    if (!is.null(filter_on)){
      message("`filter_on` argument not specified, using default selection:\n "
             , "filter_on=", deparse(filter_on)
             )
    }
  }

  key <- create_filter_key(dims = dfi$dimensions, filter_on)

  req <- sdmx_v2_1_data_request(
    resource = "data",
    flowRef = dfi$dataflow$flowRef,
    key = key,
    startPeriod = startPeriod,
    endPeriod = endPeriod,
    ...
  )

  # print(list(req = req))

  df <- req |> as.data.table()
  if (as.data.table){
    return(df)
  }
  data.table::setDF(df)

  # shitty return from SDMX rest, empty selection.
  # fixing it by returning a data.frame without rows.
  if (nrow(df) == 0){
    df <-
      # TODO improve this with measures
      c(dfi$dimensions$id, "OBS_VALUE", dfi$attributes$id) |>
      sapply(\(x) character()) |>
      as.data.frame()
  }

  if (isTRUE(raw)){
    return(df)
  }

  if (obs_value_numeric){
    df$OBS_VALUE <-
      as.numeric(df$OBS_VALUE) |>
      suppressWarnings()
  }

  # should the first column be dropped?
  if (isTRUE(drop_first_column)){
    df <- df[, -1]
  }

  # embellish data.frame with metadata
  dmnms <- dfi$dimensions$id

  cpts <- dfi$concepts
  has_concept <- names(df) %in% cpts$id

  dims <- dfi$dimensions
  idx <- dims$ref_codelist |> match(dfi$codelists$ref)
  codelists <- dfi$codelists[idx, "codes"]

  for (i in seq_along(dims$id)){
    cl <- codelists[[i]]
    id <- dims$id[i]
    if (!is.null(cl)){
      labels <- switch(
        dim_contents,
        both  = sprintf("%s: %s", cl$id, cl$name),
        label = cl$name,
        id    = cl$id,
        cl$id
      )
      df[[id]] <- df[[id]] |>
        factor(levels = cl$id, labels=labels)
    }
  }

  # CBS specific
  att <- dfi$attributes
  # att <- dfi$datastructure$attributes[[1]]
  if (!is.null(att)){
    # browser()
    idx <- match(att$ref_codelist, dfi$codelists$ref)
    codelists <- dfi$codelists[idx,"codes"]
    for (i in seq_along(att$id)){
      cl <- codelists[[i]]
      id <- att$id[i]
      if (!is.null(cl)){
        labels <- switch(
          attributes_contents,
          both  = sprintf("%s: %s", cl$id, cl$name),
          label = cl$name,
          id    = cl$id,
          cl$id
        )
        df[[id]] <- df[[id]] |>
          factor(levels = cl$id, labels=labels)
      }
    }
    # unit <- list(id = "UNIT_MEASURE")
    # um <- att |> subset(id == unit$id)
    # if (nrow(um) == 1){
    #   unit$codelist <- dfi$codelists |> subset(ref == um$cl_ref)
    #   unit$codes <- unit$codelist$codes[[1]]
    #   unit$name <- subset(dfi$concepts, ref == um$concept_ref)$name
    #
    #   recode <- unit$codes$name |> setNames(unit$codes$id)
    #   df[[unit$id]] <- recode[df[[unit$id]]]
    # }
  }
  df[has_concept] <- lapply(names(df)[has_concept], function(id) {
    x <- df[[id]]
    attr(x, "label") <- cpts$name[cpts$column_id == id]
    x
  })


  attr(df, "flowRef") <- dfi$dataflow$ref

  df
}
