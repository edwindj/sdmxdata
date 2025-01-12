DataFlowInfoUI <- function(id){
  ns <- NS(id)

  card(
    card_header(
      textOutput(ns("name"))
    ),
    card_body(
      uiOutput(ns("dataflowinfo")),
      div("id:", textOutput(ns("id"), inline = TRUE)),
      htmlOutput(ns("description"))
    )
)
}

DataFlowInfoServer <- function(id, dataflowref){
  stopifnot(is.reactive(dataflowref))

  moduleServer(id, function(input, output, session){
    text <- reactiveValues()
    # observeEvent(dataflowref(), {
    #   print(dataflowref())
    # })

    dataflow <- reactive({
      ref <- dataflowref()

      if (is.null(ref)) {
        return(NULL)
      }
      dfi <- get_dataflow_info_xml(ref = ref)
      dfi
    })

    observeEvent(dataflow(), {
      df <- dataflow()$dataflow
      text$name <- df$name
      text$description <- df$description
      text$id <- df$id
      text$version <- df$version
      text$agencyID <- df$agencyID
    })

    output$name <- renderText(text$name)
    output$description <- renderText(text$description)
    output$id <- renderText(text$id)
    output$version <- renderText(text$version)

    output$dataflowinfo <- renderUI({
      if (is.null(dataflow())) {
        return(NULL)
      }
      d <- dataflow()
      df <- d$dataflow

      tags$dl(
        class="row",
        dl_item("id", df$id),
        dl_item("agencyID", df$agencyID),
        dl_item("version", df$version),
        dl_item("name", df$name),
      )
    })

  })
}

dl_item <- function(label, value){
  tagList(
    tags$dt(label, class="col-sm-3"),
    tags$dd(value, class="col-sm-9")
  )
}
