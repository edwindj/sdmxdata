# HACK
get_dimensions <- cbsopendata:::get_dimensions
# source("CodesTree.R")
# source("CodesDT.R")
source("CodeList.R")

DimensionsUI <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("dims"))
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
        d <- get_dimensions(dfi)
        d
      })

      observeEvent(c(dimensions()), {
        dims <- dimensions()
        # browser()
        if (!length(dims)){
          return()
        }

        for (dim in dims){
          # id <- paste0("codes", dim$id)
          cl_id <- paste0("codelist", dim$id)
          CodeListServer(cl_id, codelist = dim$codelist)
          # if (input$showtree){
          #   CodesTreeServer(id, code = dim$code)
          # } else{
          #   CodesDTServer(id, code = dim$code)
          # }
        }
        # cleaning up
        gc()
      })

      output$dims <- renderUI({
        dims <- lapply(dimensions(), function(dim){
          codesid <- paste0("codes", dim$id)
          cl_id <- paste0("codelist", dim$id)

          panelname <- sprintf(
            "%s (%d) [%s]",
            dim$name,
            nrow(dim$codelist$code),
            dim$id
          )

          accordion_panel(
            panelname,
            CodeListUI(ns(cl_id))
          )

        })

        accordion(dims, open=FALSE)
      })
    }
  )
}
