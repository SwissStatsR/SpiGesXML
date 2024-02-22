
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SpiGesXML

<!-- badges: start -->
<!-- badges: end -->

The goal of SpiGesXML is to ease extraction of data from SpiGes XML
files.

## Installation

You can install the development version of SpiGesXML like so:

``` r
install.packages("SpiGesXML", repos = "https://swissstatsr.r-universe.dev")
```

## Examples

``` r
library(SpiGesXML)

# SpiGes XML file example 
# https://www.bfs.admin.ch/bfs/de/home/statistiken/gesundheit/gesundheitswesen/projekt-spiges.assetdetail.27905035.html
xml_example <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/27905035/master"

spiges_get_df(x = xml_example, node = "Administratives")
```

    ## # A tibble: 2 × 34
    ##   ent_id    burnr  fall_id burnr…¹ abc_f…² gesch…³ alter alter…⁴ wohno…⁵ wohnk…⁶
    ##   <chr>     <chr>  <chr>   <chr>   <chr>   <chr>   <chr> <chr>   <chr>   <chr>  
    ## 1 845724581 71548… 5443546 7584215 A       1       0     0       AG01    AG     
    ## 2 845724581 71548… 5443547 7584215 A       2       37    <NA>    <NA>    <NA>   
    ## # … with 24 more variables: wohnland <chr>, nationalitaet <chr>,
    ## #   eintrittsdatum <chr>, eintritt_aufenthalt <chr>, eintrittsart <chr>,
    ## #   einw_instanz <chr>, liegeklasse <chr>, versicherungsklasse <chr>,
    ## #   admin_urlaub <chr>, chlz <chr>, aufenthalt_ips <chr>, beatmung <chr>,
    ## #   schwere_score <chr>, art_score <chr>, nems <chr>, aufenthalt_imc <chr>,
    ## #   aufwand_imc <chr>, hauptleistungsstelle <chr>, grundversicherung <chr>,
    ## #   tarif <chr>, austrittsdatum <chr>, austrittsentscheid <chr>, …

Variables can be individually selected using the `variables` argument:

``` r
spiges_get_df(x = xml_example, node = "Administratives", variables = c("abc_fall", "geschlecht"))
```

    ## # A tibble: 2 × 5
    ##   ent_id    burnr    fall_id abc_fall geschlecht
    ##   <chr>     <chr>    <chr>   <chr>    <chr>     
    ## 1 845724581 71548624 5443546 A        1         
    ## 2 845724581 71548624 5443547 A        2

Show node names available for data extraction in XML SpiGes:

``` r
spiges_get_name_nodes(x = xml_example)
```

    ##  [1] "KostentraegerUnternehmen" "KostentraegerStandort"   
    ##  [3] "Administratives"          "Neugeborene"             
    ##  [5] "KostentraegerFall"        "Diagnose"                
    ##  [7] "Behandlung"               "Rechnung"                
    ##  [9] "Psychiatrie"              "Medikament"              
    ## [11] "Patientenbewegung"

Get list of variable names available by SpiGes node names:

``` r
spiges_get_name_variables() |>
  str()
```

    ## List of 12
    ##  $ Administratives         : chr [1:31] "burnr_gesv" "abc_fall" "geschlecht" "alter" ...
    ##  $ Neugeborene             : chr [1:16] "geburtszeit" "vitalstatus" "mehrling" "geburtsrang" ...
    ##  $ Psychiatrie             : chr [1:31] "psy_zivilstand" "psy_eintritt_aufenthalt" "psy_eintritt_teilzeit" "psy_eintritt_vollzeit" ...
    ##  $ KostentraegerUnternehmen: chr [1:95] "ktr_typ" "ktr_beschr" "ktr_60" "ktr_61" ...
    ##  $ KostentraegerFall       : chr [1:95] "ktr_typ" "ktr_beschr" "ktr_60" "ktr_61" ...
    ##  $ Diagnose                : chr [1:5] "diagnose_id" "diagnose_kode" "diagnose_seitigkeit" "diagnose_poa" ...
    ##  $ Behandlung              : chr [1:6] "behandlung_id" "behandlung_chop" "behandlung_seitigkeit" "behandlung_beginn" ...
    ##  $ Operierende             : chr [1:3] "op_gln" "op_liste" "op_rolle"
    ##  $ Medikament              : chr [1:6] "medi_id" "medi_atc" "medi_zusatz" "medi_verabreichungsart" ...
    ##  $ Rechnung                : chr [1:11] "rech_id" "rech_kostentraeger" "rech_versicherer" "rech_unfallnr" ...
    ##  $ Patientenbewegung       : chr [1:7] "episode_id" "episode_beginn" "episode_ende" "episode_art" ...
    ##  $ KostentraegerStandort   : chr [1:95] "ktr_typ" "ktr_beschr" "ktr_60" "ktr_61" ...

## Notes

The following node names are not available for data extraction:
“Unternehmen”, “Standort”, “Fall” and “Kantonsdaten”.

## TODO

- Read-in the “Kantonsdaten” (on levels “Fall”, “Standort”,
  “Unternehmen”).
  - There are no specified attributes as each canton can set its own
    variables… Could be problematic for including it in the function.
- Use the schema-File (“.xsd”) to identify the variables instead of
  hard-coding it.
