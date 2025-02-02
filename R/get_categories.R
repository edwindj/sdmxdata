get_categories <- function(ref) {
  cs <- list_categoryschemes()
  idx <- which(cs$ref == ref)
  cs <- list_categoryschemes(raw = TRUE)
  s <- cs$data$categorySchemes[[idx]]
  categories <- s$categories |> lapply(select_props)
  names(categories) <- sapply(categories, \(x) x$name)
  categories
}

select_props <- function(category){
  cat <- category[c("id", "name")]
  cats <- category$categories
  if (!is.null(cats)){
    names(cats) <- sapply(cats, \(x) x$name)
    cat$categories <-
      cats |>
      lapply(select_props)
  }
  cat
}
