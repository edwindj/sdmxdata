get_data <- function(
    agencyID,
    id,
    version = "latest",
    flowRef = NULL,
    startPeriod = NULL,
    endPeriod = NULL,
    filter_on = NULL,
    ...,
    dim_contents = c("label", "both", "id"),
    attributes_contents = c("label", "id", "both"),
    obs_value_numeric = TRUE,
    raw = FALSE,
    drop_first_column = !raw,
    cache_dir = tempdir(),
    verbose = getOption("cbsopendata.verbose", FALSE)
    ){

    dfi <- get_dataflow_info(
      agencyID = agencyID,
      id = id,
      version = version,
      flowRef = flowRef,
      cache_dir = cache_dir,
      verbose = verbose
    )

    if (missing(filter_on)){
      filter_on <- dfi$default_selection
    }

    obs <- get_observations(
      agencyID = agencyID,
      id = id,
      version = version,
      flowRef = flowRef,
      startPeriod = startPeriod,
      endPeriod = endPeriod,
      filter_on = filter_on,
      cache_dir = cache_dir,
      verbose = verbose,
      raw = TRUE
    )

    data.table::setDT(obs)

    dims <- names(dfi$dimensions)
    # CBS specific
    dims <- dims[dims != "Topics"]
    f <- "%s ~ Topics" |>
        sprintf(dims |> paste(collapse = " + ")) |>
        stats::as.formula()

    measure <- dfi$measure$name

    dta <- data.table::dcast(obs, f, value.var = measure)

    dta
}
