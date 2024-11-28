
# Placeholder with simple test
url <- "https://sdmx-api.beta.cbs.nl/rest/data/NL1,DF_TESTSET_X01,1.0/all?dimensionAtObservation=AllDimensions"
get_json(url)


# get meta
meta <- "https://sdmx-api.beta.cbs.nl/rest/dataflow/NL1/DF_TESTSET_X01/1.0?references=all"

get_json(meta)

