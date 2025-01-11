cache_path <- function(ref, fileext = ".xml", dir = tempdir()){
  # remove protocol
  ref <-
    ref |>
    sub("^.*//", "", x = _)

  path <- file.path(
    dir,
    "cbsopendata",
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
    verbose = getOption("cbsopendata.verbose", FALSE)
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
      message("[cache:add]: ", sQuote(path))
    }

    # TODO log response when failing, adding debugging
  } else {
    if (verbose){
      message("[cached:]", sQuote(path))
    }
  }

  doc <- xml2::read_xml(path)
  doc
}

# returns path to json file
cache_json <- function(
    req,
    simplifyVector = TRUE,
    ...,
    cache_dir = tempdir(),
    verbose = getOption("cbsopendata.verbose", FALSE)
  ){

  should_cache <- !is.null(cache_dir)
  cache_dir <- if (should_cache) cache_dir else tempdir()

  path <- cache_path(req$url, fileext = ".json", dir = cache_dir)

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
        message("[cache:add]: ", path)
      } else {
        message("[cache:disabled]")
      }
    }
  } else if (verbose){
    message("[cached]: ",path,"'")
  }

  jsonlite::read_json(path, simplifyVector = simplifyVector, ...) |>
    structure(
      was_cached = (in_cache & should_cache)
    )
}

ObjectCache <- function(
  key,
  cache_dir = tempdir(),
  verbose = getOption("cbsopendata.verbose", FALSE)
){

  e <- new.env()

  disabled <- is.null(cache_dir)
  e$disabled <- disabled

  if (disabled){
    cache_dir <- tempdir()
    path <- cache_path(key, fileext = ".rds", dir = cache_dir)
    unlink(path)

    e$save <- function(object){
      NULL
    }

    e$get <- function(){
      NULL
    }

    e$is_cached <- function(){
      FALSE
    }
    return(e)
  }

  e$path <- cache_path(key, fileext = ".rds", dir = cache_dir)
  e$verbose <- verbose

  e$is_cached <- function(){
    file.exists(e$path)
  }

  e$save <- function(object){
    if (e$verbose){
      message("[cache:add]: ", e$path)
    }
    saveRDS(object, e$path)
  }

  e$get <- function(){
    if (file.exists(e$path)){
      if (e$verbose){
        message("[cached]: ", e$path)
      }
      readRDS(e$path)
    } else {
      if (e$verbose){
        message("[cache:miss]: ", e$path)
      }
      NULL
    }
  }
  e
}
