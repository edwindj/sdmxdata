# Create a new SDMX endpoint

Create an endpoint from an url or httr2 request object

## Usage

``` r
sdmx_endpoint(x, ...)

# S3 method for class 'character'
sdmx_endpoint(
  x,
  id = gsub("\\W+", "_", x),
  name = x,
  language = NULL,
  cache_dir = file.path(tempdir(), "sdmxdata", id),
  verbose = getOption("sdmxdata.verbose", FALSE),
  ...
)

# S3 method for class 'httr2_request'
sdmx_endpoint(x, ...)
```

## Arguments

- x:

  An endpoint or an httr2 request object

- ...:

  saved for future use

- id:

  character, the id of the endpoint

- name:

  character, the name of the endpoint

- language:

  character, the language to use for the text used in the response

- cache_dir:

  character, the directory to cache the metadata in

- verbose:

  logical, if `TRUE` print information on the connection

## Value

a
[SDMXEndpoint](https://edwindj.github.io/sdmxdata/reference/SDMXEndpoint.md)
object

## See also

Other SDMX endpoints:
[`SDMXEndpoint`](https://edwindj.github.io/sdmxdata/reference/SDMXEndpoint.md),
[`get_endpoint()`](https://edwindj.github.io/sdmxdata/reference/get_endpoint.md)
