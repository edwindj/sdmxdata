consume_sdmx_url <- function(x, verbose = FALSE){
  s <- sdmx_parse_data_url(x)

  flowRef <- s$flowRef
  key <- s$key
  endpoint <- s$endpoint

  if (!is.null(s$flowRef)){
    args <- s$flowRef |> strsplit(",") |> unlist() |> as.list()
    names(args) <- c("agencyID", "id", "version")[seq_along(args)]
    #TODO add language?
    args$verbose <- verbose

    if (!is.null(s$key)){
      dfs <- bquote(
        get_dataflow_structure(
          endpoint = .(endpoint),
          ..(args)
        ),
        splice = TRUE
      ) |> eval()

      id <- dfs$columns$id
      filter_on <-
        s$key |>
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
    args = args
  )
}


# url <- "https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/NAMA_10_GDP/A.CP_MEUR.B1GQ.BE+LU"
# req <- url |> sdmx_v2_1_dataurl_request()
#
# req |> httr2::req_perform(path = "example/oecd.csv")
