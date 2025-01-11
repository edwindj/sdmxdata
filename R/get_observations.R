get_observations <- function(
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

  if (missing(flowRef) && (missing(agencyID) || missing(id))){
    return(NULL)
  }
  dim_contents <- match.arg(dim_contents)
  attributes_contents <- match.arg(attributes_contents)

  dfi <- get_dataflow_info2(
    flowRef = flowRef,
    agencyID = agencyID,
    id = id,
    version = version,
    verbose = verbose,
    cache_dir = cache_dir
  )

  # dims <- get_dimensions(dfi)

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

  df <- req |> as.data.frame()

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
    attr(x, "label") <- cpts$name[cpts$id == id]
    x
  })


  attr(df, "flowRef") <- dfi$dataflow$ref

  df
}
