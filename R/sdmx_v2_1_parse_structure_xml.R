
# extra necessary metadata from an xml document retrieved with references=all
#' @importFrom xml2 xml_find_all xml_find_first xml_text xml_attr xml_attrs
sdmx_v2_1_parse_structure_xml  <- function(doc, ...){
  structures <- doc |> xml_find_first("/m:Structure/m:Structures", ns = ns_v2_1)

  dataflows <-
    xml_find_all(structures, "s:Dataflows/s:Dataflow", ns = ns_v2_1) |>
    lapply(parse_dataflow, lang = "nl")

  names(dataflows) <- sapply(dataflows, function(x) sprintf("%s,%s,%s", x$agencyID, x$id, x$version))

  codelists <-
    xml_find_all(structures, "s:Codelists/s:Codelist", ns = ns_v2_1) |>
    lapply(parse_codelist, lang = "nl")

  names(codelists) <- sapply(codelists, function(x) sprintf("%s,%s,%s", x$agencyID, x$id, x$version))

  datastructures <-
    xml_find_all(structures, "s:DataStructures/s:DataStructure", ns = ns_v2_1) |>
    lapply(parse_datastructure, lang = "nl")

  names(datastructures) <- sapply(datastructures, function(x) sprintf("%s,%s,%s", x$agencyID, x$id, x$version))

  conceptsschemes <-
    xml_find_all(structures, "s:Concepts/s:ConceptScheme", ns = ns_v2_1) |>
    parse_conceptschemes()

  constraints <- xml_find_all(structures, "s:Constraints", ns = ns_v2_1)

  list(
    dataflows = dataflows,
    datastructures = datastructures,
    conceptschemes = conceptsschemes,
    codelists = codelists,
    constraints = constraints
  )
}

parse_conceptschemes <- function(nodes, lang = "nl"){
  id <- nodes |> xml_attr("id")
  agencyID <- nodes |> xml_attr("agencyID")
  version <- nodes |> xml_attr("version")
  name <- nodes |> xml_find_first("c:Name", ns = ns_v2_1) |> xml_text()

  ref <- paste(agencyID, id, version, sep = ",")

  concepts <- nodes |>
    lapply(parse_concepts, lang = lang)

  d <- data.frame(
    id = id,
    agencyID = agencyID,
    version = version,
    name = name,
    ref = ref
  )

  d$concepts = concepts

  d
}

parse_concepts <- function(scheme, lang = "nl"){
  concepts <- xml_find_all(scheme, "s:Concept", ns = ns_v2_1)

  id <- xml_attr(concepts, "id")
  name <- xml_find_first(concepts, "c:Name", ns = ns_v2_1) |> xml_text()
  description <- xml_find_first(concepts, "c:Description", ns = ns_v2_1) |> xml_text()

  enums <- concepts |>
    xml_find_first("s:CoreRepresentation/s:Enumeration/Ref", ns = ns_v2_1) |>
    xml_attrs() |>
    lapply(as.list)

  enums[is.na(enums)] <- list()

  print(list(enums = enums))
  cl_ref <- enums |> sapply(\(x) ifelse(is.na(x), NA, paste(x$agencyID, x$id, x$version, sep = ",")))

  d <- data.frame(
    id = id,
    name = name,
    description = description
  )
  d$cl_ref <- cl_ref
  d
}

parse_dataflow <- function(node, lang="nl"){

  id <- xml_attr(node, "id")
  agencyID <- xml_attr(node, "agencyID")
  version <- xml_attr(node, "version")

  ref <- paste(agencyID, id, version, sep = ",")

  name <- xml_find_first(node, "c:Name", ns = ns_v2_1) |> xml_text()
  description <- xml_find_first(node, "c:Description", ns = ns_v2_1) |> xml_text()

  structure <-
    xml_find_first(node, "s:Structure/Ref", ns = ns_v2_1) |>
    xml_attrs() |>
    as.list()

  dsd_ref <- sprintf("%s,%s,%s", structure$agencyID, structure$id, structure$version)

  l <- list(
    id = id,
    agencyID = agencyID,
    version = version,
    ref = ref,
    name = name,
    description = description,
    structure = structure,
    dsd_ref = dsd_ref
  )

  l[[sprintf("name_%s", lang)]] <- name
  l
}

parse_datastructure <- function(node, lang = "nl"){
  id <- xml_attr(node, "id")
  agencyID <- xml_attr(node, "agencyID")
  version <- xml_attr(node, "version")

  ref <- paste(agencyID, id, version, sep = ",")

  name <- xml_find_first(node, "c:Name", ns = ns_v2_1) |> xml_text()

  components <- xml_find_first(node, "s:DataStructureComponents", ns = ns_v2_1)
  dimensions <-
    components |>
    xml_find_all("s:DimensionList/s:Dimension", ns = ns_v2_1) |>
    lapply(parse_dimension, lang = lang)

  names(dimensions) <- sapply(dimensions, function(x) x$id)

  timedimension <- components |> xml_find_first("s:DimensionList/s:TimeDimension", ns = ns_v2_1)
  if (length(timedimension)){
    #TODO process it
  }

  attributes <- components |> xml_find_all("s:AttributeList/s:Attribute", ns = ns_v2_1)
  measures <- components |> xml_find_all("s:MeasureList/s:PrimaryMeasure", ns = ns_v2_1)
  list(
    id = id,
    agencyID = agencyID,
    version = version,
    ref = ref,
    name = name,
    dimensions = dimensions
  )
}

parse_dimension <- function(node, lang = "nl"){
  id <- xml_attr(node, "id")
  position <- xml_attr(node, "position") |> as.integer()

  concept <- node |>
    xml_find_first("s:ConceptIdentity/Ref", ns = ns_v2_1) |>
    xml_attrs() |>
    as.list()

  cs_ref <- sprintf("%s,%s,%s", concept$agencyID, concept$maintainableParentID, concept$maintainableParentVersion)

  enum <- node |>
    xml_find_first("s:LocalRepresentation/s:Enumeration/Ref", ns = ns_v2_1) |>
    xml_attrs() |>
    as.list()

  cl_ref <- with(enum, paste0(agencyID, id, version, sep = ","))

  list(
    id = id,
    position = position,
    concept = concept,
    cs_ref = cs_ref,
    enum = enum,
    cl_ref = cl_ref
  )
}

parse_codelist <- function(codelist_node, lang = "nl"){
  id <- xml_attr(codelist_node, "id")
  agencyID <- xml_attr(codelist_node, "agencyID")
  version <- xml_attr(codelist_node, "version")

  ref <- paste(agencyID, id, version, sep = ",")

  name <- xml_find_first(codelist_node, "c:Name", ns = ns_v2_1) |> xml_text()

  codes <- xml_find_all(codelist_node, "s:Code", ns = ns_v2_1)
  code_id <- codes |> xml_attr("id")
  code_name <- codes |>
    xml_find_first(
      "c:Name[@xml:lang='%s']" |> sprintf(lang),
      ns = ns_v2_1
    ) |>
    xml_text()

  code_parent_id <- codes |> xml_find_first("s:Parent/Ref", ns = ns_v2_1) |> xml_attr("id")

  code_df <- data.frame(
    id = code_id,
    name = code_name,
    parent_id = code_parent_id
  )

  l <- list(
    id = id,
    agencyID = agencyID,
    version = version,
    ref = ref,
    name = name,
    codes = code_df
  )
  l[[sprintf("name_%s", lang)]] <- name

  l
}
