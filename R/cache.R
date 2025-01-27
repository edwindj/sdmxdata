cache_path <- function(ref, fileext = ".xml", dir = tempdir()){
  # remove protocol
  ref <-
    ref |>
    sub("^.*//", "", x = _)

  path <- file.path(
    dir,
    "sdmxdata",
    sprintf("%s%s", ref, fileext)
  )

  # make sure directory exists (ref can contain sub paths)
  path |>
    dirname() |>
    dir.create(showWarnings = FALSE, recursive = TRUE)

  path
}

cache_xml <- function(
    req,
    cache_dir = tempdir(),
    verbose = getOption("sdmxdata.verbose", FALSE)
  ){
  should_cache <- !is.null(cache_dir)

  cache_dir <- if (should_cache) cache_dir else tempdir()

  path <- cache_path(req$url, fileext = ".xml", dir = cache_dir)

  on.exit({
    if (!should_cache){
      unlink(path)
    }
  })

  in_cache <- file.exists(path) && should_cache
  if (!in_cache){
    resp <- req |>
      httr2::req_perform(path = path)
    if (verbose){
      message("[cache:add]: ", dQuote(path))
    }

    # TODO log response when failing, adding debugging
  } else {
    if (verbose){
      message("[cached:]", dQuote(path))
    }
  }

  doc <- xml2::read_xml(path)
  doc
}

# returns path to json file
cache_json <- function(
    req,
    key = req$url,
    simplifyVector = TRUE,
    ...,
    cache_dir = tempdir(),
    verbose = getOption("sdmxdata.verbose", FALSE)
  ){

  should_cache <- !is.null(cache_dir)
  cache_dir <- if (should_cache) cache_dir else tempdir()

  path <- cache_path(key, fileext = ".json", dir = cache_dir)

  on.exit({
    if (!should_cache){
      unlink(path)
    }
  })

  in_cache <- file.exists(path)

  if (!in_cache || !should_cache){
    resp <- req |>
      httr2::req_perform(path = path)

    if (verbose){
      if (should_cache) {
        message("[cache:add]: ", path |> dQuote())
      } else {
        message("[cache:disabled]")
      }
    }
  } else if (verbose){
    message("[cached]: ",path |> dQuote())
  }

  jsonlite::read_json(path, simplifyVector = simplifyVector, ...) |>
    structure(
      was_cached = (in_cache & should_cache)
    )
}
