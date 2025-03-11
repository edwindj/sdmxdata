#' Get observations from an SDMX provider
#'
#' Get observations from an SDMX provider. It retrieves the
#' data from the SDMX provider and returns it as a data.frame.
#'
#' By default the dimension and attribute columns are recoded to
#' factors with labels. This can be changed with the `dim_contents` and
#' `attributes_contents` arguments.
#' @param endpoint An endpoint, url or [httr2::request()] object.
#' @param agencyID The agency ID
#' @param id The id of the dataflow
#' @param version The version of the dataflow, default "latest"
#' @param ref The dataflow reference can be used in stead of agencyID, id and version
#' @param startPeriod The start period for which the data should be returned, works only for dataflows with an explicit time dimension.
#' @param endPeriod The end period for which the data should be returned, works only for dataflows with an explicit time dimension.
#' @param filter_on A named list of filters to apply to the data, if not specified or `list()`, it is the default selection, set to `NULL` to select all.
#' @param ... Additional parameters to pass to the request
#' @param dim_contents The contents of the dimension columns, either "label", "id" or "both"
#' @param use_factor if `TRUE` then dimension and attributes columns are factors, otherwise character
#' @param attributes_contents The contents of the attribute columns, either "label", "id" or "both"
#' @param obs_value_numeric Should the OBS_VALUE column be coerced to numeric? Default is `TRUE`
#' @param raw If `TRUE` return the raw data.frame from the SDMX, otherwise the data.frame is processed
#' @param language The language of the metadata
#' @param drop_first_columns Should the first columns be dropped? Default is `TRUE` (if not raw)
#' @param cache if `TRUE` cache the accompanying  meta data.
#' @param verbose If `TRUE` print information about the request
#' @param as.data.table If `TRUE` return a [data.table()], otherwise a [data.frame()]
#' @return [data.frame()] or [data.table::data.table()] depending on `as.data.table`
#' @example example/get_observations.R
#' @export
get_observations <- function(
    endpoint  = NULL,
    agencyID,
    id,
    version = "latest",
    ref = NULL,
    startPeriod = NULL,
    endPeriod = NULL,
    filter_on = list(),
    use_factor = TRUE,
    ...,
    language = NULL,
    as.data.table = FALSE,
    dim_contents = c("label", "both", "id"),
    attributes_contents = c("label", "id", "both"),
    obs_value_numeric = TRUE,
    raw = FALSE,
    drop_first_columns = !raw,
    cache = TRUE,
    verbose = getOption("sdmxdata.verbose", FALSE)
  ){

  endpoint <- sdmx_endpoint(endpoint)
  language <- language %||% endpoint$language
  verbose <- verbose | endpoint$verbose
  req <- endpoint$req

  if (missing(ref) && (missing(agencyID) || missing(id))){
    stop("Either `ref` or `agencyID` and `id` should be specified.", call. = FALSE)
  }

  dim_contents <- match.arg(dim_contents)
  attributes_contents <- match.arg(attributes_contents)

  dfi <- get_dataflow_structure(
    endpoint = endpoint,
    ref = ref,
    agencyID = agencyID,
    id = id,
    version = version,
    cache = cache,
    language = language,
    verbose = verbose
  )

  # dims <- get_dimensions(dfi)
  if (is.list(filter_on) && length(filter_on) == 0){
    filter_on <- dfi$default_selection

    if (!is.null(filter_on)){
      fl <- filter_on |>
        lapply(\(x) {
          deparse(x) |>
            paste(collapse = "")
        })
      fl2 <- paste("\t", names(fl),"=",fl, collapse = ",\n")
      message("\n* `filter_on` argument not specified, using default selection:\n "
             , "  filter_on = list(\n",
               fl2,
             "\n   )",
               "\n*  To select all data, set `filter_on` to `NULL`.\n"
             )

      if (is.null(startPeriod) && !is.null(filter_on$TIME_PERIOD_START)){
        message("`startPeriod` is not specified, using `TIME_PERIOD_START` from the default selection.\n")
        startPeriod <- filter_on$TIME_PERIOD_START
      }

      if (is.null(endPeriod) && !is.null(filter_on$TIME_PERIOD_END)){
        message("`endPeriod` is not specified, using `TIME_PERIOD_END` from the default selection.\n")
        endPeriod <- filter_on$TIME_PERIOD_END
      }

      # should be deleted because they clash with the values key are allow to have.
      filter_on$TIME_PERIOD_START <- NULL
      filter_on$TIME_PERIOD_END <- NULL
    }
  }

  key <- create_filter_key(dims = dfi$dimensions, filter_on)

  if (!("TIME_PERIOD" %in% names(dfi$dimensions)) && (!is.null(startPeriod) || !is.null(endPeriod))){
    warning("`startPeriod` and `endPeriod` are only implemented for ",
            "dataflows with an explicit time dimension.",
            call. = FALSE
          )
  }

  req <- sdmx_v2_1_data_request(
    endpoint = endpoint,
    resource = "data",
    flowRef = dfi$flowRef,
    key = key,
    startPeriod = startPeriod,
    endPeriod = endPeriod,
    ...,
    verbose = verbose
  )

  if (verbose){
    print(list(request = req))
  }

  # print(list(req = req))

  df <- req |> as.data.table()
  if (as.data.table){
    return(df)
  }
  data.table::setDF(df)

  # shitty return from SDMX v2.1 rest, empty selection returns a 404 error
  # "fixing" it by returning a data.frame of expected structure with 0 rows.
  if (nrow(df) == 0){
    df <-
      dfi$columns$id |>
      sapply(\(x) character()) |>
      as.data.frame()
  }

  if (isTRUE(raw)){
    return(df)
  }


  if (obs_value_numeric){
    value <- dfi$measure$id
    df[[value]] <-
      as.numeric(df[[value]]) |>
      suppressWarnings()
  }

  # should the first sdmx columns be dropped, contains "DATAFLOW"
  # if true keeps only the columns that are dimensions, measure and attributes
  if (isTRUE(drop_first_columns)){
    df <- df[,dfi$columns$id]
  }

  # embellish data.frame with metadata,

  # recode the dimension columns:
  for (d in dfi$dimensions){
    id <- d$id
    code <- d$codes
    if (!is.null(code) && is.character(code$id) && is.character(code$name)){
      labels <- switch(
        dim_contents,
        both  = sprintf("%s: %s", code$id, code$name),
        label = code$name,
        id    = code$id,
        code$id
      )
      f <- df[[id]] |>
        factor(levels = code$id, labels=labels)
      if (!isTRUE(use_factor)){
        f <- as.character(f)
      }
      df[[id]] <- f
    }
  }


  # recode the attribute columns:
  for (a in dfi$attributes){
      id <- a$id
      code <- a$codes
      if (!is.null(code)){
        labels <- switch(
          attributes_contents,
          both  = sprintf("%s: %s", code$id, code$name),
          label = code$name,
          id    = code$id,
          code$id
        )
        df[[id]] <- df[[id]] |>
          factor(levels = code$id, labels=labels)
      }
  }


  # mainly for the table `View` in RStudio, but also useful for other purposes
  columns <- dfi$columns
  columns <- columns[columns$id %in% names(df),]
  nms <- columns$name |> stats::setNames(columns$id)

  df[columns$id] <- lapply(columns$id, function(id) {
    x <- df[[id]]
    attr(x, "label") <- nms[id]
    x
  })


  attr(df, "ref_dataflow") <- dfi$ref

  df
}
