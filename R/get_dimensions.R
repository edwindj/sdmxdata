# input is result of get_dataflow_info
get_dimensions <- function(dfi){
  codelists <- dfi$codelists

  dims <- lapply(dfi$datastructure$dimensions, function(dim) {
    cl <- codelists[[dim$cl_ref]]

    list(
      id = dim$id,
      # probably not correct but for now it'll do.
      name = cl$name,
      code = cl$codes
    )
  })

  dims
}
