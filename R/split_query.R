split_data_query <- function(qr){
  l <- qr |>
    strsplit("\\.") |>
    unlist() |>
    strsplit("\\+")
  l
}


#qr <- "A.b1+b1.C.d2+d5"

join_data_query <- function(l){
  l |>
    lapply(function(x) paste(x, collapse = "+")) |>
    paste(collapse = ".")
}
