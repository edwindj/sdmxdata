library(tinytest)

period <- c("2020-01-01", "2020-W01", "2020-01", "2020-Q1", "2020-S1", "2020")

sdmx_period_valid <- cbsopendata:::sdmx_period_valid

expect_equal(
  sdmx_period_valid(period),
  c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)
)


period <- c("2020-01-01", "2020-W01", "2020-01", "2020-Q1", "2020-S1", "202a")

expect_warning({
  res <- sdmx_period_valid(period)
})
expect_equal(res, c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE))
