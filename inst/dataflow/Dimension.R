source("CodesTree.R")
source("CodesDT.R")

DimensionUI <- function(id){
  ns <- NS(id)
  tagList(
    div(
      "Name: ",
      textOutput(ns("name"), inline = TRUE)
    ),
    uiOutput(ns("description")),
    # div(
    #     "codelist: ",
    #     textOutput(ns("name"))
    # ),
    # div(
    #   tags$pre(
    #     textOutput(ns("description"))
    #   )
    # ),
    bslib::input_switch(
      ns("showtree"),
      label="tree",
      value = TRUE
    ),
    uiOutput(ns("code"))
  )
}

DimensionServer <- function(id, dim){
  force(dim)

  moduleServer(id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$showtree,{
      if (!is.null(dim)){
        # browser()
        if (input$showtree){
          CodesTreeServer("code", dim$code)
        } else {
          CodesDTServer("code", dim$code)
        }
      }
      gc()
    })

    # output$name <- renderText({
    #   codelist$name
    # })
    #
    # output$description <- renderText({
    #   codelist$description
    # })

    output$name <- renderText({
      dim$name
    })

    output$description <- renderUI({
      if (!is.na(dim$description)){
        tags$textarea(
          readonly = TRUE,
          disabled = TRUE,
          dim$description
        )
      }
    })

    output$code <- renderUI({
      if (input$showtree){
        CodesTreeUI(ns("code"))
      } else {
        CodesDTUI(ns("code"))
      }
    })
  })
}
