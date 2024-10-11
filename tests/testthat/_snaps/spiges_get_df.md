# spiges_get_df() returns error properly [plain]

    Code
      spiges_get_df(x = system.file("example_incorrect_format.xml", package = "SpiGesXML"),
      node = "Administratives")
    Message <cliMessage>
      x Incorrect format  using spiges-data v.1.4.
      
      Element '{http://www.bfs.admin.ch/xmlns/gvs/spiges-data/1.4}Standort', attribute 'burnr': 'INCORRECT VALUE' is not a valid value of the local atomic type.

# spiges_get_df() returns error properly [ansi]

    Code
      spiges_get_df(x = system.file("example_incorrect_format.xml", package = "SpiGesXML"),
      node = "Administratives")
    Message <cliMessage>
      [31mx[39m Incorrect format  using spiges-data v.1.4.
      
      Element '{http://www.bfs.admin.ch/xmlns/gvs/spiges-data/1.4}Standort', attribute 'burnr': 'INCORRECT VALUE' is not a valid value of the local atomic type.

# spiges_get_df() returns error properly [unicode]

    Code
      spiges_get_df(x = system.file("example_incorrect_format.xml", package = "SpiGesXML"),
      node = "Administratives")
    Message <cliMessage>
      ✖ Incorrect format  using spiges-data v.1.4.
      
      Element '{http://www.bfs.admin.ch/xmlns/gvs/spiges-data/1.4}Standort', attribute 'burnr': 'INCORRECT VALUE' is not a valid value of the local atomic type.

# spiges_get_df() returns error properly [fancy]

    Code
      spiges_get_df(x = system.file("example_incorrect_format.xml", package = "SpiGesXML"),
      node = "Administratives")
    Message <cliMessage>
      [31m✖[39m Incorrect format  using spiges-data v.1.4.
      
      Element '{http://www.bfs.admin.ch/xmlns/gvs/spiges-data/1.4}Standort', attribute 'burnr': 'INCORRECT VALUE' is not a valid value of the local atomic type.

