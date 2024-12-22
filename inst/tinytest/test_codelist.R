library(tinytest)

sdmx_v2_1_xml_codelist <- cbsopendata:::sdmx_v2_1_xml_codelist
sdmx_v2_1_xml_codes <- cbsopendata:::sdmx_v2_1_xml_codes

doc <- xml2::read_xml(system.file("extdata/codelist.xml", package = "cbsopendata"))
doc

sdmx_v2_1_xml_codelist(doc)

doc_codes <- xml2::read_xml(system.file("extdata/codelist1.xml", package = "cbsopendata"))
cl <- doc_codes |> xml2::xml_find_all(".//s:Codelist", ns = cbsopendata:::ns_v2_1)
sdmx_v2_1_xml_codes(cl[[1]])
