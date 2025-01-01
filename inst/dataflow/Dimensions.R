# HACK
get_dimensions <- cbsopendata:::get_dimensions
source("CodesTree.R")
source("CodesDT.R")

DimensionsUI <- function(id){
  ns <- NS(id)
  tagList(
    bslib::input_switch(
      ns("showtree"),
      label = "Show tree",
      value=TRUE
    ),
    uiOutput(ns("ui"))
  )
}

DimensionsServer <- function(id, shared_values){
  moduleServer( id, function(input, output, session){
      ns <- session$ns

      dimensions <- reactive({
        dfi <- shared_values$dfi
        if (is.null(dfi)){
          return(NULL)
        }
        get_dimensions(dfi)
      })

      observeEvent(c(dimensions(), input$showtree), {
        dims <- dimensions()
        if (!length(dims)){
          return()
        }

        for (dim in dims){
          id <- paste0("codes", dim$id)
          if (input$showtree){
            CodesTreeServer(id, code = dim$code)
          } else{
            CodesDTServer(id, code = dim$code)
          }
        }
        # cleaning up
        gc()
      })


      output$ui <- renderUI({
        dims <- lapply(dimensions(), function(dim){

          codesid <- paste0("codes", dim$id)
          panelname <- sprintf(
            "%s (%d) [%s]",
            dim$name,
            nrow(dim$code),
            dim$id
          )

          accordion_panel(
            panelname,
            if (input$showtree){
              CodesTreeUI(ns(codesid))
            } else {
              CodesDTUI(ns(codesid))
            }
          )

        })

        accordion(dims, open=FALSE)
      })
    }
  )
}
