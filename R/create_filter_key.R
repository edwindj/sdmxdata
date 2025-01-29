create_filter_key <- function(dims, filter_on){
  if (is.null(filter_on)){
    return(NULL)
  }

  nms <- names(dims) |> dQuote() |> paste(collapse = ",")

  if (!is.list(filter_on) || is.null(names(filter_on))){
    stop("'filter_on' must be a named list with at one or more of the",
         " following dimension names:\n  ", nms,
         call. = FALSE)
  }

  #check filter
  allowed <- c(names(dims), "TIME_PERIOD_START", "TIME_PERIOD_END")

  chk <- names(filter_on) %in% allowed
  if (!all(chk)){
    warning("'filter_on' contains invalid dimension name(s): ",
         paste0("'", names(filter_on)[!chk], "'", collapse = ","),
         "\n  It must be one of the following dimension names: ", nms,
         call. = FALSE
    )
  }

  # check if codes exist
  for (id in names(filter_on)){
    f <- filter_on[[id]]
    if (!is.character(f)){
      stop("The filter value for '", id, "' must be a character vector",
           call. = FALSE)
    }
    dim <- dims[[id]] %||% list()
    code <- dim$codes
    if ( !is.null(code) && !all(f %in% code$id)){
      warning("The filter value for '", id, "' contains unavailable code(s): ",
              f[!f %in% code$id] |>
                dQuote() |>
                paste(collapse = ","),
              call. = FALSE
      )
    }
  }

  key <- lapply(allowed, function(id){
    paste(filter_on[[id]], collapse = "+")
  }) |>
    paste(collapse = ".")

  key
}
