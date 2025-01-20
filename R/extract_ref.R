extract_ref <- function(ref){
  m <- regexec("(.+):(.+)\\((.+)\\)", ref)

  parts <-
    regmatches(ref, m) |>
    sapply(\(x) {
      names(x) <- c("ref", "agencyID", "id", "version")
      x[-1]
    }) |>
    t() |>
    as.data.frame()

  parts
}
