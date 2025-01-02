get_dataflow_info <- function(ref, agencyID, id, version){
  if (missing(ref)){
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

  xml <- sdmx_v2_1_structure_request(
    resource = "dataflow",
    agencyID = ref$agencyID,
    resourceID = ref$id,
    version = ref$version,
    detail = "full",
    references = "all"
  ) |>
    sdmx_v2_1_as_xml()

  d <- xml |> sdmx_v2_1_parse_structure_xml()

  browser()

  dataflow <- d$dataflows[[1]]
  datastructure <- d$datastructures[[dataflow$dsd_ref]]
  # TODO improve next line
  conceptscheme <- d$conceptschemes[1,] |> as.list()
  codelists <- d$codelists

  list(
    dataflow = dataflow,
    datastructure = datastructure,
    conceptscheme = conceptscheme,
    codelists = codelists,
    raw = as.character(xml)
  ) |>
  structure(class="dataflowinfo")
}

#' @export
print.dataflowinfo <- function(x, ...){
  cat("$dataflow: '", x$dataflow$name, "' [",x$dataflow$id,"]\n", sep="")
  cat("$datastructure: '", x$datastructure$name, "' [",x$datastructure$id,"]\n", sep="")
  #TODO improve
  cat("$conceptscheme: '", x$conceptscheme$name, "' [",x$conceptscheme$id,"]\n",sep="")
  cat("\t$concepts: ", length(x$conceptscheme$concepts),"\n", sep="")
  cat("$codelists: ", length(x$codelists), "\n", sep="")
  cat("$raw: ", "...", "\n")
  invisible(x)
}
