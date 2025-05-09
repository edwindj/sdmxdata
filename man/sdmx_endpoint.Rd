% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/sdmx_endpoint.R
\name{sdmx_endpoint}
\alias{sdmx_endpoint}
\alias{sdmx_endpoint.character}
\alias{sdmx_endpoint.httr2_request}
\title{Create a new SDMX endpoint}
\usage{
sdmx_endpoint(x, ...)

\method{sdmx_endpoint}{character}(
  x,
  id = gsub("\\\\W+", "_", x),
  name = x,
  language = NULL,
  cache_dir = file.path(tempdir(), "sdmxdata", id),
  verbose = getOption("sdmxdata.verbose", FALSE),
  ...
)

\method{sdmx_endpoint}{httr2_request}(x, ...)
}
\arguments{
\item{x}{An endpoint or an httr2 request object}

\item{...}{saved for future use}

\item{id}{character, the id of the endpoint}

\item{name}{character, the name of the endpoint}

\item{language}{character, the language to use for the text used in the response}

\item{cache_dir}{character, the directory to cache the metadata in}

\item{verbose}{logical, if \code{TRUE} print information on the connection}
}
\value{
a \link{SDMXEndpoint} object
}
\description{
Create an endpoint from an url or httr2 request object
}
\seealso{
Other SDMX endpoints: 
\code{\link{SDMXEndpoint}},
\code{\link{get_endpoint}()}
}
\concept{SDMX endpoints}
