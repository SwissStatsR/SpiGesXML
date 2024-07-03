
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SpiGesXML

<!-- badges: start -->

[![swissstatsr
badge](https://swissstatsr.r-universe.dev/badges/:name)](https://swissstatsr.r-universe.dev/)
[![SpiGesXML status
badge](https://swissstatsr.r-universe.dev/badges/SpiGesXML)](https://swissstatsr.r-universe.dev/SpiGesXML)
[![R-CMD-check](https://github.com/SwissStatsR/SpiGesXML/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/SwissStatsR/SpiGesXML/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of SpiGesXML is to ease extraction of data from SpiGes XML
files.

## Installation

``` r
# install from the r-universe
install.packages("SpiGesXML", repos = "https://swissstatsr.r-universe.dev")
```

``` r
# install from GitHub
pak::pak("SwissStatsR/SpiGesXML")
```

## Examples

``` r
library(SpiGesXML)

# SpiGes XML file example 
# https://www.bfs.admin.ch/bfs/de/home/statistiken/gesundheit/gesundheitswesen/projekt-spiges.assetdetail.27905035.html
xml_example <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/32129227/master"

spiges_get_df(x = xml_example, node = "Administratives")
```

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

Variables can be individually selected using the `variables` argument:

``` r
spiges_get_df(x = xml_example, node = "Administratives", variables = c("abc_fall", "geschlecht"))
```

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

Show node names available for data extraction in XML SpiGes:

``` r
spiges_get_name_nodes(x = xml_example)
```

    ## [1] "Administratives"   "Diagnose"          "KostentraegerFall"
    ## [4] "Behandlung"        "Rechnung"

Get list of variable names available by SpiGes node names:

``` r
spiges_get_name_variables() |>
  str()
```

    ## List of 12
    ##  $ Administratives         : chr [1:31] "burnr_gesv" "abc_fall" "geschlecht" "alter" ...
    ##  $ Neugeborene             : chr [1:16] "geburtszeit" "vitalstatus" "mehrling" "geburtsrang" ...
    ##  $ Psychiatrie             : chr [1:31] "psy_zivilstand" "psy_eintritt_aufenthalt" "psy_eintritt_teilzeit" "psy_eintritt_vollzeit" ...
    ##  $ KostentraegerUnternehmen: chr [1:96] "ktr_typ" "ktr_beschr" "ktr_60" "ktr_61" ...
    ##  $ KostentraegerFall       : chr [1:96] "ktr_typ" "ktr_beschr" "ktr_60" "ktr_61" ...
    ##  $ Diagnose                : chr [1:5] "diagnose_id" "diagnose_kode" "diagnose_seitigkeit" "diagnose_poa" ...
    ##  $ Behandlung              : chr [1:6] "behandlung_id" "behandlung_chop" "behandlung_seitigkeit" "behandlung_beginn" ...
    ##  $ Operierende             : chr [1:3] "op_gln" "op_liste" "op_rolle"
    ##  $ Medikament              : chr [1:6] "medi_id" "medi_atc" "medi_zusatz" "medi_verabreichungsart" ...
    ##  $ Rechnung                : chr [1:11] "rech_id" "rech_kostentraeger" "rech_versicherer" "rech_unfallnr" ...
    ##  $ Patientenbewegung       : chr [1:7] "episode_id" "episode_beginn" "episode_ende" "episode_art" ...
    ##  $ KostentraegerStandort   : chr [1:96] "ktr_typ" "ktr_beschr" "ktr_60" "ktr_61" ...

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
