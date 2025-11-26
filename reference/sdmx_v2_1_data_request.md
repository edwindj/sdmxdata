# Request SDMX data using the SDMX REST API v2.1

`sdmx_v2_1_data_request` is a wrapper around the smdx rest api v2.1 and
is used to retrieve data from the api.

## Usage

``` r
sdmx_v2_1_data_request(
  endpoint = NULL,
  resource = c("data", "metadata"),
  flowRef = NULL,
  key = NULL,
  providerRef = NULL,
  ...,
  startPeriod = NULL,
  endPeriod = NULL,
  updatedAfter = NULL,
  firstNObservations = NULL,
  lastNObservations = NULL,
  dimensionAtObservation = NULL,
  detail = c("full", "dataonly", "serieskeysonly", "nodata"),
  includeHistory = NULL,
  labels = c("both", "id")
)
```

## Arguments

- endpoint:

  An endpoint or an object that can be coerced to an endpoint

- resource:

  The resource to request. Either "data" or "metadata"

- flowRef:

  The flow reference to request, see details

- key:

  The key to request, see details

- providerRef:

  The provider reference to request, see details

- ...:

  Additional parameters to pass to the request

- startPeriod:

  The start period for which the data should be returned

- endPeriod:

  The end period for which the data should be returned

- updatedAfter:

  Only return data that has been updated after this date

- firstNObservations:

  Only return the first n observations

- lastNObservations:

  Only return the last n observations

- dimensionAtObservation:

  The dimensions of the observations should be returned

- detail:

  The detail of the data to return. Either "full", "dataonly",
  "serieskeysonly" or "nodata"

- includeHistory:

  Include the different versions of the data

- labels:

  Include the labels in the data, only valid when format is "csv"

## Value

a modified
[`httr2::request()`](https://httr2.r-lib.org/reference/request.html)
object
