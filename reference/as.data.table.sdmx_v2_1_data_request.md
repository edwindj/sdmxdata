# Get data from a SDMX API

Retrieve data from an sdmx api and return it as a data.frame

## Usage

``` r
# S3 method for class 'sdmx_v2_1_data_request'
as.data.table(x, keep.rownames = FALSE, ...)
```

## Arguments

- x:

  An httr2 request object

- keep.rownames:

  logical, not used

- ...:

  reserved for future use

## Value

data.table

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
