consume_sdmx_url <- function(x){
  s <- sdmx_parse_data_url(x)

  flowRef <- s$args$flowRef
  key <- s$args$key

  flwrf <-
    strsplit(flowRef, ",") |>
    unlist() |>
    as.list()

  names(flwrf) <- c("agencyID", "id", "version")[seq_along(flwrf)]

  if (length(key) > 0){
    filter_on <-
      strsplit(key, "\\.") |>
      unlist() |>
      as.list() |>
      lapply(\(x) {
        strsplit(x, "\\+") |> unlist()
      })
  }
  dsd <- get_dataflow_structure(
    endpoint = s$args$endpoint,
    agencyID = flwrf$agencyID,
    id = flwrf$id,
    version = flwrf$version
  )
  names(filter_on) <- names(dsd$dimensions)

  filter_on <- filter_on[sapply(filter_on, length) > 0]

  args <- c(endpoint = s$args$endpoint, flwrf)

  expr <- bquote(
    get_observations(..(args), filter_on = .(filter_on)),
    splice = TRUE
  )

  list(
    expr = expr,
    args = args,
    filter_on = filter_on
  )
}


# url <- "https://ec.europa.eu/eurostat/api/dissemination/sdmx/2.1/data/NAMA_10_GDP/A.CP_MEUR.B1GQ.BE+LU"
# req <- url |> sdmx_v2_1_dataurl_request()
#
# req |> httr2::req_perform(path = "example/oecd.csv")
