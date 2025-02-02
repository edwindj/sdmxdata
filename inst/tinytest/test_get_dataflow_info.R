library(tinytest)

dsd <- get_dataflow_structure(id = "DF_37230ned", agencyID="NL1.CNVT", version="1.0")

expect_equal(dsd$id, "DF_37230ned")
expect_equal(dsd$agencyID, "NL1.CNVT")
expect_equal(dsd$version, "1.0")

expect_equal(dsd$dimensions |> length(), 3)
expect_equal(dsd$dimensions |> names(), c("RegioS", "Perioden", "Topics"))

