#' List of official variable names by node
#'
#' Return a list containing the list of the variables names for each SpiGes XML.
#' The names of the list are equivalent of the node names returned by
#'
#' Source file: \url{https://www.bfs.admin.ch/bfs/de/home/statistiken/gesundheit/gesundheitswesen/projekt-spiges.assetdetail.28127962.html}
#'
#' @param schema_xsd XSD schema file
#'
#' @importFrom stats na.omit
#'
#' @return a list of variable names
#' @export
spiges_get_name_variables <- function(schema_xsd) {
  schema_file <- xml2::read_xml(schema_xsd)

  # extract all namespaces from the xml-document
  ns_schema <- xml2::xml_ns(schema_file)

  varType <- xml2::xml_find_all(schema_file, "//xs:complexType", ns_schema)

  name_variables <- list()
  for (i in seq_along(varType)) {
    name_variables[[i]] <-  as.character(na.omit(xml2::xml_attr(xml2::xml_children(varType[[i]]), "name", ns_schema)))
  }

  type_names <- xml2::xml_attr(varType, "name", ns_schema)

  names(name_variables) <- gsub("Type$", "", type_names) # remove "Type" at end of string
  # "Adminstratives" miss spelling ("i" missing)
  names(name_variables) <- gsub("Adminstratives", "Administratives", names(name_variables))

  return(name_variables)
}
