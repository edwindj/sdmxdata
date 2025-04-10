% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/as.data.frame.sdmx_v2_1_data_request.R
\name{as.data.frame.sdmx_v2_1_data_request}
\alias{as.data.frame.sdmx_v2_1_data_request}
\title{Transform a SDMX data request into a data.frame}
\usage{
\method{as.data.frame}{sdmx_v2_1_data_request}(x, row.names = NULL, optional = FALSE, ...)
}
\arguments{
\item{x}{An \code{\link[=sdmx_v2_1_data_request]{sdmx_v2_1_data_request()}} object}

\item{row.names}{Not used}

\item{optional}{Not used}

\item{...}{reserved for future use}
}
\value{
a data.frame
}
\description{
Retrieve data from an sdmx api and return it as a data.frame
}
\examples{
if (interactive()){
  dfs <- list_dataflows()

  flowRef <- paste0(dfs[2, c("agencyID", "id", "version")], sep=",")

  # json
  d <-
    sdmx_v2_1_data_request(flowRef = flowRef) |>
    as.data.frame()

}
}
