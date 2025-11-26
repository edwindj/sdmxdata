# Base class for SDMX endpoints

Create a:

- a known endpoint from `endpoints` use
  [`get_endpoint()`](https://edwindj.github.io/sdmxdata/reference/get_endpoint.md).

- unlisted SDMX 2.1 REST endpoint use
  [`sdmx_endpoint()`](https://edwindj.github.io/sdmxdata/reference/sdmx_endpoint.md).

- a new SDMX endpoint use `SDMXEndpoint$new()`.

Base class for SDMX endpoints

## See also

Other SDMX endpoints:
[`get_endpoint()`](https://edwindj.github.io/sdmxdata/reference/get_endpoint.md),
[`sdmx_endpoint()`](https://edwindj.github.io/sdmxdata/reference/sdmx_endpoint.md)

## Public fields

- `req`:

  [`httr2::request()`](https://httr2.r-lib.org/reference/request.html)
  object, can be adjusted to add headers or proxy settings

- `version`:

  character, the SDMX version of the endpoint

- `id`:

  character, the id of the endpoint

- `name`:

  character, the name of the endpoint

- `url`:

  character, the url of the endpoint

- `verbose`:

  logical, if `TRUE` print information the connection

- `cache_dir`:

  character, the directory to cache the metadata in

- `language`:

  character, the language to use for the text used in the response

## Methods

### Public methods

- [`SDMXEndpoint$new()`](#method-SDMXEndpoint-new)

- [`SDMXEndpoint$clone()`](#method-SDMXEndpoint-clone)

------------------------------------------------------------------------

### Method `new()`

create a new SDMXEndpoint object, see also
[`sdmx_endpoint()`](https://edwindj.github.io/sdmxdata/reference/sdmx_endpoint.md)

#### Usage

    SDMXEndpoint$new(
      url,
      id = gsub("\\W+", "_", url),
      name = url,
      language = NULL,
      cache_dir = file.path(tempdir(), "sdmxdata", id),
      verbose = getOption("sdmxdata.verbose", FALSE)
    )

#### Arguments

- `url`:

  character, the url of the endpoint

- `id`:

  character, the id of the endpoint

- `name`:

  character, the name of the endpoint

- `language`:

  character, the language to use for the text used in the response

- `cache_dir`:

  character, the directory to cache the metadata in

- `verbose`:

  logical, if `TRUE` print information on the connection

------------------------------------------------------------------------

### Method `clone()`

The objects of this class are cloneable with this method.

#### Usage

    SDMXEndpoint$clone(deep = FALSE)

#### Arguments

- `deep`:

  Whether to make a deep clone.
