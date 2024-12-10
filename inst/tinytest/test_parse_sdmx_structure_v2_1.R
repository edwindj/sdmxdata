library(tinytest)
library(xml2)

# doc <- read_xml("https://sdmx-api.beta.cbs.nl/rest/dataflow/NL1_DOUT?references=all")
# write_xml(doc, file.path(system.file("extdata", package="cbsopendata"), "NL1_DOUT.xml"))

doc <- read_xml(
  file.path(system.file("extdata", package="cbsopendata"), "NL1_DOUT.xml")
)


# language stuff
d <- cbsopendata:::parse_sdmx_structure_v2_1(doc)
