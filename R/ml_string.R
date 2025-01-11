ml_string <- function(nodes, xpath){
  nodes |>
    lapply(function(x){
      txt <- x |> xml_find_all(xpath, ns = ns_v2_1)
      lang <- txt |> xml2::xml_attr("lang")
      text <- txt |> xml2::xml_text()

    })
}
