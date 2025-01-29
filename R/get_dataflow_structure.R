#' Get information about a dataflow
#'
#' Get information and structure  about a dataflow. The dataflow can be identified
#' using `agencyID`, `id` and `version` or by using the `ref` argument.
#'
#' For most use cases the `agencyID` and `id` are to be preferred, as the `ref` argument
#' includes a specific version number of the dataflow. Not specifying a version number
#' will default to the latest version. If it is desirable to pin the reference of
#' the dataflow to a specific version, the `ref` argument can be used. The `ref`
#' argument can also be found in [list_dataflows()].
#' @param req A character string with the request to the dataflow
#' @param ref A string with the flow reference, in the form of "agencyID:id(version)". Overrules
#' the agencyID, id and version arguments.
#' @param agencyID The agency ID of the dataflow
#' @param id The id of the dataflow
#' @param version The version of the dataflow, defaults to "latest"
#' @param language The language of the metadata
#' @param verbose print some information on the console
#' @param cache_dir The directory to cache the data in, set to `NULL` to disable caching.
#' @return a list with the dataflow information
#' @importFrom data.table as.data.table
#' @export
get_dataflow_structure <- function(
    req = NULL,
    agencyID = getOption("sdmxdata.agencyID", NULL),
    id,
    version = "latest",
    ref,
    language= getOption("sdmxdata.language", "en"),
    cache_dir = tempdir(),
    verbose = getOption("sdmxdata.verbose", FALSE)
  ){
  # get the information for just one dataflow
  if (missing(ref) || is.null(ref)){
    eref <- list(
      agencyID = agencyID,
      id = id,
      version = version
    )
  } else {
    eref <- extract_ref(ref) |> as.list()
  }

  ref <- sprintf("%s:%s(%s)", eref$agencyID, eref$id, eref$version)

  if (is.null(eref$agencyID) || is.null(eref$id) || is.null(eref$version)){
    stop(
      "Incomplete/invalid reference to dataflow:", dQuote(ref)
    )
  }

  req <- sdmx_v2_1_structure_request(
    req = req,
    resource = "dataflow",
    agencyID = eref$agencyID,
    resourceID = eref$id,
    version = eref$version,
    detail = "full",
    references = "all",
    language = language
  )

  raw <- req |> get_structure_from_json(
    cache_key = paste(
      "dataflow",
      eref$agencyID,
      sprintf("%s_%s_%s", eref$id, eref$version, language),
      sep = "/"
    ),
    verbose = verbose, cache_dir = cache_dir
  )

  d <- raw$data
  # process the structure and make it simpler
  if (nrow(d$dataflows) == 0){
    stop("No dataflow found for: ", dQuote(ref))
  }

  if (nrow(d$dataflows) > 1){
    warning("More than one dataflow found, using the first one")
  }

  dataflow <- d$dataflows[1,]

  dataflow$ref <- extract_self_urn(dataflow) |> strip_urn()
  dataflow$ref_dsd <- dataflow$structure |> strip_urn()

  #useful because it can be used in the data request
  dataflow$flowRef <- paste(dataflow$agencyID, dataflow$id, dataflow$version, sep = ",")
  # browser()
  dataflow$description <- dataflow$description %||% NA_character_
  dataflow <- dataflow |>
    ensure(c("id", "agencyID", "version",
                      "name", "description", "ref", "ref_dsd", "flowRef"
                     )
          ) |>
    as.list()

  # collect all concepts, useful for dimension, measures and attributes
  concepts <-
    d$conceptSchemes$concepts |>
    lapply(function(x){
      x$ref <- extract_self_urn(x) |> strip_urn()
      x$ref_codelist <- x$coreRepresentation$enumeration |> strip_urn()
      x$textFormat <- x$coreRepresentation$textFormat$textType
      x <- x |> ensure(c("id", "name", "description", "ref", "ref_codelist","textFormat"))
      x
    }) |>
    data.table::rbindlist(fill = TRUE) |>
    as.data.frame()

  #process the codelists
  codelists <- d$codelists
  codelists$ref <- extract_self_urn(codelists) |> strip_urn()
  codelists$codes[] <- codelists$codes |>
    lapply(\(x){
      ensure(x, c("id", "name", "description", "parent_id"))
    })

  codelists <- codelists |> ensure(
    c("id", "agencyID", "version", "name", "codes", "ref")
  )

  dsd <- d$dataStructures
  dsd$ref <- extract_self_urn(dsd) |> strip_urn()
  # select the correct dsd
  dsd <- dsd[dsd$ref == dataflow$ref_dsd,]

  datastructure <- dsd |>
    ensure(c("id", "agencyID", "version", "name", "ref")) |>
    as.list()

  # extract the dimensions
  dimlist <- dsd$dataStructureComponents$dimensionList

  dimensions <- dimlist$dimensions[[1]]
  dimensions$ref <- extract_self_urn(dimensions) |> strip_urn()

  ref_concept <- dimensions$conceptIdentity |> strip_urn()
  concept <- concepts[match(ref_concept, concepts$ref),]
  dimensions$name <- concept$name
  dimensions$description <- concept$description

  dimensions$ref_codelist <- dimensions$localRepresentation$enumeration |> strip_urn()
  ref_codelist <- ifelse(is.na(dimensions$ref_codelist), concept$ref_codelist, dimensions$ref_codelist)
  codelist <- codelists[match(ref_codelist, codelists$ref),]
  dimensions$codes <- codelist$codes

  #TODO check for concept roles, like GEO / VARIABLE

  dimensions <- dimensions |>
    ensure(c("id", "name","description","codes","position", "type", "ref", "role"))

  time_dimensions <- dimlist$timeDimensions[[1]]
  if (!is.null(time_dimensions)){
    time_dimensions$ref <- extract_self_urn(time_dimensions) |> strip_urn()

    ref_concept <- time_dimensions$conceptIdentity |> strip_urn()
    concept <- concepts[match(ref_concept, concepts$ref),]
    time_dimensions$name <- concept$name
    time_dimensions$description <- concept$description
    time_dimensions$codes <- list(NULL)

    time_dimensions <-
      time_dimensions |> ensure(
        c("id", "name","description","codes","position", "type", "ref", "role")
      )
  }

  dimensions <- rbind(dimensions, time_dimensions)

  # sort the dimension by position. Needed for assembling key/filter_on
  o <- order(dimensions$position)
  dimensions <- dimensions[o,]

  measure <- dsd$dataStructureComponents$measureList$primaryMeasure
  measure$ref <- extract_self_urn(measure) |> strip_urn()
  ref_concept <- measure$conceptIdentity |> strip_urn()
  concept <- concepts[match(ref_concept, concepts$ref),]
  measure$name <- concept$name
  measure$description <- concept$description

  # not sure which has precedence, concept$textformat or measure$textformat
  measure$text_format <- switch(
    measure$localRepresentation$textFormat$textType,
    "String" = "character",
    "Double" = "numeric",
    "character"
  )
  measure <-
    measure |>
    ensure(c("id", "name", "description", "text_format", "ref"))

  atts <- dsd$dataStructureComponents$attributeList$attributes[[1]]
  if (!is.null(atts)){

    atts$ref <- extract_self_urn(atts) |> strip_urn()
    ref_concept <- atts$conceptIdentity |> strip_urn()
    concept <- concepts[match(ref_concept, concepts$ref),]
    atts$name <- concept$name
    atts$description <- concept$description
    atts$text_format <- concept$textFormat

    atts$ref_codelist <- atts$localRepresentation$enumeration |> strip_urn()
    ref_codelist <- ifelse(is.na(atts$ref_codelist), concept$ref_codelist, atts$ref_codelist)
    codelist <- codelists[match(ref_codelist, codelists$ref),]
    atts$codes <- codelist$codes
    atts <- atts |>
      ensure(c("id", "name", "description", "text_format", "codes", "ref"))

  }

  columns <- rbind(
    dimensions[,c("id", "name", "description")],
    measure[,c("id", "name", "description")],
    atts[,c("id", "name", "description")]
  )

  dimensions <- dimensions |>
    split(seq_len(nrow(dimensions))) |>
    lapply(\(x) {
      x <- x |>
        unlist(recursive = FALSE)
      x
    }) |>
    stats::setNames(dimensions$id) |>
    structure(class="sdmx_dimensions")


  measure <- measure |>
    as.list()

  if (!is.null(atts)){
    atts <- atts |>
      split(seq_len(nrow(atts))) |>
      lapply(\(x) unlist(x, recursive = FALSE)) |>
      stats::setNames(atts$id)
  }

  dfi <- list(
    id          = dataflow$id,
    agencyID    = dataflow$agencyID,
    version     = dataflow$version,
    name        = dataflow$name,
    description = dataflow$description,
    dimensions  = dimensions,
    measure     = measure,
    attributes  = atts,
    columns     = columns,
    ref         = dataflow$ref,
    flowRef     = dataflow$flowRef,
    raw_sdmx    = raw
  ) |>
  structure(class="dataflow_structure")

  dfi$default_selection <- get_default_selection(dfi)

  # oc$save(dfi)

  dfi
}

