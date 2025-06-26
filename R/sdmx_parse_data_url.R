sdmx_parse_data_url <- function(x, resource = c("data", "metadata"), verbose = FALSE){
  x <- utils::URLdecode(x)
  resource <- match.arg(resource)

  detect <- sprintf("/%s/", resource)
  x1 <- strsplit(x, detect) |> unlist()

  stopifnot(length(x1) == 2)

  endpoint <- x1[1]

  path <- sub("\\?.*", "", x1[2])
  query <- sub("[^?]*\\??", "", x1[2])

  params <- parse_url_query(query)
  params$dimensionAtObservation <- NULL

  parts <-
    c(resource, ( strsplit(path, "/") |> unlist() )) |>
    as.list()

  if (resource == "data"){
    names(parts) <- c("resource", "flowRef","key","providerRef")[seq_along(parts)]
  }

  if (!is.null(parts$flowRef)){
    args <- parts$flowRef |> strsplit(",") |> unlist()
    names(args) <- c("agencyID", "id", "version")[seq_along(args)]
    args <- c(args, params)
    args$verbose <- verbose

    if (!is.null(parts$key)){
      dfs <- bquote(
        get_dataflow_structure(
          endpoint = .(endpoint),
          ..(args)
        ),
        splice = TRUE
      ) |> eval()

      id <- dfs$columns$id
      filter_on <-
        parts$key |>
        strsplit("\\.") |>
        unlist() |>
        lapply(\(x){
          strsplit(x, "\\+") |> unlist()
        })
      names(filter_on) <- id[seq_along(filter_on)]
      args$filter_on <- filter_on[sapply(filter_on, length) > 0]
    } else {
      args["filter_on"] = list(NULL)
    }
  }

  expr <- bquote(
    get_observations(endpoint = .(endpoint), ..(args)),
    splice = TRUE
  )

  list(
    expr = expr,
    args = c(list(endpoint = endpoint), args)
  )
}

parse_url_query <- function(x){
  x <- strsplit(x, "&", fixed = TRUE) |> unlist()
  val <- sub(".*=", "", x) |> as.list()
  names(val) <- sub("=.*", "", x)
  # print(list(query=val))
  val
}
