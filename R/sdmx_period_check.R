sdmx_as_isodate <- function(x){
  if (is.numeric(x)){
    x <- as.character(x)
  }

  if (is.character(x)){
    return(x)
  }

  if (is.Date(x)){
    return(format(x, "%Y-%m-%d"))
  }

  if (is.POSIXt(x)){
    return(format(x, "%Y-%m-%dT%H:%M:%S"))
  }
}

sdmx_period_valid <- function(x){
  ch <-
    grepl("\\d{4}-[0-1]\\d-[0-3]\\d", x)| # e.g. 2020-01-01
    grepl("\\d{4}-W[0-5]\\d", x)      | # e.g. 2020-W01
    grepl("\\d{4}-[01]\\d", x)      | # e.g. 2020-01
    grepl("\\d{4}-Q[1-4]", x)       | # e.g. 2020-Q1
    grepl("\\d{4}-S[12]", x)        | # e.g. 2020-S1
    grepl("\\d{4}", x)                # e.g. 2020

  invalid <- which(!ch)
  if (length(invalid) > 0){
    warning("Possible invalid period format: ", paste0("'", x[invalid], "'", collapse = ", "))
  }
  invisible(ch)
}

sdmx_check_period <- function(x){
  if (length(x) != 1){
    stop("x must be a single value", call. = FALSE)
  }
  x <- sdmx_as_isodate(x)
  sdmx_period_valid(x)
  x
}
