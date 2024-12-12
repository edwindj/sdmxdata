if (interactive()){
  dfs <- sdmx_v2_1_get_dataflows()
  flowRef <- dfs$ref[1]

  d <-
    sdmx_v2_1_data_request(flowRef = flowRef) |>
    sdmx_v2_1_as_xml()

  d |>
    xml2::xml_find_all(".//generic:ObsValue") |>
    xml2::xml_text() |>
    head()
}
