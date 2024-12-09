sdmx_parse_data_url <- function(x, resource = c("data", "metadata")){
  x <- URLdecode(x)
  resource <- match.arg(resource)

  detect <- sprintf("/%s/", resource)
  x1 <- strsplit(x, detect) |> unlist()

  stopifnot(length(x1) == 2)

  endpoint <- x1[1]
  x2 <- strsplit(x1[2], "?", fixed = TRUE) |> unlist()
  path <- x2[1]
  params <- parse_url_query(x2[2])

  parts <- c(resource, (strsplit(path, "/") |> unlist()))
  names(parts) <- c("resource", "flowRef","key","providerRef")[seq_along(parts)]
  parts <- as.list(parts)

  args <- c(parts, params)

  expr <- bquote(
    req_sdmx_data(..(args)),
    splice = TRUE
  )

  list(
    expr = expr,
    args = c(list(req = endpoint), parts, params)
  )
}

parse_url_query <- function(x){
  if (is.null(x) || is.na(x)){
    return(NULL)
  }

  x <- strsplit(x, "&", fixed = TRUE) |> unlist()
  val <- sub(".*=", "", x) |> as.list()
  names(val) <- sub("=.*", "", x)
  val
}
