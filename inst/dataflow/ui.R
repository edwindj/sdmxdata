#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)
library(DT)
source("DataFlows.R")
source("DataFlowInfo.R")
source("DimensionsTab.R")

page_navbar(
    title = "Dataflow Explorer",
    window_title = "Dataflow Explorer",
    id = "page",
    sidebar = sidebar(
      id = "sidebar",
      width="80%",
      height = "100%",
      DataFlowsUI("dataflows")
    ),
    nav_panel(
      id = "nav",
      title="info",
      # width = "20%",
      height = "100%",
      DataFlowInfoUI("info")
    ),
    nav_panel(
      id = "dimensions",
      title="Dimensions",
      DimensionsTabUI("dimensions")
    ),
    nav_panel(
      id = "rawsdmx",
      title = "sdmx",
      card(
        card_header("json"),
        card_body(
          tags$pre(
            tags$code(
              textOutput("rawsdmx")
            )
          )
        )
      )
    ),
    theme = bs_theme(version = 5, preset="flatly")
    # card(DataFlowInfoUI("dataflowinfo"))
)

# # Define UI for application that draws a histogram
# fluidPage(
#     # Application title
#     titlePanel("codelists"),
#     div(
#         class = "container-fluid",
#         selectInput(
#             inputId = "codelist",
#             label = "Codelist",
#             choices = c("codelist1", "codelist2"),
#             selected = "codelist1"
#         )
#     ),
#     shiny::tabsetPanel(
#         shiny::tabPanel(
#           title = "Codelists",
#           dataTableOutput("codelists")
#         ),
#         shiny::tabPanel(
#           title = "Codes",
#           dataTableOutput("codes")
#         )
#     )
# )
