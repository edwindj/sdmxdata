
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sdmxdata

<!-- badges: start -->

[![R-CMD-check](https://github.com/edwindj/sdmxdata/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edwindj/sdmxdata/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

Work in progress, not to be used for production work.

## Installation

You can install the development version of sdmxdata from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("edwindj/sdmxdata")
```

## Example

``` r
library(sdmxdata)
```

To retrieve a list of tables:

``` r
dfs <- list_dataflows()
#> Available dataflows: 82
#> Agencies: "NL1", "NL1.CNVT", "NL1_DOUT", "PT"
#> Content languages: "nl", "en"
dfs[,1:5] |> 
  head()
#>               id version agencyID isFinal
#> 1 DF_TESTSET_X01     1.0      NL1   FALSE
#> 2 DF_TESTSET_X02     1.0      NL1   FALSE
#> 3    DF_24103NED     1.0 NL1.CNVT   FALSE
#> 4    DF_37230ned     1.0 NL1.CNVT   FALSE
#> 5       DF_37852     1.0 NL1.CNVT   FALSE
#> 6    DF_50012NED     1.0 NL1.CNVT   FALSE
#>                                                                       name
#> 1                                TESTSET (dataflow, only use for TESTSET!)
#> 2                                 TESTSET (dataflow, alleen voor TESTSET!)
#> 3                               Mbo; deelnemers, leerweg, opleiding, regio
#> 4                                  Bevolkingsontwikkeling; regio per maand
#> 5 Gezondheid, leefstijl, zorggebruik en -aanbod, doodsoorzaken; vanaf 1900
#> 6                              Geneesmiddelen; kosten en gebruik 2010-2015
```

To retrieve a dataflow structure:

``` r
flowRef <- dfs$flowRef[4]
print(flowRef)
#> [1] "NL1.CNVT,DF_37230ned,1.0"

df <- get_dataflow_structure(flowRef = flowRef)
df
#> Dataflow: [NL1.CNVT:DF_37230ned(1.0)]
#>   "Bevolkingsontwikkeling; regio per maand"
#>   agency: "NL1.CNVT", id: "DF_37230ned", version: "1.0"
#> 
#> Columns: 
#>   "RegioS", "Perioden", "Topics", "OBS_VALUE", "OBS_STATUS", "UNIT_MEASURE", "UNIT_MULT"
#> 
#> Get a default selection of the data with:
#>   obs <- get_observations(id="DF_37230ned", agencyID="NL1.CNVT")
#> 
#> Properties:
#>  $id, $agencyID, $version, $name, $description, $dimensions, $measure, $attributes, $columns, $ref, $flowRef, $raw_sdmx, $default_selection
```

To retrieve data use `get_data`

``` r
data <- get_data(flowRef = flowRef, pivot="Topics")
#> 
#> * `filter_on` argument not specified, using default selection:
#>    filter_on = list(
#>   Perioden = c("2024MM01", "2024MM02", "2024MM03", "2024MM04", "2024MM05", "2024MM06", "2024MM07", "2024MM08", "2024MM09", "2024MM10"),
#>   RegioS = "NL01"
#>    )
#> *  To select all data, set `filter_on` to `NULL`.
head(data)
#>      RegioS      Perioden BevolkingAanHetBeginVanDePeriode_1
#> 1 Nederland  2024 januari                           17942942
#> 2 Nederland 2024 februari                           17946556
#> 3 Nederland    2024 maart                           17955743
#> 4 Nederland    2024 april                           17962763
#> 5 Nederland      2024 mei                           17970044
#> 6 Nederland     2024 juni                           17977676
#>   BevolkingAanHetEindeVanDePeriode_15 BevolkingsgroeiRelatief_12
#> 1                            17946556                       0.02
#> 2                            17955743                       0.05
#> 3                            17962763                       0.04
#> 4                            17970044                       0.04
#> 5                            17977676                       0.04
#> 6                            17981933                       0.02
#>   BevolkingsgroeiSinds1JanuariRela_14 BevolkingsgroeiSinds1Januari_13
#> 1                                0.02                            3614
#> 2                                0.07                           12801
#> 3                                0.11                           19821
#> 4                                0.15                           27102
#> 5                                0.19                           34734
#> 6                                0.22                           38991
#>   Bevolkingsgroei_11 EmigratieInclusiefAdmCorrecties_9 Immigratie_6
#> 1               3614                             17958        24815
#> 2               9187                             15621        27110
#> 3               7020                             14137        22850
#> 4               7281                             13455        21837
#> 5               7632                             13429        20651
#> 6               4257                             16979        20478
#>   LevendGeborenKinderen_2 OverigeCorrecties_10 Overledenen_3
#> 1                   13582                   NA         16825
#> 2                   12893                   NA         15195
#> 3                   13527                   NA         15220
#> 4                   13171                   NA         14272
#> 5                   14254                   NA         13844
#> 6                   13831                   NA         13073
#>   TotaalVertrekInclAdmCorrecties_7 TotaleVestiging_4
#> 1                            86162             93019
#> 2                            79128             90617
#> 3                            79026             87739
#> 4                            74843             83225
#> 5                            74837             82059
#> 6                            76737             80236
#>   VertrekNaarAndereGemeente_8 VestigingVanuitEenAndereGemeente_5
#> 1                       68204                              68204
#> 2                       63507                              63507
#> 3                       64889                              64889
#> 4                       61388                              61388
#> 5                       61408                              61408
#> 6                       59758                              59758
```

Or get the underlying observations with `get_observations`

``` r
obs <- get_observations(id="DF_37230ned", agencyID="NL1.CNVT")
#> 
#> * `filter_on` argument not specified, using default selection:
#>    filter_on = list(
#>   Perioden = c("2024MM01", "2024MM02", "2024MM03", "2024MM04", "2024MM05", "2024MM06", "2024MM07", "2024MM08", "2024MM09", "2024MM10"),
#>   RegioS = "NL01"
#>    )
#> *  To select all data, set `filter_on` to `NULL`.
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
