
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sdmxdata

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/sdmxdata)](https://CRAN.R-project.org/package=sdmxdata)
[![R-CMD-check](https://github.com/edwindj/sdmxdata/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/edwindj/sdmxdata/actions/workflows/R-CMD-check.yaml)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
<!-- badges: end -->

## Introduction

*Work in progress, not to be used for production work*

Why `sdmxdata`? The package is designed to provide a simple interface to
retrieve and select data from open statistical data providers that
support the SDMX v2.1 REST API.

It focusses on:

- retrieving lists of dataflows: `list_dataflows`, for getting an
  overview of the available tables (aka dataflows) at a data provider,
  including their descriptions.

- retrieving the structure of a dataflow: `get_dataflow_structure`, for
  getting detailed information on the structure and metadata of a
  dataflow.

- retrieving data: `get_data` and `get_observations` for selecting and
  retrieving data from a dataflow. Both functions allow for easy
  filtering on dimensions, reporting periods, and other metadata.

- retrieving lists of agencies and subagencies: `list_agencies`, for
  getting an overview of the agencies.

It does not implement a full fledged SDMX metadata model or data model.
For that, you can use
[`rsdmx`](https://CRAN.R-project.org/package=rsdmx).

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
CBSbeta <- sdmxdata::get_endpoint("NL1")
dfs <- CBSbeta |> list_dataflows()
dfs[,1:5] |> 
  head()
#>   agencyID             id version
#> 1      NL1 DF_TESTSET_X01     1.0
#> 2      NL1 DF_TESTSET_X02     1.0
#> 3 NL1.CNVT       DF_00370     1.0
#> 4 NL1.CNVT    DF_03726ned     1.0
#> 5 NL1.CNVT       DF_03761     1.0
#> 6 NL1.CNVT       DF_03777     1.0
#>                                                                          name
#> 1                                    TESTSET (dataflow, alleen voor TESTSET!)
#> 2                                    TESTSET (dataflow, alleen voor TESTSET!)
#> 3 Redenen die een belangrijke rol speelden om uit huis gaan (OG'98),1960-1969
#> 4                                Prognose bevolking; kerncijfers, 2003 - 2009
#> 5                     Verkiezingsuitslag en zetelverdeling Tweede Kamer, 1963
#> 6                                                                Woonuitgaven
#>   description
#> 1        <NA>
#> 2        <NA>
#> 3        <NA>
#> 4        <NA>
#> 5        <NA>
#> 6        <NA>
```

``` r
OECD <- sdmxdata::get_endpoint("OECD")
dfs_oecd <- OECD |> list_dataflows()
dfs_oecd[,1:5] |> 
  head()
#>       agencyID                            id version
#> 1        ESTAT                    SEEA_AEA_A     1.4
#> 2 OECD.CFE.EDS DSD_FUA_CLIM@DF_COASTAL_FLOOD     1.1
#> 3 OECD.CFE.EDS         DSD_FUA_CLIM@DF_FIRES     1.1
#> 4 OECD.CFE.EDS   DSD_FUA_CLIM@DF_HEAT_STRESS     1.1
#> 5 OECD.CFE.EDS        DSD_FUA_CLIM@DF_PRECIP     1.1
#> 6 OECD.CFE.EDS   DSD_FUA_CLIM@DF_RIVER_FLOOD     1.1
#>                                 name description
#> 1             Air Emissions Accounts        <NA>
#> 2 Coastal flooding - Cities and FUAs        <NA>
#> 3        Wildfires - Cities and FUAs        <NA>
#> 4      Heat stress - Cities and FUAs        <NA>
#> 5               Precipitation - FUAs        <NA>
#> 6   River flooding - Cities and FUAs        <NA>
```

To retrieve a dataflow structure:

``` r
dataflow_ref <- dfs$ref[4]
print(dataflow_ref)
#> [1] "NL1.CNVT:DF_03726ned(1.0)"

dsd <- CBSbeta |> get_dataflow_structure(ref = dataflow_ref)
dsd
#> Dataflow: [NL1.CNVT:DF_03726ned(1.0)]
#>   "Prognose bevolking; kerncijfers, 2003 - 2009"
#>   agency: "NL1.CNVT", id: "DF_03726ned", version: "1.0"
#> 
#> Observation columns: 
#>   "Topics", "Perioden", "OBS_VALUE", "UNIT_MEASURE", "UNIT_MULT", "OBS_MISSING", "DECIMALS", "OBS_STATUS"
#> 
#> Get a default selection of the observations with:
#>   obs <- CBSbeta |> get_observations(id="DF_03726ned", agencyID="NL1.CNVT")
#> Get a default selection of the data with:
#>   dat <- CBSbeta |> get_data(id="DF_03726ned", agencyID="NL1.CNVT", pivot="Perioden")
#> 
#> 
#> Properties:
#>  $id, $agencyID, $version, $name, $description, $dimensions, $measure, $attributes, $columns, $ref, $flowRef, $raw_sdmx, $default_selection
```

To retrieve data use `get_data`

``` r
data <- CBSbeta |> get_data(agencyID=dsd$agencyID, id = dsd$id, pivot="Topics")
#> 
#> * `filter_on` argument not specified, using default selection:
#>    filter_on = list(
#>   Perioden = c("2003JJ00", "2004JJ00", "2005JJ00", "2006JJ00", "2007JJ00", "2008JJ00", "2009JJ00"),
#>   Topics = c("TotaleBevolking_1", "k_0Tot20Jaar_2", "k_20Tot65Jaar_3", "k_65JaarOfOuder_4", "k_0Tot20Jaar_5", "k_20Tot65Jaar_6", "k_65JaarOfOuder_7", "DemografischeDruk_8", "Levendgeborenen_9", "TotaalVruchtbaarheidscijfer_10", "Overledenen_11", "LevensverwachtingMannen_12", "LevensverwachtingVrouwen_13", "Immigratie_14", "EmigratieInclSaldoAdmCorrecties_15", "MigratiesaldoInclSaldoAdmCorr_16")
#>    )
#> *  To select all data, set `filter_on` to `NULL`.
head(data)
#>   Perioden Topics:DemografischeDruk_8 Topics:EmigratieInclSaldoAdmCorrecties_15
#> 1     2003                      0.619                                    102102
#> 2     2004                      0.624                                    102058
#> 3     2005                      0.627                                    102025
#> 4     2006                      0.631                                     97598
#> 5     2007                      0.632                                     91274
#> 6     2008                      0.634                                     88016
#>   Topics:Immigratie_14 Topics:Levendgeborenen_9
#> 1               102095                   203607
#> 2               100019                   196965
#> 3               100086                   193086
#> 4               104190                   189459
#> 5               107832                   186294
#> 6               112589                   183829
#>   Topics:LevensverwachtingMannen_12 Topics:LevensverwachtingVrouwen_13
#> 1                             76.15                              80.75
#> 2                             76.38                               80.7
#> 3                             76.47                              80.69
#> 4                             76.55                              80.69
#> 5                             76.68                              80.69
#> 6                              76.8                              80.69
#>   Topics:MigratiesaldoInclSaldoAdmCorr_16 Topics:Overledenen_11
#> 1                                      -6                141506
#> 2                                   -2039                142817
#> 3                                   -1939                145188
#> 4                                    6593                147526
#> 5                                   16558                149482
#> 6                                   24573                151442
#>   Topics:TotaalVruchtbaarheidscijfer_10 Topics:TotaleBevolking_1
#> 1                                  1.78                 16192572
#> 2                                  1.75                 16257694
#> 3                                  1.75                 16312831
#> 4                                  1.76                 16361819
#> 5                                  1.76                 16413373
#> 6                                  1.76                 16469770
#>   Topics:k_0Tot20Jaar_2 Topics:k_0Tot20Jaar_5 Topics:k_20Tot65Jaar_3
#> 1               3968999                  24.5               10003117
#> 2               3992999                  24.6               10013439
#> 3               4004608                  24.5               10024015
#> 4               4009523                  24.5               10032056
#> 5               4007901                  24.4               10055805
#> 6               4004135                  24.3               10081436
#>   Topics:k_20Tot65Jaar_6 Topics:k_65JaarOfOuder_4 Topics:k_65JaarOfOuder_7
#> 1                   61.8                  2220456                     13.7
#> 2                   61.6                  2251256                     13.8
#> 3                   61.4                  2284208                       14
#> 4                   61.3                  2320240                     14.2
#> 5                   61.3                  2349667                     14.3
#> 6                   61.2                  2384199                     14.5
```

Or get the underlying observations with `get_observations`

``` r
obs <- CBSbeta |> get_observations(id="DF_37230ned", agencyID="NL1.CNVT")
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
#>      RegioS     Perioden                                   Topics   OBS_VALUE
#> 1 Nederland 2024 januari                              Overledenen    16825.00
#> 2 Nederland 2024 januari                  Levend geboren kinderen    13582.00
#> 3 Nederland 2024 januari   Bevolking aan het begin van de periode 17942942.00
#> 4 Nederland         2024   Bevolking aan het einde van de periode 18045532.00
#> 5 Nederland         2024 Bevolkingsgroei sinds 1 januari, rela...        0.57
#> 6 Nederland         2024          Bevolkingsgroei sinds 1 januari   102590.00
#>   OBS_STATUS UNIT_MEASURE UNIT_MULT          OBS_MISSING
#> 1  Voorlopig       aantal  Eenheden het cijfer is bekend
#> 2  Voorlopig       aantal  Eenheden het cijfer is bekend
#> 3  Voorlopig       aantal  Eenheden het cijfer is bekend
#> 4  Voorlopig       aantal  Eenheden het cijfer is bekend
#> 5  Voorlopig            %  Eenheden het cijfer is bekend
#> 6  Voorlopig       aantal  Eenheden het cijfer is bekend
```

To retrieve a list of agencies or subagencies:

``` r
agencies <- CBSbeta |> list_agencies()
head(agencies)
#>     id                              name description      ref
#> 1 HEAL       CBS (Gezondheid en Welzijn)        <NA> NL1.HEAL
#> 2 POPU                   CBS (Bevolking)        <NA> NL1.POPU
#> 3 LABO CBS (Arbeid en sociale zekerheid)        <NA> NL1.LABO
#> 4 EDUC                   CBS (Onderwijs)        <NA> NL1.EDUC
#> 5 INCO      CBS (Inkomen en bestedingen)        <NA> NL1.INCO
#> 6 HOUS             CBS (Bouwen en wonen)        <NA> NL1.HOUS
```
