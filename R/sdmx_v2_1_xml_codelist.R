sdmx_v2_1_xml_codelist <- function(node){
  cl <- node |> xml2::xml_find_all(".//s:Codelist", ns = ns_v2_1)
  d <- data.frame(
    id = cl |> xml2::xml_attr("id"),
    agencyID = cl |> xml2::xml_attr("agencyID"),
    version = cl |> xml2::xml_attr("version"),
    isFinal = cl |> xml2::xml_attr("isFinal"),
    name_nl = cl |> xml2::xml_find_first("c:Name[@xml:lang='nl']", ns = ns_v2_1) |> xml2::xml_text(),
    name_en = cl |> xml2::xml_find_first("c:Name[@xml:lang='en']", ns = ns_v2_1) |> xml2::xml_text()
  )
  d$ref <- paste(d$agencyID, d$id, d$version, sep = ",")
  d$resourceID <- d$id
  d
}

# assumes that the input is a codelist node
sdmx_v2_1_xml_codes <- function(node){
  xml_codes <- node |> xml2::xml_find_all("./s:Code", ns = ns_v2_1)
  xml_codes[[2]]

  d <- data.frame(
    id = xml_codes |> xml2::xml_attr("id"),
    name_nl =
      xml_codes |>
      xml2::xml_find_first("c:Name[@xml:lang='nl']", ns = ns_v2_1) |>
      xml2::xml_text(),
    name_en =
      xml_codes |>
      xml2::xml_find_first("c:Name[@xml:lang='en']", ns = ns_v2_1) |>
      xml2::xml_text(),
    parent_id =
      xml_codes |>
      xml2::xml_find_first("s:Parent/Ref", ns = ns_v2_1) |>
      xml2::xml_attr("id")
  )
  d
}
