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
library(DT)

source("DataFlows.R")
source("DataFlowInfo.R")

function(input, output, session){

  shared_values <- reactiveValues(
    dataflowref = NULL
  )

  debounce_dataflowref <- debounce(reactive(shared_values$dataflowref), 600)

  observeEvent(debounce_dataflowref(), {
    toggle_sidebar(id = "sidebar")
  })

  DataFlowsServer("dataflows", shared_values = shared_values)
  DataFlowInfoServer("dataflowinfo", shared_values = shared_values)
}
