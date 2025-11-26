# Get observations from an SDMX provider

Get observations from an SDMX provider. It retrieves the data from the
SDMX provider and returns it as a `data.frame`.

## Usage

``` r
get_observations(
  endpoint = NULL,
  agencyID,
  id,
  version = "latest",
  ref = NULL,
  startPeriod = NULL,
  endPeriod = NULL,
  filter_on = list(),
  use_factor = TRUE,
  ...,
  language = NULL,
  as.data.table = FALSE,
  dim_contents = c("label", "both", "id"),
  attributes_contents = c("label", "id", "both"),
  obs_value_numeric = TRUE,
  raw = FALSE,
  drop_first_columns = !raw,
  cache = TRUE,
  verbose = getOption("sdmxdata.verbose", FALSE)
)
```

## Arguments

- endpoint:

  An endpoint, url or
  [`httr2::request()`](https://httr2.r-lib.org/reference/request.html)
  object.

- agencyID:

  The agency ID

- id:

  The id of the dataflow

- version:

  The version of the dataflow, default "latest"

- ref:

  The dataflow reference can be used in stead of `agencyID`, `id` and
  `version`

- startPeriod:

  The start period for which the data should be returned, works only for
  dataflows with an explicit time dimension.

- endPeriod:

  The end period for which the data should be returned, works only for
  dataflows with an explicit time dimension.

- filter_on:

  A named list of filters to apply to the data, if not specified or
  [`list()`](https://rdrr.io/r/base/list.html), it is the default
  selection, set to `NULL` to select all.

- use_factor:

  if `TRUE` then dimension and attributes columns are factors, otherwise
  character

- ...:

  Additional parameters to pass to the request

- language:

  The language of the metadata

- as.data.table:

  If `TRUE` return a
  [`data.table::data.table()`](https://rdatatable.gitlab.io/data.table/reference/data.table.html),
  otherwise a [`data.frame()`](https://rdrr.io/r/base/data.frame.html)

- dim_contents:

  The contents of the dimension columns, either "label", "id" or "both"

- attributes_contents:

  The contents of the attribute columns, either "label", "id" or "both"

- obs_value_numeric:

  Should the OBS_VALUE column be coerced to numeric? Default is `TRUE`

- raw:

  If `TRUE` return the raw data.frame from the SDMX, otherwise the
  data.frame is processed

- drop_first_columns:

  Should the first columns be dropped? Default is `TRUE` (if not raw)

- cache:

  if `TRUE` cache the accompanying meta data.

- verbose:

  If `TRUE` print information about the request

## Value

[`data.frame()`](https://rdrr.io/r/base/data.frame.html) or
[`data.table::data.table()`](https://rdatatable.gitlab.io/data.table/reference/data.table.html)
depending on `as.data.table`

## Details

By default the dimension and attribute columns are recoded to factors
with labels. This can be changed with the `dim_contents` and
`attributes_contents` arguments.

## See also

Other retrieve data:
[`get_data()`](https://edwindj.github.io/sdmxdata/reference/get_data.md),
[`get_observations_from_url()`](https://edwindj.github.io/sdmxdata/reference/get_observations_from_url.md)

## Examples

``` r
dfs <- list_dataflows()
ref <- dfs$ref[4]

  dfs <- list_dataflows()
  ref <- dfs$ref[4]

  obs <- get_observations(
    ref = ref,
    filter_on = list(
      "Perioden" = c("2009JJ00")
    ),
    verbose = TRUE
  )
#> <sdmx_v2_1_structure_request/httr2_request>
#> GET https://sdmx-api.beta.cbs.nl/rest/dataflow/NL1.CNVT/DF_03726ned/1.0?detail=referencepartial&references=all
#> Headers:
#> * Accept-Language: "en"
#> * accept         : "application/vnd.sdmx.structure+json;version=1.0;"
#> Body: empty
#> [cache:add]: “/tmp/Rtmp8aOsK8/sdmxdata/https_sdmx_api_beta_cbs_nl_rest/sdmxdata/dataflow/NL1.CNVT/DF_03726ned_1.0_en.json”
#> $request
#> <sdmx_v2_1_data_request/httr2_request>
#> GET https://sdmx-api.beta.cbs.nl/rest/data/NL1.CNVT%2CDF_03726ned%2C1.0/.2009JJ00..
#> Body: empty
#> 

obs
#>                                     Topics Perioden    OBS_VALUE UNIT_MEASURE
#> 1                         Totale bevolking     2009 16529758.000     absoluut
#> 2                           20 tot 65 jaar     2009 10099859.000     absoluut
#> 3                           20 tot 65 jaar     2009       61.100            %
#> 4             Totaal vruchtbaarheidscijfer     2009           NA     absoluut
#> 5                              Overledenen     2009           NA     absoluut
#> 6                               Immigratie     2009           NA     absoluut
#> 7                Levensverwachting vrouwen     2009           NA         jaar
#> 8   Migratiesaldo (incl. saldo adm. corr.)     2009           NA     absoluut
#> 9                         65 jaar of ouder     2009  2429345.000     absoluut
#> 10                           0 tot 20 jaar     2009  4000554.000     absoluut
#> 11 Emigratie (incl. saldo adm. correcties)     2009           NA     absoluut
#> 12                Levensverwachting mannen     2009           NA         jaar
#> 13                           0 tot 20 jaar     2009       24.200            %
#> 14                      Demografische druk     2009        0.637     absoluut
#> 15                         Levendgeborenen     2009           NA     absoluut
#> 16                        65 jaar of ouder     2009       14.700            %
#>    UNIT_MULT            OBS_MISSING
#> 1   Eenheden   het cijfer is bekend
#> 2   Eenheden   het cijfer is bekend
#> 3   Eenheden   het cijfer is bekend
#> 4   Eenheden het cijfer is onbekend
#> 5   Eenheden het cijfer is onbekend
#> 6   Eenheden het cijfer is onbekend
#> 7   Eenheden het cijfer is onbekend
#> 8   Eenheden het cijfer is onbekend
#> 9   Eenheden   het cijfer is bekend
#> 10  Eenheden   het cijfer is bekend
#> 11  Eenheden het cijfer is onbekend
#> 12  Eenheden het cijfer is onbekend
#> 13  Eenheden   het cijfer is bekend
#> 14  Eenheden   het cijfer is bekend
#> 15  Eenheden het cijfer is onbekend
#> 16  Eenheden   het cijfer is bekend
#>                                                      DECIMALS OBS_STATUS
#> 1  het cijfer heeft 0 decimalen of  of de waarde is een tekst Definitief
#> 2  het cijfer heeft 0 decimalen of  of de waarde is een tekst Definitief
#> 3                                 het cijfer heeft 1 decimaal Definitief
#> 4  het cijfer heeft 0 decimalen of  of de waarde is een tekst Definitief
#> 5  het cijfer heeft 0 decimalen of  of de waarde is een tekst Definitief
#> 6  het cijfer heeft 0 decimalen of  of de waarde is een tekst Definitief
#> 7  het cijfer heeft 0 decimalen of  of de waarde is een tekst Definitief
#> 8  het cijfer heeft 0 decimalen of  of de waarde is een tekst Definitief
#> 9  het cijfer heeft 0 decimalen of  of de waarde is een tekst Definitief
#> 10 het cijfer heeft 0 decimalen of  of de waarde is een tekst Definitief
#> 11 het cijfer heeft 0 decimalen of  of de waarde is een tekst Definitief
#> 12 het cijfer heeft 0 decimalen of  of de waarde is een tekst Definitief
#> 13                                het cijfer heeft 1 decimaal Definitief
#> 14                               het cijfer heeft 3 decimalen Definitief
#> 15 het cijfer heeft 0 decimalen of  of de waarde is een tekst Definitief
#> 16                                het cijfer heeft 1 decimaal Definitief
```
