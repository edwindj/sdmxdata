% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/list_dataflows.R
\name{list_dataflows}
\alias{list_dataflows}
\title{List available sdmx dataflows}
\usage{
list_dataflows(
  endpoint = NULL,
  agencyID = NULL,
  ...,
  language = NULL,
  cache = TRUE,
  raw = FALSE,
  verbose = getOption("sdmxdata.verbose", FALSE)
)
}
\arguments{
\item{endpoint}{A character string or endpoint for a given endpoint.}

\item{agencyID}{A character string from a given agencyID.}

\item{...}{saved for future use.}

\item{language}{The language to use for the text used in the response.}

\item{cache}{if \code{TRUE} cache the list of dataflows}

\item{raw}{If \code{TRUE} return the raw data from the SDMX, otherwise the data is processed.}

\item{verbose}{if \code{TRUE} print information about the dataflows.}
}
\value{
a data.frame with available dataflows
}
\description{
List the sdmx dataflows from a given endpoint.
}
\examples{
dfs <- list_dataflows(verbose = TRUE)

head(dfs)
}
