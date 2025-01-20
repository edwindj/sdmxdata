library(tinytest)

xml_codelist <- sdmxdata:::xml_codelist
sdmx_v2_1_xml_codes <- sdmxdata:::sdmx_v2_1_xml_codes

doc <- xml2::read_xml(system.file("extdata/codelist.xml", package = "sdmxdata"))
doc

xml_codelist(doc)

doc_codes <- xml2::read_xml(system.file("extdata/codelist1.xml", package = "sdmxdata"))
cl <- doc_codes |> xml2::xml_find_all(".//s:Codelist", ns = sdmxdata:::ns_v2_1)
sdmx_v2_1_xml_codes(cl[[1]])
