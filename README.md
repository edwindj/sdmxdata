
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
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  description
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              voor testen .Stat applicaties
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              voor testen .Stat applicaties
#> 3                                                                                     Redenen die een belangrijke rol speelden om uit huis te gaan (Onderzoek Gezinsvorming 1998). De tabel heeft betrekking op personen die zijn geboren in de periode 1960 - 1969. Respondenten kunnen meerdere antwoorden hebben gegeven waardoor het totaal niet optelt tot 100 procent.<br>Frequentie: eenmalig<br><br>Gegevens beschikbaar vanaf: 1960 - 1969<br><br>Status van de cijfers:<br>De gegevens zijn definitief.<br><br>Wijzigingen per 16 mei 2018:<br>Geen, deze tabel is stopgezet.<br><br>Wanneer komen er nieuwe cijfers?<br>Niet meer van toepassing.
#> 4 De korte-termijnprognose is een actualisering van de lange-termijnprognose 2002-2050 op basis van inmiddels beschikbaar gekomen waarnemingen. Deze prognose voor de lange termijn is begin 2003 gepubliceerd. In de korte-termijnprognose zijn de cijfers tot 1 januari 2009 geactualiseerd.<br>Voor de periode na 2009 wordt verwezen naar cijfers van lange-termijnprognose.<br><br>Gegevens beschikbaar: 2003 tot en met 2009.<br><br>Status van de cijfers:<br>De gegevens in deze tabel zijn definitief.<br><br>Wijzigingen per 30 april 2018:<br>Geen, deze tabel is stopgezet.<br><br>Wanneer komen er nieuwe cijfers?<br>Niet meer van toepassing.
#> 5                                                                                                                                                                                                      Deze publicatie geeft informatie over uitgebrachte geldige stemmen en zetelverdeling met betrekking tot de verkiezing van de Tweede Kamer der Staten-Generaal, 15 mei 1963.<br><br>Gegevens beschikbaar over 15 mei 1963.<br><br>Status van de cijfers:<br>De gegevens van deze tabel zijn definitief.<br><br>Wijzigingen per 8 februari 2019:<br>Geen, deze tabel is stopgezet.<br><br>Wanneer komen er nieuwe cijfers?<br>Niet meer van toepassing.
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             Woonuitgaven.<br>Huur - en koopsector.<br>1990, 1994, 1998, 1999, 2000<br>Gewijzigd op 18 oktober 2002.<br>Verschijningsfrequentie: Stopgezet.
```

``` r
OECD <- sdmxdata::get_endpoint("OECD")
dfs_oecd <- OECD |> list_dataflows()
dfs_oecd[,1:5] |> 
  head()
