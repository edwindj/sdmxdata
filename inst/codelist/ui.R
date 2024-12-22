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

page_navbar(
    title = "codelists",
    theme = bs_theme(
      version = 5,
      preset = "flatly"
    ),
    fillable = TRUE,
    # sidebar = sidebar(
    # ),
    navset_underline(

    nav_panel(
      title="DataFlows",
      DataFlowsUI("dataflows")
    ),
    nav_panel(
      title = "Codelists",
      layout_columns(
        card(
          card_header("codelists"),
          DTOutput(
            "codelists"
          )
        ),
        card(
          card_header("codes"),
          DTOutput("codes"),
          fill = FALSE
        )
      )
    )
  )
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
