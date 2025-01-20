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
library(DT)

source("DataFlows.R")

function(input, output, session){


  DataFlowsServer("dataflows")

  df_codelist <- reactive({
    df <- sdmx_v2_1_structure_request(resource = "codelist", detail = "allstubs") |>
      sdmx_v2_1_as_xml() |>
      xml_codelist()

    df |>
      subset(
        select = c("name_nl", "name_en", "agencyID", "resourceID", "version")
      )
  })

  codes_df <- reactive({
    rowid <- input$codelists_rows_selected
    if (length(rowid) == 0) {
      return(NULL)
    }
    cl <- df_codelist()[rowid, ] |> as.list()

    df <- sdmx_v2_1_structure_request(
      resource = "codelist",
      agencyID = cl$agencyID,
      resourceID = cl$resourceID,
      version = cl$version
    ) |>
      sdmx_v2_1_as_xml() |>
      xml2::xml_find_first(".//s:Codelist", ns = ns_v2_1) |>
      sdmx_v2_1_xml_codes()
    df
  })

  output$codelists <- renderDT({
    df <- df_codelist()
    if (is.null(df)) {
      return(NULL)
    }

    DT::datatable(
      df,
      rownames = FALSE,
      selection = "single",
      fillContainer = TRUE,
      options = list(
        pageLength = 100
      )
    ) |>
      DT::formatStyle(
        columns = colnames(df),
        fontSize = "70%"
      )
  })

  output$codes <- renderDT({
    DT::datatable(
      codes_df(),
      rownames = FALSE,
      fillContainer = TRUE,
      options = list(
        pageLength = 100
      )
    )
  })


  # output$codes <- renderDataTable({
  #   codes <- cbs_codes()
  #   codes
  # })
}
