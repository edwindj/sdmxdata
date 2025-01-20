get_dataflow_structure_xml <- function(ref, agencyID, id, version = "latest", language="nl",
                              verbose=getOption("sdmxdata.verbose", FALSE)
                            ){
  if (missing(ref) || is.null(ref)){
    ref <- list(
      agencyID = agencyID,
      id = id,
      version = version
    )
  } else {
  ref <- strsplit(ref, ",") |>
    unlist() |>
    as.list()
  }
  names(ref) <- c("agencyID", "id", "version")

  if (is.null(ref$agencyID) | is.null(ref$id) | is.null(ref$version)){
    return(NULL)
  }

  req <- sdmx_v2_1_structure_request(
    resource = "dataflow",
    agencyID = ref$agencyID,
    resourceID = ref$id,
    version = ref$version,
    detail = "full",
    references = "all",
    language = language
  )

  xml <- req |>
    xml2::as_xml_document(verbose = verbose)

  # json <- req |> get_structure_from_json()

  d <- xml |> xml_parse_structure()

  dataflow <- d$dataflows[1,]
  datastructure <- d$datastructures[1,]

  # collect all concepts
  concepts <-
    d$conceptschemes$concepts |>
    data.table::rbindlist(fill = TRUE) |>
    as.data.frame()

  codelists <- d$codelists

  recoder <- list()

  list(
    dataflow = dataflow,
    datastructure = datastructure,
    concepts = concepts,
    codelists = codelists,
    raw = as.character(xml)
  ) |>
  structure(class="dataflowinfoxml")
}

#' @export
print.dataflowinfoxml <- function(x, ...){
  cat("$dataflow: '", x$dataflow$name, "' [",x$dataflow$id,"]\n", sep="")
  cat("$datastructure: '", x$datastructure$name, "' [",x$datastructure$id,"]\n", sep="")
  #TODO improve
  cat("$concepts: ", nrow(x$concepts),"\n", sep="")
  cat("$codelists: ", nrow(x$codelists), "\n", sep="")
  cat("$raw: ", "...", "\n")
  invisible(x)
}
