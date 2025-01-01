CodesTreeUI <- function(id){
  ns <- NS(id)
  tagList(
    div(
      shinyTree::shinyTree(ns("tree"))
    )
  )
}


CodesTreeServer <- function(id, code){
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

  })
}
