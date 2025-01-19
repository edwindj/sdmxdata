if (interactive()){
  dfs <- list_dataflows()
  flowRef <- dfs$ref[1]

  d <-
    sdmx_v2_1_structure_request(flowRef = flowRef) |>
    sdmx_v2_1_as_xml()

  d |>
    xml2::xml_find_all(".//generic:ObsValue") |>
    xml2::xml_text() |>
    head()

  path <- "example/dfs.json"
  d <-
    sdmx_v2_1_structure_request(
      detail = "referencestubs",
      # references = "all",
      format = "json"
    ) |>
    httr2::req_headers("Accept-Language" = "nl") |>
    httr2::req_perform(path=path)

}
