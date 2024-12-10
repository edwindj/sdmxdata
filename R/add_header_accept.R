add_header_accept <- function(req, ...){
  to_add <- list(...)
  empty <- sapply(to_add, length) == 0
  to_add <- to_add[!empty]

  if (length(to_add) == 0){
    return(req)
  }

  accept <- c(
    req$headers$accept,
    paste0(
      names(to_add), "=", unlist(to_add)
    )
  ) |>
  paste(collapse = "; ")

  req |>
    httr2::req_headers(accept = accept)
}
