# Get observations using a data-explorer url

Retrieve observations using the url from the data-explorer. The url
given will be parsed and translated into a
[`get_observations()`](https://edwindj.github.io/sdmxdata/reference/get_observations.md)
call, to get you started. The call will be printed to the console or can
be retrieved by settings `return_query = TRUE`.

## Usage

``` r
get_observations_from_url(url, return_query = FALSE, verbose = FALSE)
```

## Arguments

- url:

  character, the REST 2.1 url retrieved from an external source

- return_query:

  logical, if `TRUE` return the query object instead of the observation

- verbose:

  logical, if `TRUE` print information about the query

## Value

when `return_query = FALSE` a data.frame with the observations, i.e.
same output as
[`get_observations()`](https://edwindj.github.io/sdmxdata/reference/get_observations.md).
Otherwise a list with the query object and the parameters

## See also

Other retrieve data:
[`get_data()`](https://edwindj.github.io/sdmxdata/reference/get_data.md),
[`get_observations()`](https://edwindj.github.io/sdmxdata/reference/get_observations.md)

## Examples

``` r
# retrieve an external url pointing to sdmx data

url <-
  "https://sdmx.oecd.org/public/rest/data/OECD.TAD.ARP,DSD_FISH_PROD@DF_FISH_AQUA,1.0/.A.._T.T?startPeriod=2010&dimensionAtObservation=AllDimensions"

obs <- get_observations_from_url(url)
#> Retrieving data using the following statement:
#>   get_observations(endpoint = "https://sdmx.oecd.org/public/rest", 
#>       agencyID = "OECD.TAD.ARP", id = "DSD_FISH_PROD@DF_FISH_AQUA", 
#>       version = "1.0", verbose = FALSE, filter_on = list(FREQ = "A", 
#>           SPECIES = "_T", UNIT_MEASURE = "T"))
head(obs)
#>   REF_AREA   FREQ                MEASURE SPECIES UNIT_MEASURE TIME_PERIOD
#> 1    India Annual Aquaculture production   Total       Tonnes        2001
#> 2    India Annual Aquaculture production   Total       Tonnes        2000
#> 3    India Annual Aquaculture production   Total       Tonnes        1999
#> 4  Belgium Annual Aquaculture production   Total       Tonnes        2012
#> 5  Belgium Annual Aquaculture production   Total       Tonnes        2010
#> 6  Belgium Annual Aquaculture production   Total       Tonnes        2009
#>   OBS_VALUE                          OBS_STATUS                 CONF_STATUS
#> 1   2120634                                <NA> Free (free for publication)
#> 2   1942531                                <NA> Free (free for publication)
#> 3   2134814                                <NA> Free (free for publication)
#> 4       277 Value imputed by a receiving agency Free (free for publication)
#> 5       539 Value imputed by a receiving agency Free (free for publication)
#> 6       576 Value imputed by a receiving agency Free (free for publication)
#>   UNIT_MULT DECIMALS  CONVENTION CURRENCY
#> 1     Units     Zero Live weight     <NA>
#> 2     Units     Zero Live weight     <NA>
#> 3     Units     Zero Live weight     <NA>
#> 4     Units     Zero Live weight     <NA>
#> 5     Units     Zero Live weight     <NA>
#> 6     Units     Zero Live weight     <NA>

query <- get_observations_from_url(url, return_query = TRUE)
query
#> $expr
#> get_observations(endpoint = "https://sdmx.oecd.org/public/rest", 
#>     agencyID = "OECD.TAD.ARP", id = "DSD_FISH_PROD@DF_FISH_AQUA", 
#>     version = "1.0", verbose = FALSE, filter_on = list(FREQ = "A", 
#>         SPECIES = "_T", UNIT_MEASURE = "T"))
#> 
#> $args
#> $args$agencyID
#> [1] "OECD.TAD.ARP"
#> 
#> $args$id
#> [1] "DSD_FISH_PROD@DF_FISH_AQUA"
#> 
#> $args$version
#> [1] "1.0"
#> 
#> $args$verbose
#> [1] FALSE
#> 
#> $args$filter_on
#> $args$filter_on$FREQ
#> [1] "A"
#> 
#> $args$filter_on$SPECIES
#> [1] "_T"
#> 
#> $args$filter_on$UNIT_MEASURE
#> [1] "T"
#> 
#> 
#> 
```
