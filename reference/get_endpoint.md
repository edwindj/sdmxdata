# Connect to a SDMX endpoint

Connect to an SDMX endpoint

## Usage

``` r
get_endpoint(id, language = NULL, singleton = TRUE, verbose = FALSE)
```

## Arguments

- id:

  character, id of one of the available `endpoints`.

- language:

  character, the language to use for the text used in the response.

- singleton:

  logical, if `TRUE` return the same object if it already exists

- verbose:

  logical, if `TRUE` print information about the dataflows.

## Value

a SDMXEndpoint object

## See also

Other SDMX endpoints:
[`SDMXEndpoint`](https://edwindj.github.io/sdmxdata/reference/SDMXEndpoint.md),
[`sdmx_endpoint()`](https://edwindj.github.io/sdmxdata/reference/sdmx_endpoint.md)

## Examples

``` r
data("endpoints")
endpoints[, 1:3]
#>      id                               name
#> 1 ESTAT                           EUROSTAT
#> 2   LU1                             STATEC
#> 3   NL1 Centraal Bureau voor de Statistiek
#> 4  OECD                               OECD
#> 5   ABS                          AUSTRALIA
#> 6   BIS                                BIS
#> 7   FAO                                FAO
#> 8   ILO                                ILO
#> 9    UN                                 UN
#>                                                        url
#> 1 https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1
#> 2                           https://lustat.statec.lu/rest/
#> 3                        https://sdmx-api.beta.cbs.nl/rest
#> 4                        https://sdmx.oecd.org/public/rest
#> 5                         https://data.api.abs.gov.au/rest
#> 6                             https://stats.bis.org/api/v1
#> 7            https://nsi-release-ro-statsuite.fao.org/rest
#> 8                                https://sdmx.ilo.org/rest
#> 9                              https://data.un.org/ws/rest

OECD <- get_endpoint("OECD")
OECD$verbose <- TRUE
list_oecd <- OECD |> list_dataflows(cache=TRUE)
#> <sdmx_v2_1_structure_request/httr2_request>
#> GET https://sdmx.oecd.org/public/rest/dataflow
#> Headers:
#> * Accept-Language: "en"
#> * accept         : "application/vnd.sdmx.structure+json;version=1.0;"
#> Body: empty
#> [cached]: “/tmp/Rtmp8aOsK8/sdmxdata/OECD/sdmxdata/dataflows_en.json”
#> Available dataflows: 1448
#> Agencies: “ESTAT”, “IAEG-SDGs”, “OECD.CFE.EDS”, “OECD.CFE.RDG”, “OECD.CFE.SMEE”, “OECD.CFE.TOU”, “OECD.CTP.TAV”, “OECD.CTP.TPS”, “OECD.DAF”, “OECD.DAF.CM”, “OECD.DAF.COMP”, “OECD.DAF.INV”, “OECD.DCD.FSD”, “OECD.DEV.EMEA”, “OECD.DEV.LAC”, “OECD.DEV.NPG”, “OECD.DEV.RSDS”, “OECD.ECO.GCRD”, “OECD.ECO.MAD”, “OECD.ECO.MPD”, “OECD.EDU.ECS”, “OECD.EDU.IMEP”, “OECD.ELS.HD”, “OECD.ELS.IMD”, “OECD.ELS.JAI”, “OECD.ELS.SAE”, “OECD.ELS.SPD”, “OECD.ENV.EEI”, “OECD.ENV.EPI”, “OECD.GOV.GIP”, “OECD.GOV.PSI”, “OECD.ITF”, “OECD.SDD.NAD”, “OECD.SDD.NAD.SEEA”, “OECD.SDD.SDPS”, “OECD.SDD.STES”, “OECD.SDD.TPS”, “OECD.STI.DEP”, “OECD.STI.PIE”, “OECD.STI.STP”, “OECD.TAD.ADM”, “OECD.TAD.ARP”, “OECD.TAD.ATM”, “OECD.TAD.TPD”, “OECD.WISE.CWB”, “OECD.WISE.INE”, “OECD.WISE.RSB”, “OECD.WISE.WDP”
#> Content languages: “en”, “fr”
```
