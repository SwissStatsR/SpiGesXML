#' Get SpiGes node as dataframe
#'
#' Return a tibble/dataframe of a SpiGes node name. By default, all variables
#' are returned. Variables can be selected using the `variables` argument.
#'
#' @param x A string, a connection, or a raw vector. See \code{xml2::read_xml}
#' @param node Name of the node as string, see \code{get_node_names}
#' @param variables Name of the variables, by default returns all variables
#' @param schema_xsd URL of an XSD schema version, by default "latest" version.
#' @param force default FALSE. If TRUE, returns data even if validation error.
#' @importFrom xml2 read_xml xml_ns_rename xml_find_all xml_attr xml_parent xml_find_first xml_validate
#' @importFrom dplyr as_tibble bind_cols
#' @importFrom purrr map_dfc set_names
#' @importFrom cli cli_alert_success cli_alert_danger cli_abort
#' @return data.frame/tibble
#' @export
spiges_get_df <- function(x, node, variables = NULL, schema_xsd = "latest", force = FALSE) {
  # validate the XML format based on node selection
  schema_xml <- if(node != "Personenidentifikatoren") {
    if(schema_xsd == "latest") {
      "https://dam-api.bfs.admin.ch/hub/api/dam/assets/32129176/master"
    } else {
      schema_xsd
    }
  } else if(node == "Personenidentifikatoren") {
    if(schema_xsd == "latest") {
      "https://dam-api.bfs.admin.ch/hub/api/dam/assets/32129184/master"
    } else {
      schema_xsd
    }
  }

  # Condition for "Kostentraeger" related node variables
  if(node == "Kostentraeger") {
    cli::cli_abort("To get data for 'Kostentraeger' node, use instead 'KostentraegerUnternehmen', 'KostentraegerStandort', or 'KostentraegerFall'")
  }
  if(node %in% c("KostentraegerUnternehmen", "KostentraegerStandort", "KostentraegerFall")) {
    nodes_available <- c(
      names(spiges_get_name_variables(schema_xml)),
      # hard-coded as possible node names which don't exist in the XSD schema file
      # Note that "Kostentraeger" is used in the definition file for the three nodes below:
      "KostentraegerUnternehmen", "KostentraegerStandort", "KostentraegerFall"
    )
  } else {
    nodes_available <- c(names(spiges_get_name_variables(schema_xml)))
  }

  node <- rlang::arg_match(
    arg = node,
    values = nodes_available
  )
  xml <- xml2::read_xml(x)
  ns <- xml2::xml_ns_rename(xml2::xml_ns(xml), d1 = "spiges", xsi = "xsi")
  nodeset <- xml2::xml_find_all(x = xml, xpath = paste0("//spiges:", node), ns = ns)

  schema_file <- xml2::read_xml(schema_xml)
  schema_xmlns <- xml2::xml_attr(schema_file, attr = "xmlns")
  schema_type <- basename(dirname(schema_xmlns))
  schema_version <- basename(schema_xmlns)

  # validate input file
  validation_output <- xml2::xml_validate(xml, schema_file)

  if(validation_output) {
    cli::cli_alert_success("Format correctly validated using {schema_type} v.{schema_version}.")
  }
  if(isFALSE(validation_output)) {
    cli::cli_alert_danger("Incorrect format  using {schema_type} v.{schema_version}.\n\n{attributes(validation_output)$errors}")
    if (isFALSE(force)) {
      return(invisible(FALSE))
    }
  }

  # Return base dataframe based on node name without additional variables
  df_base <- if(node %in% c("Fallkosten", "Administratives", "Neugeborene", "Psychiatrie", "KostentraegerFall",
                            "Diagnose","Behandlung", "Medikament", "Rechnung", "Patientenbewegung", "Personenidentifikatoren")) {
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
  } else if(node %in% c("KostentraegerStandort")) {
    data.frame(
      ent_id = xml_attr(xml_find_first(xml_find_first(nodeset, "./parent::*"), "./parent::*"), "ent_id"),
      burnr = xml_attr(xml_find_first(nodeset, "./parent::*"), "burnr"))
  } else if(node %in% c("KostentraegerUnternehmen")) {
    data.frame(
      ent_id = xml_attr(xml_find_first(nodeset, "./parent::*"), "ent_id"))
  }

  # full list of variables based on node, using spiges_get_name_variables()
  # logic to extract Kostentraeger variable node:
  if(node %in% c("KostentraegerFall", "KostentraegerStandort", "KostentraegerUnternehmen")) {
    vars_all <- spiges_get_name_variables(schema_xsd = schema_xml)[["Kostentraeger"]]
  } else {
    vars_all <- spiges_get_name_variables(schema_xsd = schema_xml)[[node]]
  }

  # variable selection, if NULL get all variables
  vars <- if(is.null(variables)) {
    vars_all
  } else {
    rlang::arg_match(
      arg = variables,
      values = vars_all,
      multiple = TRUE
    )
  }
  # function to get attributes values of a given variable
  get_variable_values <- function(variable) {
    xml_attr(x = nodeset, attr = variable) |>
      as_tibble() |>
      purrr::set_names(variable)
  }
  df_variables <- purrr::map_dfc(.x = vars, .f = get_variable_values)
  if(nrow(df_variables) == 0) {
    cli::cli_alert_danger(paste0("No data for node '", node, "'."))
    return(df_variables)
  }
  # join variables to base dataframe
  df <- df_base |>
    bind_cols(df_variables) |>
    as_tibble()
  return(df)
}
