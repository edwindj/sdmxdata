# input is result of get_dataflow_info
get_dimensions <- function(dfi){

  dims <- dfi$datastructure$dimensions[[1]]

  cl_idx <- match(dims$cl_ref, dfi$codelists$ref)
  codelists <- dfi$codelists[cl_idx,]

  concept_idx <- match(dims$concept_ref, dfi$concepts$ref)
  concepts <- dfi$concepts[concept_idx,]

  dimensions <- dims |>
    subset(select = c(id, position))

  # TODO add language support
  dimensions$name <- concepts$name
  dimensions$description <- concepts$description

  dimensions$cl_name <- codelists$name
  dimensions$cl_description <- codelists$description
  dimensions$codes <- codelists$codes

  dimensions$codelist <-
    codelists |>
    split(seq_len(nrow(codelists))) |>
    lapply(function(x){
      x <- as.list(x)
      x$codes <- x$codes[[1]]
      x
    })

  d <- dimensions |>
    split(dimensions$id) |>
    lapply(function(x){
      x <- as.list(x)
      x$codes <- x$codes[[1]]
      x$codelist <- x$codelist[[1]]
      x
    })

  d
}
