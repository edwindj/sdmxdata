data("endpoints")
endpoints[, 1:3]

OECD <- get_endpoint("OECD")
OECD$verbose <- TRUE
list_oecd <- OECD |> list_dataflows(cache=TRUE)
