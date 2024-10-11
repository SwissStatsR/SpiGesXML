
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SpiGesXML <img src="man/figures/logo.png" align="right" height="138" />

<!-- badges: start -->

[![swissstatsr
badge](https://swissstatsr.r-universe.dev/badges/:name)](https://swissstatsr.r-universe.dev/)
[![SpiGesXML status
badge](https://swissstatsr.r-universe.dev/badges/SpiGesXML)](https://swissstatsr.r-universe.dev/SpiGesXML)
[![R-CMD-check](https://github.com/SwissStatsR/SpiGesXML/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/SwissStatsR/SpiGesXML/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

Extract data from [SpiGes XML
files](https://www.bfs.admin.ch/asset/de/32129188) using R programming.

## Installation

``` r
# install from the r-universe
install.packages("SpiGesXML", repos = "https://swissstatsr.r-universe.dev")
```

``` r
# install from GitHub
remotes::install_github("SwissStatsR/SpiGesXML")
```

## Examples

Using `spiges_get_df()`, you can get the data from any SpiGes XML file
using the `x` argument. The `x` argument can be an URL or the path of a
give XML file.

``` r
library(SpiGesXML)

# SpiGes XML file example 
# https://www.bfs.admin.ch/bfs/de/home/statistiken/gesundheit/gesundheitswesen/projekt-spiges.assetdetail.27905035.html
xml_example <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/32129227/master"

spiges_get_df(x = xml_example, node = "Administratives")
```

    ## ✔ Format correctly validated using spiges-data v.1.4.

    ## # A tibble: 13 × 34
    ##    ent_id    burnr fall_id burnr…¹ abc_f…² gesch…³ alter alter…⁴ wohno…⁵ wohnk…⁶
    ##    <chr>     <chr> <chr>   <chr>   <chr>   <chr>   <chr> <chr>   <chr>   <chr>  
    ##  1 100000012 1000… 1       712978… A       2       97    <NA>    GE03    GE     
    ##  2 100000012 1000… 2       712879… A       1       49    <NA>    AG52    AG     
    ##  3 100000012 1000… 3       712934… A       2       101   <NA>    BE76    BE     
    ##  4 100000012 1000… 4       712879… A       1       62    <NA>    AG52    AG     
    ##  5 100000012 1000… 5       712879… A       2       61    <NA>    AG52    AG     
    ##  6 100000012 1000… 6       712978… A       2       84    <NA>    VD39    VD     
    ##  7 100000012 1000… 7       712879… A       1       75    <NA>    BE48    BE     
    ##  8 100000012 1000… 8       711791… A       2       91    <NA>    BE52    BE     
    ##  9 100000012 1000… 9       712879… A       1       65    <NA>    BE48    BE     
    ## 10 100000012 1000… 10      712934… A       2       105   <NA>    ZH29    ZH     
    ## 11 100000012 1000… 11      711791… A       1       67    <NA>    ZH23    ZH     
    ## 12 100000012 1000… 12      712934… A       1       55    <NA>    BS09    BS     
    ## 13 100000012 1000… 13      712879… A       2       67    <NA>    TI30    TI     
    ## # … with 24 more variables: wohnland <chr>, nationalitaet <chr>,
    ## #   eintrittsdatum <chr>, eintritt_aufenthalt <chr>, eintrittsart <chr>,
    ## #   einw_instanz <chr>, liegeklasse <chr>, versicherungsklasse <chr>,
    ## #   admin_urlaub <chr>, chlz <chr>, aufenthalt_ips <chr>, beatmung <chr>,
    ## #   schwere_score <chr>, art_score <chr>, nems <chr>, aufenthalt_imc <chr>,
    ## #   aufwand_imc <chr>, hauptleistungsstelle <chr>, grundversicherung <chr>,
    ## #   tarif <chr>, austrittsdatum <chr>, austrittsentscheid <chr>, …

If for some reasons there is no data for a given node, `spiges_get_df()`
will return an error with suggestions of existing nodes in the SpiGes
file.

``` r
spiges_get_df(x = xml_example, node = "Admin")
```

    Error in `spiges_get_df()`:
    ! `node` must be one of "Administratives", "Diagnose", "KostentraegerFall", "Behandlung", or "Rechnung", not "Admin".
    ℹ Did you mean "Administratives"?

The `spiges_get_df()` function validate internally the XML file. If
correctly validated, it returns the data with a success message in the
console. If the validation is incorrect, only an error message is
returned. To return the data even with an incorrect validation, you can
add use the `force` argument as `TRUE`.

Here an example of an incorrect format with an “INCORRECT VALUE” for
“burnr”:

``` r
xml_file_incorrect <- system.file(
  "example_incorrect_format.xml", 
  package = "SpiGesXML"
)

library(xml2) # install.packages("xml2")

# for example burnr="INCORRECT VALUE"
xml2::read_xml(xml_file_incorrect)
```

    ## {xml_document}
    ## <Unternehmen ent_id="100000012" version="1.4" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://www.bfs.admin.ch/xmlns/gvs/spiges-data/1.4">
    ## [1] <Standort burnr="INCORRECT VALUE">\n  <Fall fall_id="1">\n    <Administra ...

If you use this incorrect XML file, `spiges_get_df()` will return an
error message (but the function can return the data anyway using
`force = TRUE`):

``` r
spiges_get_df(
  x = xml_file_incorrect,
  node = "Administratives",
  force = FALSE # TO RETURN DATA, USE "TRUE"
)
```

    ## ✖ Incorrect format  using spiges-data v.1.4.
    ## 
    ## Element '{http://www.bfs.admin.ch/xmlns/gvs/spiges-data/1.4}Standort', attribute 'burnr': 'INCORRECT VALUE' is not a valid value of the local atomic type.

Variables can be individually selected using the `variables` argument:

``` r
spiges_get_df(x = xml_example, node = "Administratives", variables = c("abc_fall", "geschlecht"))
```

    ## ✔ Format correctly validated using spiges-data v.1.4.

    ## # A tibble: 13 × 5
    ##    ent_id    burnr    fall_id abc_fall geschlecht
    ##    <chr>     <chr>    <chr>   <chr>    <chr>     
    ##  1 100000012 10000012 1       A        2         
    ##  2 100000012 10000012 2       A        1         
    ##  3 100000012 10000012 3       A        2         
    ##  4 100000012 10000012 4       A        1         
    ##  5 100000012 10000012 5       A        2         
    ##  6 100000012 10000012 6       A        2         
    ##  7 100000012 10000012 7       A        1         
    ##  8 100000012 10000012 8       A        2         
    ##  9 100000012 10000012 9       A        1         
    ## 10 100000012 10000012 10      A        2         
    ## 11 100000012 10000012 11      A        1         
    ## 12 100000012 10000012 12      A        1         
    ## 13 100000012 10000012 13      A        2

If the variable name in `variables` doesn’t exist in the file, will
return an error message. When multiple variable names are provided, only
correct variable names will be returned (with no error messages if a
variable name is correct).

``` r
spiges_get_df(x = xml_example, node = "Administratives", variables = "Geschlecht")
```

    Error in `spiges_get_df()`:
    ! `variables` must be one of "burnr_gesv", "abc_fall", "geschlecht", "alter", "alter_U1", "wohnort_medstat", "wohnkanton",
      "wohnland", "nationalitaet", "eintrittsdatum", "eintritt_aufenthalt", "eintrittsart", "einw_instanz", "liegeklasse",
      "versicherungsklasse", "admin_urlaub", "chlz", "aufenthalt_ips", "beatmung", "schwere_score", "art_score", "nems", "aufenthalt_imc",
      "aufwand_imc", "hauptleistungsstelle", "grundversicherung", "tarif", "austrittsdatum", "austrittsentscheid", "austritt_aufenthalt", or
      "austritt_behandlung", not "Geschlecht".
    ℹ Did you mean "geschlecht"?

## Get IDs data

You can also access “Personenidentifikatoren” data using
`spiges_get_df()`. Under the hood the function is using the `spiges-ids`
format validation (while other available nodes are using the
`spiges-data` validation format).

``` r
id_example <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/32129180/master"

spiges_get_df(x = id_example, node = "Personenidentifikatoren")
```

    ## ✔ Format correctly validated using spiges-ids v.1.4.

    ## # A tibble: 2 × 5
    ##   ent_id    burnr    fall_id ahv           geburtsdatum
    ##   <chr>     <chr>    <chr>   <chr>         <chr>       
    ## 1 845724581 71548624 5443546 7561234567897 20220412    
    ## 2 845724581 71548624 5443547 7561111111119 19850117

## Change format validation version

You can change the version of the XSD schema validation using the
`schema_xsd` argument (by default “latest”). Note that you might
encounter issues with custom schema validation as **SpigGesXML** aims to
work with the latest schema version available.

Here an example for schema version “1.3”:

``` r
# SpiGes format version 1.3 
spiges_get_df(
  x = "https://dam-api.bfs.admin.ch/hub/api/dam/assets/27905035/master", 
  node = "Diagnose",
  schema_xsd = "https://dam-api.bfs.admin.ch/hub/api/dam/assets/27905037/master"
)
```

    ## ✔ Format correctly validated using spiges-data v.1.3.

    ## # A tibble: 2 × 8
    ##   ent_id    burnr    fall_id diagnose_id diagnose_kode diagnos…¹ diagn…² diagn…³
    ##   <chr>     <chr>    <chr>   <chr>       <chr>         <chr>     <chr>   <chr>  
    ## 1 845724581 71548624 5443546 1           Z380          <NA>      <NA>    <NA>   
    ## 2 845724581 71548624 5443547 1           F29           <NA>      1       <NA>   
    ## # … with abbreviated variable names ¹​diagnose_seitigkeit, ²​diagnose_poa,
    ## #   ³​diagnose_zusatz

Here another example of version 1.3 for “Personenidentifikatoren” node:

``` r
spiges_get_df(
    x = "https://dam-api.bfs.admin.ch/hub/api/dam/assets/27905038/master", 
    node = "Personenidentifikatoren",
    schema_xsd = "https://dam-api.bfs.admin.ch/hub/api/dam/assets/27905036/master"
)
```

    ## ✔ Format correctly validated using spiges-ids v.1.3.

    ## # A tibble: 2 × 5
    ##   ent_id    burnr    fall_id ahv           geburtsdatum
    ##   <chr>     <chr>    <chr>   <chr>         <chr>       
    ## 1 845724581 71548624 5443546 7561234567897 20220412    
    ## 2 845724581 71548624 5443547 7561111111119 19850117

## Get available node names

Show node names available for data extraction in XML SpiGes:

``` r
spiges_get_name_nodes(x = xml_example)
```

    ## [1] "Administratives"   "Diagnose"          "KostentraegerFall"
    ## [4] "Behandlung"        "Rechnung"

## Get available variable names

Get list of variable names available by SpiGes node names of any SpiGes
Schema XSD file:

``` r
spiges_get_name_variables(
  schema_xsd = "https://dam-api.bfs.admin.ch/hub/api/dam/assets/32129184/master"
) |>
  str()
```

    ## List of 4
    ##  $ Unternehmen            : chr [1:2] "ent_id" "version"
    ##  $ Standort               : chr "burnr"
    ##  $ Fall                   : chr "fall_id"
    ##  $ Personenidentifikatoren: chr [1:2] "ahv" "geburtsdatum"

## Notes

The following node names are not available for data extraction:
“Unternehmen”, “Standort”, “Fall” and “Kantonsdaten”.

## TODO

- Read-in the “Kantonsdaten” (on levels “Fall”, “Standort”,
  “Unternehmen”).
  - There are no specified attributes as each canton can set its own
    variables… Could be problematic for including it in the function.
