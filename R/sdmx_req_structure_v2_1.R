SDMX_STRUCTURES <-
  c("datastructure", "metadatastructure", "categoryscheme", "conceptscheme",
    "codelist", "hierarchicalcodelist", "organisationscheme", "agencyscheme",
    "dataproviderscheme", "dataconsumerscheme", "organisationunitscheme",
    "dataflow", "metadataflow", "reportingtaxonomy", "provisionagreement",
    "structureset", "process", "categorisation", "contentconstraint",
    "attachmentconstraint", "actualconstraint", "allowedconstraint",
    "structure", "transformationscheme", "rulesetscheme", "userdefinedoperatorscheme",
    "customtypescheme", "namepersonalisationscheme", "vtlmappingscheme")

#'Retrieve sdmx structure
#'
#' Wrapper for the SDMX REST v2.1 interface for structured information
#'
#' @param req An endpoint or an httr2 request object
#' @param resource The resource to request. One of "datastructure", "metadatastructure", "categoryscheme", "conceptscheme", "codelist", "hierarchicalcodelist", "organisationscheme", "agencyscheme", "dataproviderscheme", "dataconsumerscheme", "organisationunitscheme", "dataflow", "metadataflow", "reportingtaxonomy", "provisionagreement", "structureset", "process", "categorisation", "contentconstraint", "attachmentconstraint", "actualconstraint", "allowedconstraint", "structure", "transformationscheme", "rulesetscheme", "userdefinedoperatorscheme", "customtypescheme", "namepersonalisationscheme", "vtlmappingscheme"
#' @param agencyID The agency ID to request
#' @param resourceID The resource ID to request
#' @param version The version to request
#' @param itemID The item ID to request
#' @param format The format to request. Either "json" or "xml"
#' @param detail The detail of the data to return. Either "full", "allstubs", "referencestubs", "allcompletestubs", "referencecompletestubs", "referencepartial"
#' @param references The references to return. Either "none", "parents", "parentsandsiblings", "children", "descendants", "all"
#' @param ... saved for future use
#' @return a modified [httr2::request()] object
#'@export
sdmx_req_structure_v2_1 <- function(
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
  req <- sdmx_endpoint(req)
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
#   sdmx_req_data_v2_1(resource = "data")
