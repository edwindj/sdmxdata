# Get sdmx category schemes

Get sdmx categoryschemes from a given endpoint.

## Usage

``` r
list_categoryschemes(
  endpoint = NULL,
  agencyID = NULL,
  ...,
  language = "nl",
  cache = TRUE,
  raw = FALSE,
  verbose = getOption("sdmxdata.verbose", FALSE)
)
```

## Arguments

- endpoint:

  an endpoint, url or
  [`httr2::request()`](https://httr2.r-lib.org/reference/request.html)
  object.

- agencyID:

  A character string from a given agencyID.

- ...:

  saved for future use.

- language:

  The language to use for the text used in the response.

- cache:

  if `TRUE` cache the result.

- raw:

  If `TRUE` return the raw data from the SDMX, otherwise the data is
  processed.

- verbose:

  if `TRUE` print information about the dataflows.

## Value

a data.frame with available dataflows

## Examples

``` r
dfs <- list_dataflows(verbose = TRUE)
#> <sdmx_v2_1_structure_request/httr2_request>
#> GET https://sdmx-api.beta.cbs.nl/rest/dataflow
#> Headers:
#> * accept: "application/vnd.sdmx.structure+json;version=1.0;"
#> Body: empty
#> [cached]: “/tmp/Rtmp8aOsK8/sdmxdata/https_sdmx_api_beta_cbs_nl_rest/sdmxdata/dataflows.json”
#> Available dataflows: 430
#> Agencies: “NL1”, “NL1.CNVT”, “NL1_CA”, “NL1_DOUT”, “PT”
#> Content languages: “en”, “nl”

head(dfs)
#>   agencyID             id version
#> 1      NL1 DF_TESTSET_X01     1.0
#> 2      NL1 DF_TESTSET_X02     1.0
#> 3 NL1.CNVT       DF_00370     1.0
#> 4 NL1.CNVT    DF_03726ned     1.0
#> 5 NL1.CNVT       DF_03761     1.0
#> 6 NL1.CNVT       DF_03777     1.0
#>                                                                          name
#> 1                                       TESTSET (dataflow, only for TESTSET!)
#> 2                                       TESTSET (dataflow, only for TESTSET!)
#> 3 Redenen die een belangrijke rol speelden om uit huis gaan (OG'98),1960-1969
#> 4                                Prognose bevolking; kerncijfers, 2003 - 2009
#> 5                     Verkiezingsuitslag en zetelverdeling Tweede Kamer, 1963
#> 6                                                                Woonuitgaven
#>                      description                       ref
#> 1 for testing .Stat applications   NL1:DF_TESTSET_X01(1.0)
#> 2 for testing .Stat applications   NL1:DF_TESTSET_X02(1.0)
#> 3                           <NA>    NL1.CNVT:DF_00370(1.0)
#> 4                           <NA> NL1.CNVT:DF_03726ned(1.0)
#> 5                           <NA>    NL1.CNVT:DF_03761(1.0)
#> 6                           <NA>    NL1.CNVT:DF_03777(1.0)
```
