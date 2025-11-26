# Get information about a dataflow

Get information and structure about a dataflow. The dataflow can be
identified using `agencyID`, `id` and `version` or by using the `ref`
argument.

## Usage

``` r
get_dataflow_structure(
  endpoint = NULL,
  agencyID = getOption("sdmxdata.agencyID", NULL),
  id,
  version = "latest",
  ref,
  language = getOption("sdmxdata.language"),
  cache = TRUE,
  verbose = getOption("sdmxdata.verbose", FALSE)
)
```

## Arguments

- endpoint:

  An endpoint or an object that can be coerced to an
  [SDMXEndpoint](https://edwindj.github.io/sdmxdata/reference/SDMXEndpoint.md)

- agencyID:

  The agency ID of the dataflow

- id:

  The id of the dataflow

- version:

  The version of the dataflow, defaults to "latest"

- ref:

  A string with the flow reference, in the form of
  "agencyID:id(version)". Overrules the agencyID, id and version
  arguments.

- language:

  The language of the metadata

- cache:

  logical, if `TRUE` cache the metadata

- verbose:

  print some information on the console

## Value

a list with the dataflow information

## Details

For most use cases the `agencyID` and `id` are to be preferred, as the
`ref` argument includes a specific version number of the dataflow. Not
specifying a version number will default to the latest version. If it is
desirable to pin the reference of the dataflow to a specific version,
the `ref` argument can be used. The `ref` argument can also be found in
[`list_dataflows()`](https://edwindj.github.io/sdmxdata/reference/list_dataflows.md).
