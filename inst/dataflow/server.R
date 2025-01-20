#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(sdmxdata)
get_dataflow_structure <- sdmxdata:::get_dataflow_structure

library(DT)

source("DataFlows.R")
source("DataFlowInfo.R")
source("DimensionsTab.R")

function(input, output, session){

  shared_values <- reactiveValues(
    dataflowref = NULL
  )

  debounce_dataflowref <- debounce(reactive(shared_values$dataflowref), 600)

  observeEvent(shared_values$dataflowref, {
    flowRef <- shared_values$dataflowref

    if (!is.null(flowRef)){
      dfi <- get_dataflow_structure(flowRef = flowRef)
      shared_values$dfi <- dfi
    } else{
      shared_values$dfi <- NULL
    }
  })

  observeEvent(debounce_dataflowref(), {
    toggle_sidebar(id = "sidebar")
  })

  DataFlowsServer("dataflows", shared_values = shared_values)
  DataFlowInfoServer("info", shared_values = shared_values)
  DimensionsTabServer("dimensions", shared_values = shared_values)
  output$rawsdmx <- renderText(
    shared_values$dfi$raw_sdmx |>
      jsonlite::toJSON(auto_unbox = TRUE, pretty = TRUE)
  )
}
