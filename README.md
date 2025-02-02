
<!-- README.md is generated from README.Rmd. Please edit that file -->

# sdmxdata

<!-- badges: start -->

[![CRAN
status](https://www.r-pkg.org/badges/version/sdmxdata)](https://CRAN.R-project.org/package=sdmxdata)
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
CBSbeta <- sdmxdata::get_endpoint("NL1")
dfs <- CBSbeta$list_dataflows()
dfs[,1:5] |> 
  head()
#>   agencyID             id version
#> 1      NL1 DF_TESTSET_X01     1.0
#> 2      NL1 DF_TESTSET_X02     1.0
#> 3 NL1.CNVT    DF_24103NED     1.0
#> 4 NL1.CNVT    DF_37230ned     1.0
#> 5 NL1.CNVT       DF_37852     1.0
#> 6 NL1.CNVT    DF_50012NED     1.0
#>                                                                       name
#> 1                                TESTSET (dataflow, only use for TESTSET!)
#> 2                                 TESTSET (dataflow, alleen voor TESTSET!)
#> 3                               Mbo; deelnemers, leerweg, opleiding, regio
#> 4                                  Bevolkingsontwikkeling; regio per maand
#> 5 Gezondheid, leefstijl, zorggebruik en -aanbod, doodsoorzaken; vanaf 1900
#> 6                              Geneesmiddelen; kosten en gebruik 2010-2015
#>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    description
#> 1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              t.b.v. testen .Stat applicaties
#> 2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                voor testen .Stat applicaties
#> 3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     Deze tabel beschrijft het aantal personen dat op 1 oktober een inschrijving heeft aan de door de overheid bekostigde instellingen voor het middelbaar beroepsonderwijs (mbo) naar leerweg, opleiding (wel of niet zorg en welzijn), woonregio en studiejaar. Van de personen die een opleiding volgen binnen zorg en welzijn wordt aangegeven voor welke kwalificatie zij worden opgeleid. Deze tabel is ontwikkeld in het kader van het onderzoeksprogramma Arbeidsmarkt, Zorg en Welzijn (AZW), zie ook paragraaf 3.<br><br>Gegevens beschikbaar vanaf: 2010/'11.<br><br>Status van de cijfers:<br>De cijfers over 2010/'11 tot en met 2022/'23 zijn definitief en de cijfers over 2023/'24 zijn voorlopig.<br><br>Wijzigingen per 21 mei 2024:<br>De definitieve cijfers over 2022/'23 en de voorlopige cijfers over 2023/’24 zijn toegevoegd.<br><br>Alle lege cellen in de tabel zijn gevuld met een nul (0). Dit wijkt af van de richtlijnen beschreven in paragraaf 2. De reden is dat het niet altijd goed na te gaan is vanaf wanneer deelname aan een studie wel of niet mogelijk is. Het is daarmee ook niet goed mogelijk om te bepalen wanneer cijfers op logische gronden niet voor kunnen komen.<br><br>Vanaf 2022/'23 zijn dossiers persoonlijk begeleider zorgboerderij en werkbegeleider zorgbedrijf dierhouderij samengevoegd tot het nieuwe dossier zorgboerderij. De kwalificaties die vielen binnen deze dossiers zijn overgegaan naar het nieuwe dossier.<br><br>De kwalificaties zonder nadere differentiatie (z.n.d.) die vallen onder de volgende dossiers zijn uit de tabel verwijderd, omdat er op deze deze kwalificaties in de getoonde jaren geen inschrijvingen waren:<br>- Orthopedische techniek<br>- Orthopedische schoentechniek<br><br>Per 1 september 2022 is de RegioPlus-Arbeidsmarktregio Rijnstreek van naam gewijzigd: de nieuwe naam is “Rijn Gouwe”. Deze naamswijziging is in deze tabel teruggelegd in de tijd.<br><br>Wanneer komen er nieuwe cijfers?<br>In het tweede kwartaal van 2025 komen de definitieve cijfers over 2023/’24 en de voorlopige cijfers over 2024/'25 beschikbaar.
#> 4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          Deze tabel bevat cijfers over de veranderingen in de bevolkingsomvang van Nederland per regio. Deze veranderingen kunnen ontstaan door levend geboren kinderen, overledenen, immigratie, emigratie (inclusief administratieve correcties) en overige correcties. Daarnaast zijn ook cijfers over de totale bevolkingsgroei, begin- en eindbevolking opgenomen.<br><br>De in de tabel opgenomen regio's zijn landsdelen, provincies, COROP-gebieden en gemeenten. De gepresenteerde regiototalen betreffen samentellingen van gemeenten. In geval van grenswijzigingen die over verschillende regiogrenzen heen gaan is de indeling van de gemeenten gegroepeerd naar de meest recente situatie.<br><br>Gegevens beschikbaar vanaf: januari 2002.<br><br>Status van de cijfers:<br>De cijfers tot en met 2023 zijn definitief. De cijfers van de ‘Bevolking aan het begin van de periode’ voor januari 2024 zijn definitief.<br>De overige cijfers vanaf 2024 zijn voorlopig. Tussentijdse bijstellingen van voorgaande maanden zijn mogelijk.<br><br>Wijzigingen per 29 november 2024:<br>De voorlopige cijfers over oktober 2024 zijn toegevoegd.<br><br>Wanneer komen er nieuwe cijfers?<br>Aan het einde van iedere maand worden de voorlopige cijfers over de voorafgaande maand gepubliceerd. Tussentijdse bijstellingen van voorgaande maanden zijn mogelijk.<br>In het derde kwartaal van elk jaar worden de voorlopige cijfers over het voorgaande jaar vervangen door definitieve cijfers.
#> 5 Deze tabel toont de grote variëteit aan langlopende reeksen op het gebied  van gezondheid, leefstijl en gezondheidszorg. Cijfers over geboorte en  sterfte, enkele doodsoorzaken en het optreden van bepaalde infectieziekten zijn beschikbaar vanaf 1900. Andere reeksen starten op een later tijdstip.<br>Naast de ervaren gezondheid bevat de tabel onder meer cijfers over infectieziekten, ziekenhuisopnamen naar diagnose, levensverwachting, leefstijlfactoren als roken, alcohol en overgewicht, en doodsoorzaken. Ook diverse aspecten van de gezondheidszorg zoals het aantal beroepsbeoefenaren, het aantal beschikbare ziekenhuisbedden, de gemiddelde verpleegduur en de uitgaven aan zorg staan in de tabel.<br>Veel onderwerpen staan ook, in meer detail, in andere StatLine-tabellen, maar soms met een kortere looptijd. Gegevens over meldingsplichtige infectieziekten en Aids/hiv zijn niet in andere tabellen opgenomen.<br><br>Gegevens beschikbaar vanaf: 1900<br><br>Status van de cijfers:<br>2024:<br>De beschikbare cijfers zijn definitief.<br><br>2023:<br>De meeste beschikbare cijfers zijn definitief.<br>Cijfers zijn voorlopig voor:<br>- meldingsplichtige infectieziekten, hiv, aids;<br>- uitgaven aan gezondheidszorg en welzijnszorg;<br>- perinatale sterfte (28 wk), zuigelingensterfte.<br>2022:<br>De meeste beschikbare cijfers zijn definitief.<br>Cijfers zijn voorlopig voor:<br>- meldingsplichtige infectieziekten, hiv, aids;<br>- diagnoses bij ziekenhuisopname;<br>- ziekenhuisopnamen, verpleegdagen, verpleegduur;<br>- aantal ziekenhuisbedden;<br>- beroepen in de gezondheidszorg;<br>- uitgaven aan gezondheidszorg en welzijnszorg.<br>2021:<br>De meeste beschikbare cijfers zijn definitief.<br>Cijfers zijn voorlopig voor:<br>- meldingsplichtige infectieziekten, hiv, aids;<br>- uitgaven aan gezondheidszorg en welzijnszorg.<br>2020 en eerder:<br>Meeste beschikbare cijfers zijn definitief.<br>Vanwege het dynamische karakter van de registratie zijn cijfers over alle jaren voorlopig voor meldingsplichtige infectieziekten, hiv, aids.<br><br><br>Wijzigingen per 18 december 2024:<br>- Vanwege een revisie van de statistieken Uitgaven gezondheids- en welzijnszorg 2021 zijn cijfers voor de uitgaven aan gezondheidszorg en welzijnszorg vanaf 2021 vervangen.<br>- Gereviseerde cijfers over de volume-index van de zorgkosten zijn nog niet beschikbaar, vanaf 2021 zijn deze cijfers leeggemaakt.<br>Aanvulling met de beschikbare meest recente cijfers:<br>- levendgeborenen, overledenen;<br>- meldingsplichtige infectieziekten, hiv, aids;<br>- aantal ziekenhuisbedden;<br>- uitgaven aan gezondheidszorg en welzijnszorg;<br>- perinatale sterfte (28 wk), zuigelingensterfte;<br>- (gezonde) levensverwachting;<br>- doodsoorzaken.<br><br><br>Wanneer komen er nieuwe cijfers?<br>In juli 2025 verschijnen de op dat moment beschikbare meest recente cijfers.
#> 6                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   De cijfers in deze tabel zijn afkomstig uit het Genees- en hulpmiddelen Informatie Project (GIP geneesmiddelen) van het Zorginstituut Nederland (ZiN). Deze tabel is gemaakt voor De Staat van Volksgezondheid en Zorg en bevat gegevens over de ontwikkelingen in het gebruik van geneesmiddelen.<br>Het betreft zorg die extramuraal (d.w.z. buiten instellingen als ziekenhuizen en verpleeghuizen) wordt verleend op basis van de Zorgverzekeringswet. Dus alleen de extramuraal verstrekte geneesmiddelen vergoed uit de verplichte basisverzekering voor geneeskundige zorg.<br>Het gebruik van geneesmiddelen kan worden uitgesplitst naar: verzekerdenkenmerken (leeftijd en geslacht), soort geneesmiddel (ATC-classificatie). Outputvariabelen zijn totale kosten en aantallen gebruikers.<br>Deze tabel is stopgezet, zie in paragraaf 4 de link naar de GIP databank. Daar zijn de cijfers ook beschikbaar.<br><br>Gegevens beschikbaar van 2010 tot en met 2015.<br><br>Status van de cijfers:<br>Jaren 2010-2013 zijn definitief, 2014 en 2015 zijn voorlopig. Aangezien deze tabel is stopgezet, worden de gegevens niet meer definitief gemaakt.<br><br>Wijzigingen per 08-08-2019:<br>Geen, deze tabel is stopgezet.<br><br>Wanneer komen er nieuwe cijfers?<br>Niet meer van toepassing.
```

To retrieve a dataflow structure:

``` r
dataflow_ref <- dfs$ref[4]
print(dataflow_ref)
#> [1] "NL1.CNVT:DF_37230ned(1.0)"

dsd <- CBSbeta$get_dataflow_structure(ref = dataflow_ref)
dsd
#> Dataflow: [NL1.CNVT:DF_37230ned(1.0)]
#>   "Bevolkingsontwikkeling; regio per maand"
#>   agency: "NL1.CNVT", id: "DF_37230ned", version: "1.0"
#> 
#> Observation columns: 
#>   "RegioS", "Perioden", "Topics", "OBS_VALUE", "OBS_STATUS", "UNIT_MEASURE", "UNIT_MULT"
#> 
#> Get a default selection of the observations with:
#>   obs <- get_observations(id="DF_37230ned", agencyID="NL1.CNVT")
#> Get a default selection of the data with:
#>   dat <- get_data(id="DF_37230ned", agencyID="NL1.CNVT", pivot="Topics")
#> 
#> 
#> Properties:
#>  $id, $agencyID, $version, $name, $description, $dimensions, $measure, $attributes, $columns, $ref, $flowRef, $raw_sdmx, $default_selection
```

To retrieve data use `get_data`

``` r
data <- CBSbeta$get_data(agencyID=dsd$agencyID, id = dsd$id, pivot="Topics")
#> 
#> * `filter_on` argument not specified, using default selection:
#>    filter_on = list(
#>   Perioden = c("2024MM01", "2024MM02", "2024MM03", "2024MM04", "2024MM05", "2024MM06", "2024MM07", "2024MM08", "2024MM09", "2024MM10"),
#>   RegioS = "NL01"
#>    )
#> *  To select all data, set `filter_on` to `NULL`.
head(data)
#>      RegioS      Perioden Topics:BevolkingAanHetBeginVanDePeriode_1
#> 1 Nederland  2024 januari                                  17942942
#> 2 Nederland 2024 februari                                  17946556
#> 3 Nederland    2024 maart                                  17955743
#> 4 Nederland    2024 april                                  17962763
#> 5 Nederland      2024 mei                                  17970044
#> 6 Nederland     2024 juni                                  17977676
#>   Topics:BevolkingAanHetEindeVanDePeriode_15 Topics:BevolkingsgroeiRelatief_12
#> 1                                   17946556                              0.02
#> 2                                   17955743                              0.05
#> 3                                   17962763                              0.04
#> 4                                   17970044                              0.04
#> 5                                   17977676                              0.04
#> 6                                   17981933                              0.02
#>   Topics:BevolkingsgroeiSinds1JanuariRela_14
#> 1                                       0.02
#> 2                                       0.07
#> 3                                       0.11
#> 4                                       0.15
#> 5                                       0.19
#> 6                                       0.22
#>   Topics:BevolkingsgroeiSinds1Januari_13 Topics:Bevolkingsgroei_11
#> 1                                   3614                      3614
#> 2                                  12801                      9187
#> 3                                  19821                      7020
#> 4                                  27102                      7281
#> 5                                  34734                      7632
#> 6                                  38991                      4257
#>   Topics:EmigratieInclusiefAdmCorrecties_9 Topics:Immigratie_6
#> 1                                    17958               24815
#> 2                                    15621               27110
#> 3                                    14137               22850
#> 4                                    13455               21837
#> 5                                    13429               20651
#> 6                                    16979               20478
#>   Topics:LevendGeborenKinderen_2 Topics:OverigeCorrecties_10
#> 1                          13582                          NA
#> 2                          12893                          NA
#> 3                          13527                          NA
#> 4                          13171                          NA
#> 5                          14254                          NA
#> 6                          13831                          NA
#>   Topics:Overledenen_3 Topics:TotaalVertrekInclAdmCorrecties_7
#> 1                16825                                   86162
#> 2                15195                                   79128
#> 3                15220                                   79026
#> 4                14272                                   74843
#> 5                13844                                   74837
#> 6                13073                                   76737
#>   Topics:TotaleVestiging_4 Topics:VertrekNaarAndereGemeente_8
#> 1                    93019                              68204
#> 2                    90617                              63507
#> 3                    87739                              64889
#> 4                    83225                              61388
#> 5                    82059                              61408
#> 6                    80236                              59758
#>   Topics:VestigingVanuitEenAndereGemeente_5
#> 1                                     68204
#> 2                                     63507
#> 3                                     64889
#> 4                                     61388
#> 5                                     61408
#> 6                                     59758
```

Or get the underlying observations with `get_observations`

``` r
obs <- CBSbeta$get_observations(id="DF_37230ned", agencyID="NL1.CNVT")
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
