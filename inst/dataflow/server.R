#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(cbsopendata)
get_dataflow_info <- cbsopendata:::get_dataflow_info

library(DT)

source("DataFlows.R")
source("DataFlowInfo.R")
source("Dimensions.R")

function(input, output, session){

  shared_values <- reactiveValues(
    dataflowref = NULL
  )

  debounce_dataflowref <- debounce(reactive(shared_values$dataflowref), 600)

  observeEvent(shared_values$dataflowref, {
    ref <- shared_values$dataflowref

    if (!is.null(ref)){
      dfi <- get_dataflow_info(ref = ref)
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
  DimensionsServer("dimensions", shared_values = shared_values)
  output$rawxml <- renderText(shared_values$dfi$raw)
}
