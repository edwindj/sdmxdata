DataFlowsUI <- function(id){
  ns <- NS(id)
  layout_columns(
    min_height="80vh",
    DT::DTOutput(
      ns("dataflows"),
      height = "100%",
      fill = TRUE
    )
  )
}


DataFlowsServer <- function(id, shared_values){
  stopifnot(is.reactivevalues(shared_values))

  flows <- \(){
    df <- cbsopendata::get_dataflows()
    df |>
      subset(select=c("name", "id", "agencyID", "version", "ref"))
  }

  moduleServer(id, function(input, output, session){
    # these have to be loaded
    df <- flows()

    ns <- session$ns

    # we are passing this one to the panel
    observeEvent(input$dataflows_rows_selected, {
      id <- input$dataflows_rows_selected
      if (is.null(id)) {
        shared_values$dataflowref <- NULL
      } else {
        shared_values$dataflowref <- df$ref[id]
      }
    })

    # observeEvent(shared_values, {
    #   shared_values |>
    #     reactiveValuesToList() |>
    #     print()
    # })

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
