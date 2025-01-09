get_observations <- function(
    agencyID,
    id,
    version = "latest",
    flowRef = NULL,
    startPeriod = NULL,
    endPeriod = NULL,
    filter_on = NULL,
    ...,
    raw = FALSE,
    drop_first_column = !raw
  ){

  if (missing(flowRef) && (missing(agencyID) || missing(id))){
    return(NULL)
  }

  dfi <- get_dataflow_info(
    ref = flowRef,
    agencyID = agencyID,
    id = id,
    version = version
  )

  dims <- get_dimensions(dfi)
  key <- create_filter_key(dims, filter_on)

  df <- sdmx_v2_1_data_request(
    resource = "data",
    flowRef = dfi$dataflow$ref,
    key = key,
    startPeriod = startPeriod,
    endPeriod = endPeriod,
    ...
  ) |>
  as.data.frame()

  if (isTRUE(raw)){
    return(df)
  }

  # should the first column be dropped?
  if (isTRUE(drop_first_column)){
    df <- df[, -1]
  }

  # embellish data.frame with metadata
  dmnms <- names(dims)
  df[dmnms] <- lapply(dmnms, function(id) {
    x <- df[[id]]
    attr(x, "label") <- dims[[id]]$name
    x
  })

  browser()


  attr(df, "flowRef") <- dfi$dataflow$ref

  df
}


create_filter_key <- function(dims, filter_on){
  if (is.null(filter_on)){
    return(NULL)
  }

  # TODO filter out the TimeDimension in dims

  nms <- paste0("'", names(dims), "'", collapse = ",")

  if (!is.list(filter_on) || is.null(names(filter_on))){
    stop("'filter_on' must be a named list with at one or more of the",
         " following dimension names:\n  ", nms,
         call. = FALSE)
  }

  #check filter
  chk <- names(filter_on) %in% names(dims)
  if (!all(chk)){
    stop("'filter_on' contains invalid dimension name(s): ",
         paste0("'", names(filter_on)[!chk], "'", collapse = ","),
         "\n  It must be one of the following dimension names: ", nms,
         call. = FALSE
    )
  }

  # TODO check codes, generate a warning when a code is not found in the codelist
  # of a dimension

  key <- lapply(names(dims), function(id){
      paste(filter_on[[id]], collapse = "+")
    }) |>
    paste(collapse = ".")

  key
}
