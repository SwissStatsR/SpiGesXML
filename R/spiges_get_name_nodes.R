#' Get node names available for data extraction of a SpiGes XML
#'
#' Return main and children node names of an SpiGes XML. The node names
#' "Unternehmen", "Standort", "Fall", "Kantonsdaten" are removed as the function
#' spiges_get_df() doesn't provide support to extract their related data.
#'
#' @param x A string, a connection, or a raw vector. See \code{xml2::read_xml}
#' @importFrom xml2 read_xml xml_ns xml_children xml_name
#' @return vector of node names
#' @export
spiges_get_name_nodes <- function(x) {
  xml <- xml2::read_xml(x)
  ns <- xml2::xml_ns(xml)
  nodes <- c(
    xml |>
      xml2::xml_name(ns) |>
      unique(),
    xml |>
      xml2::xml_children() |>
      xml2::xml_name(ns) |>
      unique(),
    xml |>
      xml2::xml_children() |>
      xml2::xml_children() |>
      xml2::xml_name(ns) |>
      unique(),
    xml |>
      xml2::xml_children() |>
      xml2::xml_children() |>
      xml2::xml_children() |>
      xml2::xml_name(ns) |>
      unique()
  )
  nodes <- gsub("^d1:", "", nodes)
  # remove specific nodes not extract by function spiges_get_df()
  nodes <- nodes[! nodes %in% c("Unternehmen", "Standort", "Fall", "Kantonsdaten")]
  return(nodes)
}
