library(tinytest)

# req <- sdmx_v2_1_structure_request(resource = "codelist")
# cl <- sdmx_v2_1_structure_request(resource = "codelist", detail = "allstubs") |>
#   sdmx_v2_1_as_xml() |>
#   sdmx_v2_1_xml_codelist()
#
# a <- 11
#
# sdmx_v2_1_structure_request(
#   resource = "codelist",
#   agencyID = cl$agencyID[a],
#   resourceID = cl$resourceID[a],
#   version = cl$version[a],
#   detail = "full") |>
#   sdmx_v2_1_as_xml() |>
#   write_xml("inst/extdata/codelist1.xml")
#
# req |>
#   httr2::req_perform(path="./inst/extdata/codelist.xml")
doc <- xml2::read_xml("./inst/extdata/codelist.xml")
doc

sdmx_v2_1_xml_codelist(doc)

doc_codes <- xml2::read_xml("./inst/extdata/codelist1.xml")
cl <- doc_codes |> xml2::xml_find_all(".//s:Codelist", ns = ns_v2_1)
sdmx_v2_1_xml_codes(cl[[1]])
