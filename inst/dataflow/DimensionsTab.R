# HACK
# get_dimensions <- sdmxdata:::get_dimensions
# source("CodesTree.R")
# source("CodesDT.R")
source("Dimension.R")

DimensionsTabUI <- function(id){
  ns <- NS(id)
  tagList(
    uiOutput(ns("dims"))
  )
}

DimensionsTabServer <- function(id, shared_values){
  moduleServer( id, function(input, output, session){
      ns <- session$ns

      dimensions <- reactive({
        dfi <- shared_values$dfi
        if (is.null(dfi)){
          return(NULL)
        }
        d <- dfi$dimensions
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
          dim_id <- paste0("dim", dim$id)
          DimensionServer(dim_id, dim = dim)
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
          dim_id <- paste0("dim", dim$id)

          panelname <- sprintf(
            "%s (%d) [%s]",
            dim$name,
            nrow(dim$code),
            dim$id
          )

          accordion_panel(
            panelname,
            DimensionUI(ns(dim_id))
          )

        })

        accordion(dims, open=FALSE)
      })
    }
  )
}
