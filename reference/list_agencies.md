# list the agencies of an endpoint

list the agencies of an endpoint

## Usage

``` r
list_agencies(
  endpoint = NULL,
  language = NULL,
  raw = FALSE,
  cache = TRUE,
  verbose = getOption("sdmxdata.verbose", FALSE)
)
```

## Arguments

- endpoint:

  an endpoint, url or an
  [`httr2::request()`](https://httr2.r-lib.org/reference/request.html)
  object.

- language:

  the language to return the data in.

- raw:

  if `TRUE` return the raw data.

- cache:

  if `TRUE` cache the list of agencies.

- verbose:

  if `TRUE` print information about the caching.
