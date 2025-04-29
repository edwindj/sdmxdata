list_categoryschemes <- function(
  req = NULL,
  agencyID = NULL,
  ...,
  language = "nl",
  cache_dir = tempdir(),
  raw = FALSE,
  verbose = getOption("sdmxdata.verbose", FALSE)
  ){

    agencyID <- if (is.null(agencyID)){
      NULL
    } else {
      agencyID |> paste0(collapse = "+")
    }

    req <-
      sdmx_v2_1_structure_request(
        req = req,
        resource = "categoryscheme",
        agencyID = agencyID,
        # format = "json",
        language = language
      )

    cache_key <- "categoryschemes"
    if (!is.null(agencyID)){
      cache_key <- paste0(cache_key, "_", agencyID)
    }

    if (!is.null(language)){
      cache_key <- paste0(cache_key, "_", language)
    }

    res <- req |>
      get_structure_from_json(
        cache_dir = cache_dir,
        cache_key = cache_key,
        verbose = verbose
      )

    was_cached <- isTRUE(attr(res, "was_cached"))

    if (isTRUE(raw)){
      return(res)
    }

    browser()
    # TODO provide a "raw" option that returns the full response of the SDMX v2.1 API
    cs <- res$data$categorySchemes

    # we add ref to the dataflows for convenience, to be used as a reference to a
    # dataflow
    cs$ref <- extract_self_urn(cs)


    dataflows <- dataflows |>
      ensure(c("agencyID", "id", "version", "name", "description", "ref"))

    # we add ref to the dataflows for convenience, to be used as a flowRef
    # dataflows$flowRef <- with(dataflows, {
    #   paste(agencyID, id, version, sep = ",")
    # })

    contentLanguages = res$meta$contentLanguages

    cs
}
