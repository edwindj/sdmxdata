
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cbsopendata

<!-- badges: start -->

[![R-CMD-check](https://github.com/edwindj/cbsopendata/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edwindj/cbsopendata/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Work in progress, not to be used for production work.

## Installation

You can install the development version of cbsopendata from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("edwindj/cbsopendata")
```

## Example

``` r
library(cbsopendata)
```

To retrieve a list of tables:

``` r
dfs <- get_dataflows()
#> Available dataflows: 82
#> Agencies: 'NL1', 'NL1.CNVT', 'NL1_DOUT', 'PT'
#> Content languages: 'nl', 'en'
dfs[1:5, 1:4]
#>               id version agencyID isFinal
#> 1 DF_TESTSET_X01     1.0      NL1   FALSE
#> 2 DF_TESTSET_X02     1.0      NL1   FALSE
#> 3    DF_24103NED     1.0 NL1.CNVT   FALSE
#> 4    DF_37230ned     1.0 NL1.CNVT   FALSE
#> 5       DF_37852     1.0 NL1.CNVT   FALSE
```

To retrieve a dataflow info:

``` r
flowRef <- dfs$flowRef[4]
print(flowRef)
#> [1] "NL1.CNVT,DF_37230ned,1.0"

df <- get_dataflow_info(flowRef = flowRef)
df
#> DF_37230ned: 'Bevolkingsontwikkeling; regio per maand' [NL1.CNVT,DF_37230ned,1.0]
#> 
#> Columns: 
#>   RegioS: 'Regio's', Perioden: 'Perioden', Topics: 'Onderwerpen', 
#>   OBS_VALUE: 'Waarneming', 
#>   OBS_STATUS: 'Publicatiestatus', UNIT_MEASURE: 'Meeteenheden', UNIT_MULT: 'Vermenigvuldigfactor', 
#> 
#> Get a default selection of the data with:
#>   obs <- get_observations(id="DF_37230ned", agencyID="NL1.CNVT")
#> 
#> Properties:
#>  $dataflow, $datastructure, $concepts, $codelists, $dimensions, $attributes, $raw
```

``` r
obs <-   obs <- get_observations(id="DF_37230ned", agencyID="NL1.CNVT")
#> `filter_on` argument not specified, using default selection:
#>  filter_on=list(Perioden = c("2024MM01", "2024MM02", "2024MM03", "2024MM04", "2024MM05", "2024MM06", "2024MM07", "2024MM08", "2024MM09", "2024MM10"), RegioS = "NL01")
```

``` r
head(obs)
#>      RegioS     Perioden                                 Topics OBS_VALUE
#> 1 Nederland 2024 januari Bevolking aan het begin van de periode  17942942
#> 2 Nederland 2024 januari                Levend geboren kinderen     13582
#> 3 Nederland 2024 januari                            Overledenen     16825
#> 4 Nederland 2024 januari                       Totale vestiging     93019
#> 5 Nederland 2024 januari   Vestiging vanuit een andere gemeente     68204
#> 6 Nederland 2024 januari                             Immigratie     24815
#>   OBS_STATUS UNIT_MEASURE UNIT_MULT
#> 1  Voorlopig       aantal  Eenheden
#> 2  Voorlopig       aantal  Eenheden
#> 3  Voorlopig       aantal  Eenheden
#> 4  Voorlopig       aantal  Eenheden
#> 5  Voorlopig       aantal  Eenheden
#> 6  Voorlopig       aantal  Eenheden
```
