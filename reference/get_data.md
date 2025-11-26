# Retrieve data from a SDMX data API

Retrieve data from an SDMX data API. The function retrieves data from
the SDMX data API and returns it as a data.frame.

## Usage

``` r
get_data(
  endpoint = NULL,
  agencyID,
  id,
  version = "latest",
  ref = NULL,
  startPeriod = NULL,
  endPeriod = NULL,
  filter_on = list(),
  ...,
  dim_contents = c("label", "both", "id"),
  obs_value_numeric = TRUE,
  raw = FALSE,
  language = NULL,
  cache = TRUE,
  pivot = NULL,
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

- ...:

  Additional parameters to pass to the request

- dim_contents:

  The contents of the dimension columns, either "label", "id" or "both"

- obs_value_numeric:

  Should the OBS_VALUE column be coerced to numeric? Default is `TRUE`

- raw:

  If `TRUE` return the raw data.frame from the SDMX, otherwise the
  data.frame is processed

- language:

  The language of the metadata

- cache:

  if `TRUE` cache the accompanying meta data.

- pivot:

  `character` The name of the column to pivot the data on. If `NULL`
  (default) the data is returned in a long format.

- verbose:

  If `TRUE` print information about the request

## Value

a data.frame

## Details

`get_data` is similar to
[`get_observations()`](https://edwindj.github.io/sdmxdata/reference/get_observations.md),
but its differs in two aspects:

- it returns only data columns, no attribute columns

- it can pivot the observations, i.e. it can return the data in a wide
  format, which is useful feature when the data has multiple measures or
  when the data is to presented as a time series.

## See also

Other retrieve data:
[`get_observations()`](https://edwindj.github.io/sdmxdata/reference/get_observations.md),
[`get_observations_from_url()`](https://edwindj.github.io/sdmxdata/reference/get_observations_from_url.md)
