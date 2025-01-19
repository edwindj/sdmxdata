# get columns and ensure the result contains the columns
ensure <- function(x, clmns = names(x)){
  for (n in clmns){
    if (is.null(x[[n]])){
      x[[n]] <- NA_character_
    }
  }
  x[, clmns]
}
