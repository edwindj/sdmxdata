# utility function for setting an argument to NULL if it is not specified,
# and otherwise it behaves like `match.arg`
# `choices` may be omitted, just like in match.arg.
missing_or_match <- function(x, choices){
  substitute({
    if (missing(x)){
      NULL
    } else{
      match.arg(x, choices)
    }
  }) |>
  eval(parent.frame(n = 1)) # this works in the function where it is used
}
