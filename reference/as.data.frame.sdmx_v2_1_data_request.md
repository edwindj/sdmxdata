# Transform a SDMX data request into a data.frame

Retrieve data from an sdmx api and return it as a data.frame

## Usage

``` r
# S3 method for class 'sdmx_v2_1_data_request'
as.data.frame(x, row.names = NULL, optional = FALSE, ...)
```

## Arguments

- x:

  An
  [`sdmx_v2_1_data_request()`](https://edwindj.github.io/sdmxdata/reference/sdmx_v2_1_data_request.md)
  object

- row.names:

  Not used

- optional:

  Not used

- ...:

  reserved for future use

## Value

a data.frame

## Examples

``` r
if (interactive()){
  dfs <- list_dataflows()

  flowRef <- paste0(dfs[2, c("agencyID", "id", "version")], sep=",")

  # json
  d <-
    sdmx_v2_1_data_request(flowRef = flowRef) |>
    as.data.frame()

}
```
