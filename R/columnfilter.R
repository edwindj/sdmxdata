column_filter <- function(x, column = NULL, codes = NULL){
  cl <- class(x)
}

has_string <- function(x){
  x <- as.character(x)
  class(x) <- c("has_string")
  invisible(x)
}