#>       agencyID                            id version
#> 1        ESTAT                    SEEA_AEA_A     1.4
#> 2    IAEG-SDGs                    DF_SDG_GLC    1.20
#> 3    IAEG-SDGs                    DF_SDG_GLH    1.20
#> 4 OECD.CFE.EDS DSD_FUA_CLIM@DF_COASTAL_FLOOD     1.1
#> 5 OECD.CFE.EDS         DSD_FUA_CLIM@DF_FIRES     1.1
#> 6 OECD.CFE.EDS   DSD_FUA_CLIM@DF_HEAT_STRESS     1.1
#>                                 name
#> 1             Air Emissions Accounts
#> 2        SDG Country Global Dataflow
#> 3     SDG Harmonized Global Dataflow
#> 4 Coastal flooding - Cities and FUAs
#> 5        Wildfires - Cities and FUAs
#> 6      Heat stress - Cities and FUAs
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     description
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        Air Emissions Accounts
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Reporting and dissemination dataflow for non-harmonized global SDG indicators reported by countries.
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    Reporting and dissemination dataflow for harmonized global SDG indicators.
#> 4                                                                                                                                                                                                                                   <p align="justify">This dataset provides indicators of population and built-up exposure to coastal floods.</p>\n\n<h3>Data sources and methodology</h3>\n<p align="justify">Coastal flooding indicators are estimated using the Global coastal flood hazard maps <a href=https://doi.org/10.1038/ncomms11969>(Muis, S. et al., 2016)</a>. This dataset provides the extent of coastal floods for different return periods (10 to 100 years) with a 1-kilometre resolution. A return period corresponds to the estimated time interval between floods of similar intensity. Built-up area exposure to coastal floods is computed by intersecting this map with Copernius annual land cover data <a href=https://doi.org/10.24381/cds.006f2c9a>(Copernicus Climate Change Service, Climate Data Store, 2019)</a> and population exposure is computed using the Global Human Settlement Population layer <a href=https://doi.org/10.2760/098587>(European Commission, GHSL Data Package 2023)</a>.</p>\n\n<h3>Defining FUAs and cities</h3>\n<p align="justify">The OECD, in cooperation with the EU, has developed a harmonised <a href="https://www.oecd.org/en/data/datasets/oecd-definition-of-cities-and-functional-urban-areas.html">definition of functional urban areas</a> (FUAs) to capture the economic and functional reach of cities based on daily commuting patterns <a href=https://doi.org/10.1787/9789264174108-en>(OECD, 2012)</a>. FUAs consist of:\n<ol>\n  <li><b>A city</b> – defined by urban centres in the degree of urbanisation, adapted to the closest local administrative units to define a city.</li>\n  <li><b>A commuting zone</b> – including all local areas where at least 15% of employed residents work in the city.</li>\n</ol>\nThe delineation process includes:\n<ul>\n  <li>Assigning municipalities surrounded by a single FUA to that FUA.</li>\n  <li>Excluding non-contiguous municipalities.</li>\n</ul>\nThe definition identifies 1 285 FUAs and 1 402 cities in all OECD member countries except Costa Rica and three accession countries.</p>\n<h3>Cite this dataset</h3>\n<p>OECD Regions, cities and local areas database (<a href="http://data-explorer.oecd.org/s/1da">Coastal flooding - Cities and FUAs</a>), <a href=http://oe.cd/geostats>http://oe.cd/geostats</a></p>\n\n<h3>Further information</h3>\n<p align="justify">For any question or comment, please write to <a href="mailto:RegionStat@oecd.org">RegionStat@oecd.org</a><br /><br />FUA and City Statistics can be further explored with the interactive <a href="https://regions-cities-atlas.oecd.org">OECD Regions and Cities Statistical Atlas</a> web-tool.</p>
#> 5                                                                                                                                                                                                                                                          <p align="justify">This dataset provides indicators of population and land exposure to wildfires.</p>\n\n<h3>Data sources and methodology</h3>\n<p align="justify">The indicators use the JRC's Global wildfire dataset of fire regimes and fire behaviours <a href=https://doi.org/10.1038/s41597-019-0312-2>(Artés, T. et al., 2019)</a>, providing monthly individual fire perimeters for 2000-2023. Burnt areas are aggregated by year to obtain the total burnt land for each year. Built-up area exposure to wildfire is computed by intersecting the total burnt area with Copernius annual land cover data <a href=https://doi.org/10.24381/cds.006f2c9a>(Copernicus Climate Change Service, Climate Data Store, 2019)</a>. For population exposure, a 5-km buffer was added to the wildfire perimeters before intersecting with the Global Human Settlement Population layer <a href=https://doi.org/10.2760/098587>(European Commission, GHSL Data Package 2023)</a>.</p>\n\n<h3>Defining FUAs and cities</h3>\n<p align="justify">The OECD, in cooperation with the EU, has developed a harmonised <a href="https://www.oecd.org/en/data/datasets/oecd-definition-of-cities-and-functional-urban-areas.html">definition of functional urban areas</a> (FUAs) to capture the economic and functional reach of cities based on daily commuting patterns <a href=https://doi.org/10.1787/9789264174108-en>(OECD, 2012)</a>. FUAs consist of:\n<ol>\n  <li><b>A city</b> – defined by urban centres in the degree of urbanisation, adapted to the closest local administrative units to define a city.</li>\n  <li><b>A commuting zone</b> – including all local areas where at least 15% of employed residents work in the city.</li>\n</ol>\nThe delineation process includes:\n<ul>\n  <li>Assigning municipalities surrounded by a single FUA to that FUA.</li>\n  <li>Excluding non-contiguous municipalities.</li>\n</ul>\nThe definition identifies 1 285 FUAs and 1 402 cities in all OECD member countries except Costa Rica and three accession countries.</p>\n<h3>Cite this dataset</h3>\n<p>OECD Regions, cities and local areas database (<a href="http://data-explorer.oecd.org/s/1d7">Wildfires - Cities and FUAs</a>), <a href=http://oe.cd/geostats>http://oe.cd/geostats</a></p>\n\n<h3>Further information</h3>\n<p align="justify">For any question or comment, please write to <a href="mailto:RegionStat@oecd.org">RegionStat@oecd.org</a><br /><br />FUA and City Statistics can be further explored with the interactive <a href="https://regions-cities-atlas.oecd.org">OECD Regions and Cities Statistical Atlas</a> web-tool.</p>
#> 6 <p align="justify">This dataset provides an indicator of population exposure to heat stress.</p>\n\n<h3>Data sources and methodology</h3>\n<p align="justify">The indicator uses the Universal Thermal Comfort Index (UTCI). The UTCI enables to assess the impact of atmospheric conditions on the human body by considering air temperature, wind, radiation and humidity. UTCI values from 32°C to 38°C are considered as strong heat stress, from 38°C to 46°C as very strong heat stress, and above 46°C as extreme heat stress. Population exposure to heat stress was computed using the hourly thermal comfort indices grids from the Copernicus Climate Data Store <a href=https://doi.org/10.24381/cds.553b7518>(Di Napoli C. et al.)</a>. For each 0.25° by 0.25° grid cell, the number of days for which the maximum UTCI value is above each heat stress threshold (32°C, 38°C and 46°C) is computed. FUA and city level indicators correspond to the population-weighted average number of days above each heat stress threshold, obtained by intersecting the computed grid with the Global Human Settlement Population layer <a href=https://doi.org/10.2760/098587>(European Commission, GHSL Data Package 2023)</a>.</p>\n\n<h3>Defining FUAs and cities</h3>\n<p align="justify">The OECD, in cooperation with the EU, has developed a harmonised <a href="https://www.oecd.org/en/data/datasets/oecd-definition-of-cities-and-functional-urban-areas.html">definition of functional urban areas</a> (FUAs) to capture the economic and functional reach of cities based on daily commuting patterns <a href=https://doi.org/10.1787/9789264174108-en>(OECD, 2012)</a>. FUAs consist of:\n<ol>\n  <li><b>A city</b> – defined by urban centres in the degree of urbanisation, adapted to the closest local administrative units to define a city.</li>\n  <li><b>A commuting zone</b> – including all local areas where at least 15% of employed residents work in the city.</li>\n</ol>\nThe delineation process includes:\n<ul>\n  <li>Assigning municipalities surrounded by a single FUA to that FUA.</li>\n  <li>Excluding non-contiguous municipalities.</li>\n</ul>\nThe definition identifies 1 285 FUAs and 1 402 cities in all OECD member countries except Costa Rica and three accession countries.</p>\n<h3>Cite this dataset</h3>\n<p>OECD Regions, cities and local areas database (<a href="http://data-explorer.oecd.org/s/1d8">Heat stress - Cities and FUAs</a>), <a href=http://oe.cd/geostats>http://oe.cd/geostats</a></p>\n\n<h3>Further information</h3>\n<p align="justify">For any question or comment, please write to <a href="mailto:RegionStat@oecd.org">RegionStat@oecd.org</a><br /><br />FUA and City Statistics can be further explored with the interactive <a href="https://regions-cities-atlas.oecd.org">OECD Regions and Cities Statistical Atlas</a> web-tool.</p>
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
#>   Perioden TotaleBevolking_1 k_0Tot20Jaar_2 k_20Tot65Jaar_3 k_65JaarOfOuder_4
#> 1     2003          16192572        3968999        10003117           2220456
#> 2     2004          16257694        3992999        10013439           2251256
#> 3     2005          16312831        4004608        10024015           2284208
#> 4     2006          16361819        4009523        10032056           2320240
#> 5     2007          16413373        4007901        10055805           2349667
#> 6     2008          16469770        4004135        10081436           2384199
#>   k_0Tot20Jaar_5 k_20Tot65Jaar_6 k_65JaarOfOuder_7 DemografischeDruk_8
#> 1           24.5            61.8              13.7               0.619
#> 2           24.6            61.6              13.8               0.624
#> 3           24.5            61.4              14.0               0.627
#> 4           24.5            61.3              14.2               0.631
#> 5           24.4            61.3              14.3               0.632
#> 6           24.3            61.2              14.5               0.634
#>   Levendgeborenen_9 TotaalVruchtbaarheidscijfer_10 Overledenen_11
#> 1            203607                           1.78         141506
#> 2            196965                           1.75         142817
#> 3            193086                           1.75         145188
#> 4            189459                           1.76         147526
#> 5            186294                           1.76         149482
#> 6            183829                           1.76         151442
#>   LevensverwachtingMannen_12 LevensverwachtingVrouwen_13 Immigratie_14
#> 1                      76.15                       80.75        102095
#> 2                      76.38                       80.70        100019
#> 3                      76.47                       80.69        100086
#> 4                      76.55                       80.69        104190
#> 5                      76.68                       80.69        107832
#> 6                      76.80                       80.69        112589
#>   EmigratieInclSaldoAdmCorrecties_15 MigratiesaldoInclSaldoAdmCorr_16
#> 1                             102102                               -6
#> 2                             102058                            -2039
#> 3                             102025                            -1939
#> 4                              97598                             6593
#> 5                              91274                            16558
#> 6                              88016                            24573
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
