if (interactive()){
  dfs <- sdmx_v2_1_get_dataflows()
  flowRef <- dfs$ref[1]

  d <-
    sdmx_v2_1_structure_request(flowRef = flowRef) |>
    xml2::as_xml_document()

  d
}
