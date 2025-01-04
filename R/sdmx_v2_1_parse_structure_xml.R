
# extra necessary metadata from an xml document retrieved with references=all
#' @importFrom xml2 xml_find_all xml_find_first xml_text xml_attr xml_attrs
sdmx_v2_1_parse_structure_xml  <- function(doc, ..., lang = "nl"){
  structures <- doc |> xml_find_first("/m:Structure/m:Structures", ns = ns_v2_1)

  dataflows <-
    xml_find_all(structures, "s:Dataflows/s:Dataflow", ns = ns_v2_1) |>
    lapply(parse_dataflow, lang = lang) |>
    lapply(as.data.frame) |>
    data.table::rbindlist(fill = TRUE) |>
    as.data.frame()

  # names(dataflows) <- sapply(dataflows, function(x) sprintf("%s,%s,%s", x$agencyID, x$id, x$version))

  codelists <-
    xml_find_all(structures, "s:Codelists/s:Codelist", ns = ns_v2_1) |>
    lapply(parse_codelist, lang = lang) |>
    data.table::rbindlist(fill = TRUE) |>
    as.data.frame()

  # names(codelists) <- sapply(codelists, function(x) sprintf("%s,%s,%s", x$agencyID, x$id, x$version))

  datastructures <-
    xml_find_all(structures, "s:DataStructures/s:DataStructure", ns = ns_v2_1) |>
    lapply(parse_datastructure, lang = lang) |>
    data.table::rbindlist(fill = TRUE) |>
    as.data.frame()

  # names(datastructures) <- sapply(datastructures, function(x) sprintf("%s,%s,%s", x$agencyID, x$id, x$version))

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
    lapply(parse_concepts, lang = lang, ref = ref)

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

parse_concepts <- function(scheme, lang = "nl", ref = NULL){
  concepts <- xml_find_all(scheme, "s:Concept", ns = ns_v2_1)

  id <- xml_attr(concepts, "id")
  name <- xml_find_first(concepts, "c:Name", ns = ns_v2_1) |> xml_text()
  description <- xml_find_first(concepts, "c:Description", ns = ns_v2_1) |> xml_text()
  ref <- paste(ref, id, sep=",")

  enums <- concepts |>
    xml_find_first("s:CoreRepresentation/s:Enumeration/Ref", ns = ns_v2_1) |>
    xml_attrs() |>
    lapply(as.list)

  enums[is.na(enums)] <- list()

  # print(list(enums = enums))
  cl_ref <- enums |>
    sapply(\(x) ifelse(length(x) == 1, NA, paste(x$agencyID, x$id, x$version, sep = ",")))

  d <- data.frame(
    id = id,
    name = name,
    description = description,
    ref = ref
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

  l <- data.frame(
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
    lapply(parse_dimension, lang = lang, ref = ref) |>
    data.table::rbindlist(fill = TRUE) |>
    as.data.frame()

  # names(dimensions) <- sapply(dimensions, function(x) x$id)

  timedimension <- components |> xml_find_first("s:DimensionList/s:TimeDimension", ns = ns_v2_1)
  if (length(timedimension)){
    #TODO process it
  }

  attributes <- components |>
    xml_find_all("s:AttributeList/s:Attribute", ns = ns_v2_1) |>
    parse_attributes(lang = lang)

  measures <- components |>
    xml_find_all("s:MeasureList/s:PrimaryMeasure", ns = ns_v2_1) |>
    parse_measures(lang = lang)

  d <- data.frame(
    id = id,
    agencyID = agencyID,
    version = version,
    ref = ref,
    name = name
  )

  d$dimensions <- list(dimensions)
  d$attributes <- list(attributes)
  d$measures <- list(measures)

  d
}

parse_dimension <- function(node, lang = "nl", ref = NULL){
  id <- xml_attr(node, "id")
  ref <- paste(ref, id, sep = ",")
  position <- xml_attr(node, "position") |> as.integer()

  concept <- node |>
    xml_find_first("s:ConceptIdentity/Ref", ns = ns_v2_1) |>
    xml_attrs() |>
    as.list()

  concept_ref <- sprintf(
    "%s,%s,%s,%s",
    concept$agencyID,
    concept$maintainableParentID,
    concept$maintainableParentVersion,
    concept$id
  )

  enum <- node |>
    xml_find_first("s:LocalRepresentation/s:Enumeration/Ref", ns = ns_v2_1) |>
    xml_attrs() |>
    as.list()

  cl_ref <- with(enum, paste(agencyID, id, version, sep = ","))

  d <- data.frame(
    id = id,
    position = position,
    ref = ref,
    concept_ref = concept_ref,
    cl_ref = cl_ref
  )
  d$enum <- list(enum)
  d$concept <- list(concept)
  d
}

parse_attributes <- function(nodes, lang = "nl"){
  id <- nodes |> xml_attr("id")
  assignmentStatus <- nodes |> xml_attr("assignmentStatus")

  concept <- nodes |>
    xml_find_first("s:ConceptIdentity/Ref", ns = ns_v2_1) |>
    xml_attrs() |>
    lapply(as.list) |>
    data.table::rbindlist(fill = TRUE)

  concept_ref <- paste(
    concept$agencyID,
    concept$maintainableParentID,
    concept$maintainableParentVersion,
    concept$id,
    sep = ","
  )

  enum <- nodes |>
    xml_find_first("s:LocalRepresentation/s:Enumeration/Ref", ns = ns_v2_1) |>
    xml_attrs() |>
    lapply(as.list) |>
    data.table::rbindlist(fill = TRUE)

  cl_ref <- with(enum, paste(agencyID, id, version, sep = ","))

  dim_ref <- nodes |>
    xml2::xml_find_first("s:AttributeRelationship/s:Dimension/Ref", ns = ns_v2_1) |>
    xml2::xml_attr("id")


  d <- data.frame(
    id = id,
    assignmentStatus = assignmentStatus,
    concept_ref = concept_ref,
    cl_ref = cl_ref,
    dim_ref = dim_ref
  )

  d
}

parse_measures <- function(nodes, lang = "nl"){
  id <- nodes |> xml_attr("id")

  concept <- nodes |>
    xml_find_first("s:ConceptIdentity/Ref", ns = ns_v2_1) |>
    xml_attrs() |>
    lapply(as.list) |>
    data.table::rbindlist(fill = TRUE)

  concept_ref <- paste(
    concept$agencyID,
    concept$maintainableParentID,
    concept$maintainableParentVersion,
    concept$id,
    sep = ","
  )

  textformat <- nodes |>
    xml_find_first("s:LocalRepresentation/s:TextFormat", ns = ns_v2_1) |>
    xml_attr("textType")

  d <- data.frame(
    id = id,
    concept_ref = concept_ref,
    textformat = textformat
  )

  d
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

  code_description <- codes |>
    xml_find_first(
      "c:Description[@xml:lang='%s']" |> sprintf(lang),
      ns = ns_v2_1
    ) |>
    xml_text()

  code_parent_id <- codes |> xml_find_first("s:Parent/Ref", ns = ns_v2_1) |> xml_attr("id")

  code_df <- data.frame(
    id = code_id,
    name = code_name,
    description = code_description,
    parent_id = code_parent_id
  )

  l <- data.frame(
    id = id,
    agencyID = agencyID,
    version = version,
    ref = ref,
    name = name
  )

  l$codes <- list(code_df)

  l[[sprintf("name_%s", lang)]] <- name

  l
}
