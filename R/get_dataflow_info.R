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

  dataflow <- d$dataflows[[1]]
  datastructure <- d$datastructures[[dataflow$dsd_ref]]
  # TODO improve next line
  conceptscheme <- d$conceptschemes[[1]]
  codelists <- d$codelists

  list(
    dataflow = dataflow,
    datastructure = datastructure,
    conceptscheme = conceptscheme,
    codelists = codelists,
    raw = as.character(xml)
    # ,
    # xml = as.character(xml)
  )
}
