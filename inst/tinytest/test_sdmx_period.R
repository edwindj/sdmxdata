library(tinytest)

period <- c("2020-01-01", "2020-W01", "2020-01", "2020-Q1", "2020-S1", "2020")

expect_equal(
  sdmx_period_check(period),
  c(TRUE, TRUE, TRUE, TRUE, TRUE, TRUE)
)


period <- c("2020-01-01", "2020-W01", "2020-01", "2020-Q1", "2020-S1", "202a")

expect_warning({
  res <- sdmx_period_check(period)
})
expect_equal(res, c(TRUE, TRUE, TRUE, TRUE, TRUE, FALSE))
