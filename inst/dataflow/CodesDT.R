CodesDTUI <- function(id){
  ns <- NS(id)
  tagList(
    div(
      class="small",
      DT::DTOutput(ns("codes"))
    )
  )
}

CodesDTServer <- function(id, code){
  code <- force(code)

  moduleServer(id, function(input, output, session){
    ns <- session$ns

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
