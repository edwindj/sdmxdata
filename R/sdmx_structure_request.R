SDMX_STRUCTURES <-
  c("datastructure", "metadatastructure", "categoryscheme", "conceptscheme",
    "codelist", "hierarchicalcodelist", "organisationscheme", "agencyscheme",
    "dataproviderscheme", "dataconsumerscheme", "organisationunitscheme",
    "dataflow", "metadataflow", "reportingtaxonomy", "provisionagreement",
    "structureset", "process", "categorisation", "contentconstraint",
    "attachmentconstraint", "actualconstraint", "allowedconstraint",
    "structure", "transformationscheme", "rulesetscheme", "userdefinedoperatorscheme",
    "customtypescheme", "namepersonalisationscheme", "vtlmappingscheme")

#'@export
sdmx_structure_request <- function(
    req = NULL,
    resource = "dataflow",
    agencyID = NULL,
    resourceID = NULL,
    version = NULL,
    itemID = NULL,
    format = c("json", "xml"),
    ...,
    detail = c("full", "allstubs", "referencestubs", "allcompletestubs", "referencecompletestubs", "referencepartial"),
    references = c("none", "parents", "parentsandsiblings", "children", "descendants", "all")
){
  req <- get_base_request(req)
  resource <- match.arg(resource, choices = SDMX_STRUCTURES)

  path <- c(
    resource,
    agencyID,
    resourceID,
    version,
    itemID
  ) |>
    lapply(function(x) if (length(x)){paste(x, collapse = "+")}) |>
    paste(collapse = "/")

  req <- req |> httr2::req_template("GET /{path}")

  if (missing(detail)){
    detail <- NULL
  }

  if (!is.null(detail)){
    detail <- match.arg(detail)
  }

  if (missing(references)){
    references <- NULL
  }

  if (!is.null(references)){
    references <- match.arg(references)
  }

  req <- req |>
    httr2::req_url_query(
      detail     = detail,
      references = references
    )

  format <- match.arg(format)
  req <-
    switch(
      format,
      json = req |> httr2::req_headers(accept = "application/vnd.sdmx.structure+json;version=1.0;"),
      xml = req |> httr2::req_headers(accept = "application/vnd.sdmx.structure+xml;version=2.1;"),
      req
  )

  req
}

# req <- httr2::request("https://sdmx-api.beta.cbs.nl/rest") |>
#   sdmx_rest_data_query(resource = "data")
