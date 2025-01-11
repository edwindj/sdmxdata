get_dataflow_info2 <- function(
    flowRef,
    agencyID,
    id,
    version = "latest",
    language="nl",
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
      "Incomplete flow reference:", sQuote(flowRef)
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
    resource = "dataflow",
    agencyID = ref$agencyID,
    resourceID = ref$id,
    version = ref$version,
    detail = "full",
    references = "all",
    language = language
  )

  raw <- req |> get_structure_from_json(
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

  # collect all concepts
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


  dsd <- d$dataStructures
  dsd$ref <- extract_self_urn(dsd) |> strip_urn()
  # select the correct dsd
  dsd <- dsd[dsd$ref == dataflow$ref_dsd,]

  datastructure <- dsd |>
    subset(select = c("id", "agencyID", "version", "name", "ref")) |>
    as.list()

  dimensions <- dsd$dataStructureComponents$dimensionList$dimensions[[1]]
  dimensions$ref <- extract_self_urn(dimensions) |> strip_urn()
  dimensions$ref_concept <- dimensions$conceptIdentity |> strip_urn()
  dimensions$ref_codelist <- dimensions$localRepresentation$enumeration |> strip_urn()

  dimensions <- dimensions |>
    subset(select = c("id", "ref", "ref_concept", "ref_codelist", "position", "type"))

  o <- order(dimensions$position)
  dimensions <- dimensions[o,]

  atts <- dsd$dataStructureComponents$attributeList$attributes[[1]]
  atts$ref <- extract_self_urn(atts) |> strip_urn()
  atts$ref_concept <- atts$conceptIdentity |> strip_urn()
  atts$ref_codelist <- atts$localRepresentation$enumeration |> strip_urn()

  atts <- atts |>
    subset(select = c("id", "ref", "ref_concept", "ref_codelist", "assignmentStatus"))


  codelists <- d$codelists
  codelists$ref <- extract_self_urn(codelists) |> strip_urn()
  codelists$codes[] <- codelists$codes |>
    lapply(\(x){
      x$description <- if(is.null(x$description)) NA_character_ else x$description
      x$parent_id <- if(is.null(x$parent_id)) NA_character_ else x$parent_id
      x[,c("id", "name", "description", "parent_id")]
    })

  codelists <- codelists[,c("id", "agencyID", "version", "name", "codes", "ref")]

  concepts$column_id <- concepts$id

  # just to be sure, add a column id
  # it may be possible that the column id is not the same as the concept id
  # when the concepts are from shared concept schemes that is...
  dim_idx <- match(dimensions$ref_concept, concepts$ref)
  concepts$column_id[dim_idx] <- dimensions$id
  # add the concept names to the dimension
  dimensions$name <- concepts$name[dim_idx]

  att_idx <- match(atts$ref_concept, concepts$ref)
  concepts$column_id[att_idx] <- atts$id
  atts$name <- concepts$name[att_idx]

  #measure....

  dfi <- list(
    dataflow = dataflow,
    datastructure = datastructure,
    concepts = concepts,
    codelists = codelists,
    dimensions = dimensions,
    attributes = atts,
    raw = raw
  ) |>
  structure(class="dataflowinfo2")

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
print.dataflowinfo2 <- function(x, ...){
  cat("$dataflow: '", x$dataflow$name, "' [",x$dataflow$flowRef,"]\n", sep="")
  cat("$dimensions: ", x$dimensions$id |> sQuote() |> paste(collapse = ","), "\n", sep="")
  cat("$datastructure: '", x$datastructure$name, "' [",x$datastructure$id,"]\n", sep="")
  #TODO improve
  cat("$concepts: (",nrow(x$concepts),")", paste(sQuote(x$concepts$name), collapse = ","),"\n", sep="")
  cat("$codelists: ", nrow(x$codelists), "\n", sep="")
  cat("$raw: ", "...", "\n")
  invisible(x)
}
