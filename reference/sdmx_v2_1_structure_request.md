# Retrieve sdmx structure

Wrapper for the SDMX REST v2.1 interface for structured information

## Usage

``` r
sdmx_v2_1_structure_request(
  endpoint = NULL,
  resource = "dataflow",
  agencyID = NULL,
  resourceID = NULL,
  version = NULL,
  itemID = NULL,
  format = c("json", "xml"),
  language = NULL,
  ...,
  detail = c("full", "allstubs", "referencestubs", "allcompletestubs",
    "referencecompletestubs", "referencepartial"),
  references = c("none", "parents", "parentsandsiblings", "children", "descendants",
    "all")
)
```

## Arguments

- endpoint:

  An endpoint or an object that can be coerced to an endpoint

- resource:

  The resource to request. One of "datastructure", "metadatastructure",
  "categoryscheme", "conceptscheme", "codelist", "hierarchicalcodelist",
  "organisationscheme", "agencyscheme", "dataproviderscheme",
  "dataconsumerscheme", "organisationunitscheme", "dataflow",
  "metadataflow", "reportingtaxonomy", "provisionagreement",
  "structureset", "process", "categorisation", "contentconstraint",
  "attachmentconstraint", "actualconstraint", "allowedconstraint",
  "structure", "transformationscheme", "rulesetscheme",
  "userdefinedoperatorscheme", "customtypescheme",
  "namepersonalisationscheme", "vtlmappingscheme"

- agencyID:

  The agency ID to request

- resourceID:

  The resource ID to request

- version:

  The version to request

- itemID:

  The item ID to request

- format:

  The format to request. Either "json" or "xml"

- language:

  The language to use for the text used in the response

- ...:

  saved for future use

- detail:

  The detail of the data to return. Either "full", "allstubs",
  "referencestubs", "allcompletestubs", "referencecompletestubs",
  "referencepartial"

- references:

  The references to return. Either "none", "parents",
  "parentsandsiblings", "children", "descendants", "all"

## Value

a modified
[`httr2::request()`](https://httr2.r-lib.org/reference/request.html)
object
