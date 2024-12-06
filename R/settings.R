
# metadata query
# https://ws-entry-point/resource/agencyID/resourceID/version/itemID?queryStringParameters
BASE_URL <- "https://sdmx-api.beta.cbs.nl/rest"

# datastructure, metadatastructure, categoryscheme, conceptscheme, codelist,
# hierarchicalcodelist, organisationscheme, agencyscheme, dataproviderscheme, dataconsumerscheme,
# organisationunitscheme, dataflow, metadataflow, reportingtaxonomy, provisionagreement, structureset, process,
# categorisation, contentconstraint, attachmentconstraint, actualconstraint, allowedconstraint, structure,
# transformationscheme, rulesetscheme, userdefinedoperatorscheme, customtypescheme, namepersonalisationscheme,
# vtlmappingscheme

get_url <- function(
    resource = c("dataflow", "datastructure", "codelist"),
    agencyID = "NL1",
    resourceID = "",
    version = "",
    itemID = ""){

  resource <- match.arg(resource)
  args <- list(BASE_URL,resource)

  for (i in c("agencyID", "resourceID", "version", "itemID")){
    val <- get(i)
    if (val == "") {break}

    vals <- paste(val, collapse = "+")
    args <- c(args, vals)
 }

 do.call(file.path, args)
}

