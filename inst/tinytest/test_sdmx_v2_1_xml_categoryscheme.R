library(tinytest)
library(xml2)

doc <- xml2::read_xml(system.file("extdata", "categoryscheme.xml", package = "cbsopendata"))

d <- cbsopendata:::xml_categoryscheme(doc)

expect_equal(d$agencyID, "NL1")
expect_equal(d$id, "CS_CBS")
expect_equal(d$version, "1.0")
expect_equal(d$isFinal, "false")
expect_equal(d$name_nl, "CBS Thema")

cats <- d$categories[[1]]
expect_true(is.data.frame(cats))
expect_equal(nrow(cats), 5)
expect_equal(cats$id, c("CN", "REG", "LAB", "ECO", "SOC"))

d_flattened <- cbsopendata:::sdmx_v2_1_xml_categories_flattened(doc)

expect_equal(names(d_flattened), c("id", "name_nl", "name_en", "parent_id"))
