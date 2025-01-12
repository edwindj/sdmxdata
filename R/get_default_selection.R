# turns an annotation of the form "dim_id=sel1+sel2,dim_id2=sel3" into a
# something filter_on can use
get_default_selection <- function(dfi){
  ann <- dfi$raw$data$dataflows$annotations[[1]]
  def_sel <- ann[ann$type=="DEFAULT","title"]

  if (length(def_sel)==0){
    return(NULL)
  }

  s <- strsplit(def_sel, ",") |> unlist()
  s1 <- s |>
    strsplit("=") |>
    lapply(\(x){
      dim_id <- x[1]
      sel <- x[2] |> strsplit("\\+") |> unlist()
      list(sel) |>
        stats::setNames(dim_id)
    }) |>
    unlist(recursive = FALSE)
  s1
}
