#' Get SpiGes node as dataframe
#'
#' Return a tibble/dataframe of a SpiGes node name. By default, all variables
#' are returned. Variables can be selected using the `variables` argument.
#'
#' @param x A string, a connection, or a raw vector. See \code{xml2::read_xml}
#' @param node Name of the node as string, see \code{get_node_names}
#' @param variables Name of the variables, by default returns all variables
#' @importFrom xml2 read_xml xml_ns_rename xml_find_all xml_attr xml_parent xml_find_first
#' @importFrom dplyr as_tibble bind_cols
#' @importFrom purrr map_dfc set_names
#' @return data.frame/tibble
#' @export
spiges_get_df <- function(x, node, variables = NULL) {
  node <- match.arg(
    arg = node,
    choices = c("KostentraegerUnternehmen",
                "KostentraegerStandort", "Administratives", "Neugeborene",
                "KostentraegerFall", "Diagnose", "Behandlung", "Operierende",
                "Rechnung", "Medikament", "Patientenbewegung", "Psychiatrie",
                "Kantonsdaten")
  )
  xml <- xml2::read_xml(x)
  ns <- xml_ns_rename(xml_ns(xml), d1 = "spiges", xsi = "xsi")
  nodeset <- xml_find_all(x = xml, xpath = paste0("//spiges:", node), ns = ns)

  # Return base dataframe based on node name without additional variables
  df_base <- if(node %in% c("Fallkosten", "Administratives", "Neugeborene", "Psychiatrie", "KostentraegerFall",
                            "Diagnose","Behandlung", "Medikament", "Rechnung", "Patientenbewegung")) {
    data.frame(
      ent_id = xml_attr(xml_find_first(xml_find_first(xml_find_first(nodeset, "./parent::*"), "./parent::*"), "./parent::*"), "ent_id"),
      burnr = xml_attr(xml_find_first(xml_find_first(nodeset, "./parent::*"), "./parent::*"), "burnr"),
      fall_id = xml_attr(xml_find_first(nodeset, "./parent::*"), "fall_id"))
  } else if(node %in% c("Operierende")) {
    data.frame(
      ent_id = xml_attr(xml_find_first(xml_find_first(xml_find_first(xml_find_first(nodeset,"./parent::*"),"./parent::*"),"./parent::*"),"./parent::*"),"ent_id"),
      burnr = xml_attr(xml_find_first(xml_find_first(xml_find_first(nodeset,"./parent::*"),"./parent::*"),"./parent::*"),"burnr"),
      fall_id = xml_attr(xml_find_first(xml_find_first(nodeset,"./parent::*"),"./parent::*"),"fall_id"),
      behandlung_id = xml_attr(xml_find_first(nodeset, "./parent::*"), "behandlung_id"))
  }  else if(node %in% c("KostentraegerStandort")) {
    data.frame(
      ent_id = xml_attr(xml_find_first(xml_find_first(nodeset, "./parent::*"), "./parent::*"), "ent_id"),
      burnr = xml_attr(xml_find_first(nodeset, "./parent::*"), "burnr"))
  } else if(node %in% c("KostentraegerUnternehmen")) {
    data.frame(
      ent_id = xml_attr(xml_find_first(nodeset, "./parent::*"), "ent_id"))
  }
  # full list of variables based on node, using spiges_get_name_variables()
  vars_all <- spiges_get_name_variables()[[node]]
  # variable selection, if NULL get all variables
  vars <- if(is.null(variables)) {
    vars_all
  } else {
    variables
  }
  # function to get attributes values of a given variable
  get_variable_values <- function(variable) {
    xml_attr(x = nodeset, attr = variable) |>
      as_tibble() |>
      set_names(variable)
  }
  df_variables <- map_dfc(.x = vars, .f = get_variable_values)
  # join variables to base dataframe
  df <- df_base |>
    bind_cols(df_variables) |>
    as_tibble()
  return(df)
}
