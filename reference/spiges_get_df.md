# Get SpiGes node as dataframe

Return a tibble/dataframe of a SpiGes node name. By default, all
variables are returned. Variables can be selected using the
\`variables\` argument.

## Usage

``` r
spiges_get_df(x, node, variables = NULL, schema_xsd = "latest", force = FALSE)
```

## Arguments

- x:

  A string, a connection, or a raw vector. See
  [`xml2::read_xml`](http://xml2.r-lib.org/reference/read_xml.md)

- node:

  Name of the node as string, see `get_node_names`

- variables:

  Name of the variables, by default returns all variables

- schema_xsd:

  URL of an XSD schema version, by default "latest" version.

- force:

  default FALSE. If TRUE, returns data even if validation error.

## Value

data.frame/tibble
