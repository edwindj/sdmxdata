# HACK
get_dimensions <- cbsopendata:::get_dimensions

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

      observeEvent(dimensions(), {
        dims <- dimensions()
        if (!length(dims)){
          return()
        }

        for (dim in dims){
          id <- paste0("codes", dim$id)
          CodesServer(id, code = dim$code)
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
            CodesUI(ns(codesid))
          )

        })

        accordion(dims, open=FALSE)
      })
    }
  )
}

CodesUI <- function(id){
  ns <- NS(id)
  tagList(
    div(
      shinyTree::shinyTree(ns("tree"))
    ),
    div(
      class="small",
      DT::DTOutput(ns("codes"))
    )
  )
}

CodesServer <- function(id, code){
  code <- force(code)

  moduleServer(id, function(input, output, session){
    ns <- session$ns

    tree <- reactive({
      codes <- code

      codes$name <- sprintf("%s&nbsp;[%s]", codes$name, codes$id)

      p  <- match(codes$parent_id, codes$id)
      codes$parent <- codes$name[p]
      codes$parent[is.na(codes$parent)] <- ""

      l <- codes[c("parent","name")] |>
        data.tree::FromDataFrameNetwork() |>
        as.list()

      l[-1]
    })

    output$tree <- shinyTree::renderTree({
      tree()
    })

    output$codes <- DT::renderDT({
      DT::datatable(
        code,
        rownames=FALSE,
        autoHideNavigation = TRUE,
        # filter="top",
        options=list(
          pageLength=100,
          paging = FALSE
        )
      )
    })

  })
}

parent_child <- function(df, colnames){
  p <- which(df$parent_id == "")

}
