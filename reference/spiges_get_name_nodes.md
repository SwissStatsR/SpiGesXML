# Get node names available for data extraction of a SpiGes XML

Return main and children node names of an SpiGes XML. The node names
"Unternehmen", "Standort", "Fall", "Kantonsdaten" are removed as the
function spiges_get_df() doesn't provide support to extract their
related data.

## Usage

``` r
spiges_get_name_nodes(x)
```

## Arguments

- x:

  A string, a connection, or a raw vector. See
  [`xml2::read_xml`](http://xml2.r-lib.org/reference/read_xml.md)

## Value

vector of node names
