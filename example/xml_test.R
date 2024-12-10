library(xml2)

doc <- read_xml("https://sdmx-api.beta.cbs.nl/rest/dataflow/NL1_DOUT?references=all")

ns <- c(
  c = "http://www.sdmx.org/resources/sdmxml/schemas/v2_1/common",
  m = "http://www.sdmx.org/resources/sdmxml/schemas/v2_1/message",
  s = "http://www.sdmx.org/resources/sdmxml/schemas/v2_1/structure"
)

dfs <- xml_find_all(doc, ".//s:Dataflow", ns = ns)


structures <- xml_find_first(doc, "/m:Structure/m:Structures", ns = ns)

dataflows <- xml_find_all(structures, "s:Dataflows/s:Dataflow", ns = ns)
codelists <- xml_find_all(structures, "s:Codelists/s:Codelist", ns = ns)
concepts <- xml_find_first(structures, "s:Concepts", ns = ns)
datastructures <- structures |> xml_find_all("s:DataStructures/s:DataStructure", ns = ns)

codelist_node <- codelists[[2]]

lang <- "nl"


get_codelist <- function(codelist_node, lang = "nl"){
  id <- xml_attr(codelist_node, "id")
  name <- xml_find_first(codelist_node, "c:Name", ns = ns) |> xml_text()

  codes <- xml_find_all(codelist_node, "s:Code", ns = ns)
  code_id <- codes |> xml_attr("id")
  code_name <- codes |>
    xml_find_first(
      "c:Name[@xml:lang='%s']" |> sprintf(lang),
      ns = ns
    ) |>
    xml_text()

  code_parent_id <- codes |> xml_find_first("s:Parent/Ref", ns = ns) |> xml_attr("id")

  code_df <- data.frame(
    id = code_id,
    name = code_name,
    parent_id = code_parent_id
  )

  d <- data.frame(
    id = id,
    name = name
  )

  d$codes <- list(code_df)
  d
}

# language stuff
languages <-
  xml_find_all(doc, "//c:Name[@xml:lang]", ns = ns)  |> xml_attr("lang") |>
  unique()

languages
dataflows
