add_header_accept <- function(req, ...){
  to_add <- list(...)

  if (length(add) == 0){
    return(req)
  }

  add <- paste0(
    names(to_add), "=", unlist(to_add),
    collapse = ";"
  )

  accept <- c(req$headers$accept, add) |>
    paste(collapse = ";")

  req |>
    httr2::req_headers(accept = accept)
}