strip_urn <- function(x){
  if (is.null(x)){
    return(NA_character_)
  }
  sub("urn:.*=", "", x)
}

extract_self_urn <- function(x, prop = "links"){
  x[[prop]] |>
    lapply(\(x) x[x$rel == "self", ]$urn) |>
    unlist()
}

#' @export
print.dataflow_structure <- function(x, ...){
  cat(
    "Dataflow: [", x$ref, "]\n  ",
    # x$dataflow$id,": ",
    x$name |> dQuote(),
    "\n", sep=""
  )

  cat("  agency: ", dQuote(x$agencyID) ,
     ", id: ", x$id |> dQuote(),
     ", version: ", x$version |> dQuote(),
      "\n", sep="")

  cat("\nObservation columns: \n  ")
  paste0(
    x$columns$id |> dQuote(),
    collapse = ", "
  ) |> cat()

  # for (i in seq_len(nrow(x$dimensions))){
  #   id <- x$dimensions$id[i]
  #   name <- x$dimensions$name[i]
  #   cat(id, ": ", name |> dQuote(), ", ", sep="")
  # }

  # cat("\n  ")
  #
  # # for loop for measures
  # id <- x$measure$id
  # name <- x$measure$name
  # cat(id, ": ", name |> dQuote(), ", ", sep="")
  #
  # cat("\n  ")
  #
  #   for (i in seq_len(nrow(x$attributes))){
  #   id <- x$attributes$id[i]
  #   name <- x$attributes$name[i]
  #   cat(id, ": ", name |> dQuote(), ", ", sep="")
  #   }

  cat("\n\n")
  cat("Get a default selection of the observations with:\n")

  # def_sel <-
  #   get_default_selection(x) |>
  #   deparse(width.cutoff = 500, nlines = 1)

  cmd <- sprintf(
    'obs <- <provider>$get_observations(id="%s", agencyID="%s")',
    x$id,
    x$agencyID
  )

  cat("  ", cmd, "\n", sep="")

  cat("Get a default selection of the data with:\n")

  # def_sel <-
  #   get_default_selection(x) |>
  #   deparse(width.cutoff = 500, nlines = 1)

  cmd <- sprintf(
    'dat <- <provider>$get_data(id="%s", agencyID="%s", pivot="%s")',
    x$id,
    x$agencyID,
    tail(x$dimensions, 1)[[1]]$id
  )
  cat("  ", cmd, "\n", sep="")

  cat("\n")

  cat("\nProperties:\n ", sep="")
  paste0("$", names(x), collapse = ", ") |> cat()

  invisible(x)
}

#' @export
print.sdmx_dimensions <- function(x, ...){
  for (d in unclass(x)){
    cat("$", d$id, ":", d$name |> dQuote(), " (", nrow(d$codes), " codes)\n", sep="")
    cat("  ", "type: ", d$type,
        ", position: ", d$position,
       "\n", sep="")
  }
  invisible(x)
}
