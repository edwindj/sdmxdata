source("CodesTree.R")
source("CodesDT.R")

CodeListUI <- function(id){
  ns <- NS(id)
  tagList(
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

CodeListServer <- function(id, codelist){
  force(codelist)

  moduleServer(id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$showtree,{
      if (!is.null(codelist)){
        # browser()
        if (input$showtree){
          CodesTreeServer("code", codelist$code)
        } else {
          CodesDTServer("code", codelist$code)
        }
      }
      gc()
    })

    output$name <- renderText({
      codelist$name
    })

    output$description <- renderText({
      codelist$description
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
