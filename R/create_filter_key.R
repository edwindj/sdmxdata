create_filter_key <- function(dims, filter_on){
  if (is.null(filter_on)){
    return(NULL)
  }

  nms <- dims$id |> sQuote() |> paste(collapse = ",")

  if (!is.list(filter_on) || is.null(names(filter_on))){
    stop("'filter_on' must be a named list with at one or more of the",
         " following dimension names:\n  ", nms,
         call. = FALSE)
  }

  #check filter
  chk <- names(filter_on) %in% dims$id
  if (!all(chk)){
    stop("'filter_on' contains invalid dimension name(s): ",
         paste0("'", names(filter_on)[!chk], "'", collapse = ","),
         "\n  It must be one of the following dimension names: ", nms,
         call. = FALSE
    )
  }

  # TODO check codes, generate a warning when a code is not found in the codelist
  # of a dimension

  key <- lapply(dims$id, function(id){
    paste(filter_on[[id]], collapse = "+")
  }) |>
    paste(collapse = ".")

  key
}
