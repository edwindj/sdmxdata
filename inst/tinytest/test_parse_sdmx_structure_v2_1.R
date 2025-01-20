library(tinytest)
library(xml2)

# doc <- read_xml("https://sdmx-api.beta.cbs.nl/rest/dataflow/NL1_DOUT?references=all")
# write_xml(doc, file.path(system.file("extdata", package="sdmxdata"), "NL1_DOUT.xml"))

doc <- read_xml(
  file.path(system.file("extdata", package="sdmxdata"), "NL1_DOUT.xml")
)


# language stuff
d <- sdmxdata:::xml_parse_structure(doc)
