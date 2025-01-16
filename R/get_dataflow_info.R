#' Get information about a dataflow
#'
#' Get infomration about a dataflow
#' @param req A character string with the request to the dataflow
#' @param flowRef A string with the flow reference, in the form of "agencyID,id,version"
#' @param id The id of the dataflow
#' @param version The version of the dataflow, defaults to "latest"
#' @param agencyID The agency ID of the dataflow, defaults to "NL1"
#' @param language The language of the metadata, defaults to "nl"
#' @param verbose print some information on the console
#' @param cache_dir The directory to cache the data in, set to `NULL` to disable caching.
#' @return a list with the dataflow information
#' @importFrom data.table as.data.table
#' @export
get_dataflow_info <- function(
    req = NULL,
    flowRef,
    id,
    version = "latest",
    agencyID = getOption("cbsopendata.agencyID", "NL1"),
    language= getOption("cbsopendata.language", "nl"),
    cache_dir = tempdir(),
    verbose = getOption("cbsopendata.verbose", FALSE)
  ){
  # get the information for just one dataflow

  if (missing(flowRef) || is.null(flowRef)){
    ref <- list(
      agencyID = agencyID,
      id = id,
      version = version
    )
  } else {
  ref <- strsplit(flowRef, ",") |>
    unlist() |>
    as.list()
  }
  names(ref) <- c("agencyID", "id", "version")
  flowRef <- paste(ref$agencyID, ref$id, ref$version, sep = ",")

  if (is.null(ref$agencyID) || is.null(ref$id) || is.null(ref$version)){
    stop(
      "Incomplete flow reference:", dQuote(flowRef)
    )
  }

  # oc <- ObjectCache(
  #   key = paste("dataflowinfo2", flowRef, sep = "_"),
  #   cache_dir = cache_dir,
  #   verbose = verbose
  # )
  #
  # if (oc$is_cached()){
  #   return(oc$get())
  # }

  req <- sdmx_v2_1_structure_request(
    req = req,
    resource = "dataflow",
    agencyID = ref$agencyID,
    resourceID = ref$id,
    version = ref$version,
    detail = "full",
    references = "all",
    language = language
  )

  raw <- req |> get_structure_from_json(
    cache_key = paste(
      "dataflow",
      gsub(",", "_",flowRef),
      sep = "_"
    ),
    verbose = verbose, cache_dir = cache_dir
  )

  d <- raw$data
  # process the structure and make it simpler
  if (nrow(d$dataflows) == 0){
    stop("Not a valid selection")
  }

  if (nrow(d$dataflows) > 1){
    warning("More than one dataflow found, using the first one")
  }

  dataflow <- d$dataflows[1,]

  dataflow$ref <- extract_self_urn(dataflow) |> strip_urn()
  dataflow$ref_dsd <- dataflow$structure |> strip_urn()

  # useful because it can be used in the data request
  dataflow$flowRef <- paste(dataflow$agencyID, dataflow$id, dataflow$version, sep = ",")
  dataflow <- dataflow |>
    subset(select = c("id", "agencyID", "version",
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

      x$description <- if (is.null(x$description)) NA_character_ else x$description
      x[,c("id", "name", "description", "ref", "ref_codelist","textFormat")]
    }) |>
    data.table::rbindlist(fill = TRUE) |>
    as.data.frame()

  #process the codelists
  codelists <- d$codelists
  codelists$ref <- extract_self_urn(codelists) |> strip_urn()
  codelists$codes[] <- codelists$codes |>
    lapply(\(x){
      x$description <- if(is.null(x$description)) NA_character_ else x$description
      x$parent_id <- if(is.null(x$parent_id)) NA_character_ else x$parent_id
      x[,c("id", "name", "description", "parent_id")]
    })

  codelists <- codelists[,c("id", "agencyID", "version", "name", "codes", "ref")]

  dsd <- d$dataStructures
  dsd$ref <- extract_self_urn(dsd) |> strip_urn()
  # select the correct dsd
  dsd <- dsd[dsd$ref == dataflow$ref_dsd,]

  datastructure <- dsd |>
    subset(select = c("id", "agencyID", "version", "name", "ref")) |>
    as.list()

  # extract the dimensions
  dimlist <- dsd$dataStructureComponents$dimensionList

  dimensions <- dimlist$dimensions[[1]]
  dimensions$ref <- extract_self_urn(dimensions) |> strip_urn()

  ref_concept <- dimensions$conceptIdentity |> strip_urn()
  concept <- concepts[match(ref_concept, concepts$ref),]
  dimensions$name <- concept$name
  dimensions$description <- concept$description

  codelist <- codelists[match(concept$ref_codelist, codelists$ref),]
  dimensions$codes <- codelist$codes

  dimensions <- dimensions[, c("id", "name","description","codes",
                               "position", "type", "ref"
                               )
  ]

  time_dimensions <- dimlist$timeDimensions[[1]]
  if (!is.null(time_dimensions)){
    time_dimensions$ref <- extract_self_urn(time_dimensions) |> strip_urn()

    ref_concept <- time_dimensions$conceptIdentity |> strip_urn()
    concept <- concepts[match(ref_concept, concepts$ref),]
    time_dimensions$name <- concept$name
    time_dimensions$description <- concept$description
    time_dimensions$codes <- list(NULL)

    time_dimensions <- time_dimensions[, c("id", "name","description","codes",
                                 "position", "type", "ref"
    )]
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
    measure[, c("id", "name", "description", "text_format", "ref")]

  atts <- dsd$dataStructureComponents$attributeList$attributes[[1]]
  if (!is.null(atts)){

    atts$ref <- extract_self_urn(atts) |> strip_urn()
    ref_concept <- atts$conceptIdentity |> strip_urn()
    concept <- concepts[match(ref_concept, concepts$ref),]
    atts$name <- concept$name
    atts$description <- concept$description
    atts$text_format <- concept$textFormat

    codelist <- codelists[match(concept$ref_codelist, codelists$ref),]
    atts$codes <- codelist$codes
    atts <-
      atts[, c("id", "name", "description", "text_format", "codes", "ref")]

  }

  columns <- rbind(
    dimensions[,c("id", "name", "description")],
    measure[,c("id", "name", "description")],
    atts[,c("id", "name", "description")]
  )

  dimensions <- dimensions |>
    split(seq_len(nrow(dimensions))) |>
    lapply(\(x) unlist(x, recursive = FALSE)) |>
    stats::setNames(dimensions$id)

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
  structure(class="dataflow_info")

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
print.dataflow_info <- function(x, ...){
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

  cat("\nColumns: \n  ")
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
  cat("Get a default selection of the data with:\n")


  # def_sel <-
  #   get_default_selection(x) |>
  #   deparse(width.cutoff = 500, nlines = 1)

  cmd <- sprintf(
'obs <- get_observations(id="%s", agencyID="%s")',
  x$id,
  x$agencyID
)

  cat("  ", cmd, "\n", sep="")

  cat("\nProperties:\n ", sep="")
  paste0("$", names(x), collapse = ", ") |> cat()

  invisible(x)
}
