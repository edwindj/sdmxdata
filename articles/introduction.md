# introduction

``` r
library(sdmxdata)
```

## Introduction

To retrieve a list of tables:

``` r
dfs <- list_dataflows(cache=FALSE)
dfs[, 1:5] |> 
  head()
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
#>                      description
#> 1 for testing .Stat applications
#> 2 for testing .Stat applications
#> 3                           <NA>
#> 4                           <NA>
#> 5                           <NA>
#> 6                           <NA>
```

To retrieve a dataflow info:

``` r
ref <- dfs$ref[4]
print(ref)
#> [1] "NL1.CNVT:DF_03726ned(1.0)"

df <- get_dataflow_structure(ref = ref)
df
#> Dataflow: [NL1.CNVT:DF_03726ned(1.0)]
#>   "Prognose bevolking; kerncijfers, 2003 - 2009"
#>   agency: "NL1.CNVT", id: "DF_03726ned", version: "1.0"
#> 
#> Observation columns: 
#>   "Topics", "Perioden", "OBS_VALUE", "UNIT_MEASURE", "UNIT_MULT", "OBS_MISSING", "DECIMALS", "OBS_STATUS"
#> 
#> Get a default selection of the observations with:
#>   obs <- get_observations(id="DF_03726ned", agencyID="NL1.CNVT")
#> Get a default selection of the data with:
#>   dat <- get_data(id="DF_03726ned", agencyID="NL1.CNVT", pivot="Perioden")
#> 
#> 
#> Properties:
#>  $id, $agencyID, $version, $name, $description, $dimensions, $measure, $attributes, $columns, $ref, $flowRef, $raw_sdmx, $default_selection
```

``` r
obs <-   obs <- get_observations(id="DF_37230ned", agencyID="NL1.CNVT")
#> 
#> * `filter_on` argument not specified, using default selection:
#>    filter_on = list(
#>   Perioden = c("2024MM01", "2024MM02", "2024MM03", "2024MM04", "2024MM05", "2024MM06", "2024MM07", "2024MM08", "2024MM09", "2024MM10", "2024MM11", "2024MM12", "2024JJ00"),
#>   RegioS = "NL01"
#>    )
#> *  To select all data, set `filter_on` to `NULL`.
```

``` r
head(obs)
#>      RegioS Perioden                                 Topics OBS_VALUE
#> 1 Nederland     2024 Bevolking aan het begin van de periode  17942942
#> 2 Nederland     2024                Levend geboren kinderen    165404
#> 3 Nederland     2024                            Overledenen    171945
#> 4 Nederland     2024                       Totale vestiging   1116236
#> 5 Nederland     2024   Vestiging vanuit een andere gemeente    802164
#> 6 Nederland     2024                             Immigratie    314072
#>   OBS_STATUS UNIT_MEASURE UNIT_MULT          OBS_MISSING
#> 1  Voorlopig       aantal  Eenheden het cijfer is bekend
#> 2  Voorlopig       aantal  Eenheden het cijfer is bekend
#> 3  Voorlopig       aantal  Eenheden het cijfer is bekend
#> 4  Voorlopig       aantal  Eenheden het cijfer is bekend
#> 5  Voorlopig       aantal  Eenheden het cijfer is bekend
#> 6  Voorlopig       aantal  Eenheden het cijfer is bekend
```
