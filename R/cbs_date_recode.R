cbs_date_recode <- function(dsd){
  codes <- dsd$dimensions$Perioden$codes
  period <- codes$id
  PATTERN <- "(\\d{4})(\\w{2})(\\d{2})"
  year   <- as.integer(sub(PATTERN, "\\1", period))
  number <- as.integer(sub(PATTERN, "\\3", period))
  type   <- factor(sub(PATTERN, "\\2", period))

#TODO add switch for begin / middle / period or number

  # year conversion
  is_year <- type %in% c("JJ")
  is_quarter <- type %in% c("KW")
  is_month <- type %in% c("MM")
  is_week <- type %in% c("W1")
  is_week_part <- type %in% c("X0")


  # date
  date_type <- match.arg(date_type)

  if (date_type == "Date"){
    period <- as.POSIXct(character())
    period[is_year] <- ISOdate(year, 1, 1, tz="")[is_year]
    period[is_quarter] <- ISOdate(year, 1 + (number - 1) * 3, 1, tz="")[is_quarter]
    period[is_month] <- ISOdate(year, number, 1, tz="")[is_month]
    period[is_week] <- {
      d <- as.Date(paste0(year, "-1-1")) + 7 * (number - 1)
      # a week starts at monday
      wday <- as.integer(format(d, "%u"))
      d <- d + ((7 - wday - 1) %% 7)
      d
    }[is_week]
    period[is_week_part] <- as.Date(paste0(year, "-1-1"))[is_week_part]
    period <- as.Date(period)
  } else if (date_type == "numeric"){
    period <- numeric()
    period[is_year] <- year[is_year] + 0.5
    period[is_quarter] <- (year + (3*(number - 1) + 2) / 12)[is_quarter]
    period[is_month] <- (year + (number - 0.5) / 12)[is_month]
    period[is_week] <- (year + (number - 0.5)/53)[is_week]
    period[is_week_part] <- year

  }

  codes$date <- period
  dsd$dimensions$Perioden$codes <- codes
  dsd
}
