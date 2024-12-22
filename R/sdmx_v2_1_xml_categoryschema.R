sdmx_v2_1_xml_categoryscheme <- function(doc){
  d <- doc
  s <- xml2::xml_find_all(d, "m:Structures/s:CategorySchemes/s:CategoryScheme", ns = ns_v2_1)

  s_d <- data.frame(
    id = xml2::xml_attr(s, "id"),
    agencyID = xml2::xml_attr(s, "agencyID"),
    version = xml2::xml_attr(s, "version"),
    isFinal = xml2::xml_attr(s, "isFinal"),
    # maybe make this more robust and unroll the language stuff later
    name_nl = s |>
      xml2::xml_find_first("c:Name[@xml:lang='nl']", ns = ns_v2_1) |>
      xml2::xml_text(),
    description_nl = s |>
      xml2::xml_find_first("c:Description[@xml:lang='nl']", ns = ns_v2_1) |>
      xml2::xml_text(),
    name_en = s |>
      xml2::xml_find_first("c:Name[@xml:lang='en']", ns = ns_v2_1) |>
      xml2::xml_text(),
    description_en = s |>
      xml2::xml_find_first("c:Description[@xml:lang='en']", ns = ns_v2_1) |>
      xml2::xml_text()
  )

  categories <- s |>
    lapply(function(x){
      x |>
        xml2::xml_find_all("s:Category", ns = ns_v2_1) |>
        sdmx_v2_1_xml_categories()
    }
  )

  s_d$categories <- categories

  # View(s_d$categories[[1]])
  s_d
}

sdmx_v2_1_xml_categories <- function(nodes, depth = 1){
  if (length(nodes) == 0){
    return(NULL)

  }

  # message("depth: ", depth)

  d <- data.frame(
    id = xml2::xml_attr(nodes, "id"),
    name_nl = nodes |>
      xml2::xml_find_first("c:Name[@xml:lang='nl']", ns = ns_v2_1) |>
      xml2::xml_text(),
    name_en = nodes |>
      xml2::xml_find_first("c:Name[@xml:lang='en']", ns = ns_v2_1) |>
      xml2::xml_text()
  )

  categories <- nodes |>
    lapply(function(x){
      x |>
        xml2::xml_find_all("s:Category", ns = ns_v2_1) |>
        sdmx_v2_1_xml_categories(depth = depth + 1)
    }
  )

  if (all(sapply(categories, is.null))){
    categories <- NULL
  }
  # browser(expr = depth == 1)

  d$categories <- categories
  d
}

sdmx_v2_1_xml_categories_flattened <- function(doc){
  cats <- doc |> xml2::xml_find_all(".//s:Category", ns = ns_v2_1)

  d <- data.frame(
    id = cats |> xml2::xml_attr("id"),
    name_nl = cats |> xml2::xml_find_first("c:Name[@xml:lang='nl']", ns = ns_v2_1) |> xml2::xml_text(),
    name_en = cats |> xml2::xml_find_first("c:Name[@xml:lang='en']", ns = ns_v2_1) |> xml2::xml_text()
  )

  d

  parent <- cats |> xml2::xml_find_first("./..", ns = ns_v2_1)
  parent_id <- parent |> xml2::xml_attr("id")
  is.na(parent_id) <- parent |> xml2::xml_name() != "Category"
  d$parent_id <- parent_id
  d
}
