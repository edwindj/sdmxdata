
dfs <- get_dataflows("https://lustat.statec.lu/rest")

attr(dfs, "contentLanguages")

View(dfs)

p <- tempfile("opendata", fileext = ".csv")

req <- sdmx_rest_data_query(
  "https://lustat.statec.lu/rest",
  flowRef = dfs$flowRefs[1]
)

add_accept <- function(req, ...){
  add <- list(...)
  added <- paste0(names(add), "=", unlist(add), collapse = ";")
  accept <-
    c(req$headers$accept,added) |>
    paste(collapse = ";")
  req |> httr2::req_headers("accept" = accept)
}

resp<-
  req |>
  add_accept(labels = "both") |>
  httr2::req_perform(path = p)
