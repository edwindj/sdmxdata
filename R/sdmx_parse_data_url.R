sdmx_parse_data_url <- function(x, resource = c("data", "metadata")){
  x <- utils::URLdecode(x)
  resource <- match.arg(resource)

  detect <- sprintf("/%s/", resource)
  x1 <- strsplit(x, detect) |> unlist()

  stopifnot(length(x1) == 2)

  endpoint <- x1[1]

  path <- sub("\\?.*", "", x1[2])
  query <- sub("[^?]*\\??", "", x1[2])

  params <- parse_url_query(query)

  parts <-
    c(resource, ( strsplit(path, "/") |> unlist() )) |>
    as.list()

  names(parts) <- c("resource", "flowRef","key","providerRef")[seq_along(parts)]

  args <- c(parts, params)

  expr <- bquote(
    sdmx_req_data_v2_1(..(args)),
    splice = TRUE
  )

  list(
    expr = expr,
    args = c(list(req = endpoint), parts, params)
  )
}

parse_url_query <- function(x){
  x <- strsplit(x, "&", fixed = TRUE) |> unlist()
  val <- sub(".*=", "", x) |> as.list()
  names(val) <- sub("=.*", "", x)
  print(list(query=val))
  val
}
