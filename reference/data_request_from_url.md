# Create a data request from a URL

This function creates a data request from a URL that contains the
necessary parameters for an SDMX data request. Note that this is a raw
request. Most users are better off using
[`get_observations_from_url()`](https://edwindj.github.io/sdmxdata/reference/get_observations_from_url.md)
instead.

## Usage

``` r
data_request_from_url(url, ..., verbose = FALSE)
```

## Arguments

- url:

  A URL that contains the parameters for the data request, including
  flowRef.

- ...:

  Additional parameters to be passed to the data request.

- verbose:

  If `TRUE`, print information about the request.

## Value

An object of class
[`sdmx_v2_1_data_request()`](https://edwindj.github.io/sdmxdata/reference/sdmx_v2_1_data_request.md)
that can be used to retrieve data.

## Examples

``` r
# create a data request object from a URL
url <- "https://sdmx.oecd.org/public/rest/data/OECD.TAD.ARP,DSD_FISH_PROD@DF_FISH_AQUA,1.0/.A.._T.T?startPeriod=2010&dimensionAtObservation=AllDimensions"

# it does not execute the request, it just creates the request object
req <- data_request_from_url(url, verbose = TRUE)
#> Creating data request using the following statement:
#>   sdmx_v2_1_data_request(endpoint = "https://sdmx.oecd.org/public/rest", 
#>       resource = "data", flowRef = "OECD.TAD.ARP,DSD_FISH_PROD@DF_FISH_AQUA,1.0", 
#>       key = ".A.._T.T", startPeriod = "2010", dimensionAtObservation = "AllDimensions", 
#>       verbose = TRUE)

# this is the raw csv output of the SDMX data request
# most users are better of using `get_observations_from_url()`
d <- req |> as.data.frame()
head(d)
#>   STRUCTURE                                 STRUCTURE_ID ACTION REF_AREA FREQ
#> 1  DATAFLOW OECD.TAD.ARP:DSD_FISH_PROD@DF_FISH_AQUA(1.0)      I      ARG    A
#> 2  DATAFLOW OECD.TAD.ARP:DSD_FISH_PROD@DF_FISH_AQUA(1.0)      I      ARG    A
#> 3  DATAFLOW OECD.TAD.ARP:DSD_FISH_PROD@DF_FISH_AQUA(1.0)      I      ARG    A
#> 4  DATAFLOW OECD.TAD.ARP:DSD_FISH_PROD@DF_FISH_AQUA(1.0)      I      AUS    A
#> 5  DATAFLOW OECD.TAD.ARP:DSD_FISH_PROD@DF_FISH_AQUA(1.0)      I      AUS    A
#> 6  DATAFLOW OECD.TAD.ARP:DSD_FISH_PROD@DF_FISH_AQUA(1.0)      I      AUS    A
#>   MEASURE SPECIES UNIT_MEASURE TIME_PERIOD OBS_VALUE OBS_STATUS CONF_STATUS
#> 1 AQUA_PD      _T            T        2016  3673.485                      F
#> 2 AQUA_PD      _T            T        2017   3567.76                      F
#> 3 AQUA_PD      _T            T        2018   3205.31                      F
#> 4 AQUA_PD      _T            T        2015   83074.9                      F
#> 5 AQUA_PD      _T            T        2016 91596.891                      F
#> 6 AQUA_PD      _T            T        2017 85335.483                      F
#>   UNIT_MULT DECIMALS CONVENTION CURRENCY
#> 1         0        0         LW         
#> 2         0        0         LW         
#> 3         0        0         LW         
#> 4         0        0         LW         
#> 5         0        0         LW         
#> 6         0        0         LW         
```
