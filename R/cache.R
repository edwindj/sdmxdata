cache_path <- function(ref, fileext = ".xml", dir = tempdir()){
  # remove protocol
  ref <-
    ref |>
    sub("^.*//", "", x = _)

  path <- file.path(dir, sprintf("%s%s", ref, fileext))

  # make sure directory exists (ref can contain sub paths)
  path |>
    dirname() |>
    dir.create(showWarnings = FALSE, recursive = TRUE)

  path
}

cache_xml <- function(req, cache_dir = tempdir()){
  in_cache <- !is.null(cache_dir)

  cache_dir <- if (in_cache) cache_dir else tempdir()

  path <- cache_path(req$url, fileext = ".xml", dir = cache_dir)

  on.exit({
    if (!in_cache){
      unlink(path)
    }
  })

  if (in_cache && !file.exists(path)){
    resp <- req |>
      httr2::req_perform(path = path)
    # TODO log response when failing, adding debugging
  } else {
    message("Using cached result: '",path,"'")
  }

  doc <- xml2::read_xml(path)
  doc
}


