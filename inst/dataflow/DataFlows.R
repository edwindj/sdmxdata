source("DataFlowInfo.R")

DataFlowsUI <- function(id){
  ns <- NS(id)
  layout_column_wrap(
    card(
      height="100%",
      fill = TRUE,
      DT::DTOutput(ns("dataflows"))
    ),
    DataFlowInfoUI(ns("dataflowinfo"))
  )
}


DataFlowsServer <- function(id){
  flows <- \(){
    df <- cbsopendata::sdmx_v2_1_get_dataflows()
    df |>
      subset(select=c("name", "id", "agencyID", "version", "ref"))
  }

  moduleServer(id, function(input, output, session){
    # these have to be loaded
    df <- flows()

    ns <- session$ns

    # we are passing this one to the panel
    rx_dataflowref <- reactive({
      id <- input$dataflows_rows_selected
      if (is.null(id)) {
        return(NULL)
      }
      df$ref[id]
    })

    observeEvent(rx_dataflowref(), {
      print(rx_dataflowref())
    })


    DataFlowInfoServer("dataflowinfo", rx_dataflowref)


    output$dataflows <- DT::renderDT({
      if (is.null(df)) {
        return(NULL)
      }

      DT::datatable(
        df,
        rownames = FALSE,
        selection = "single",
        fillContainer = TRUE,
        options = list(
          pageLength = 100,
          order = list(1, "asc")
        )
      ) |>
        DT::formatStyle(
          columns = colnames(df),
          fontSize = "70%"
        )
    })
  })
}
