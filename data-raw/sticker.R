library(hexSticker)

sticker_SpiGesXML <- sticker(
  subplot = "https://upload.wikimedia.org/wikipedia/commons/d/db/Hospital_Edited.png",
  package = "SpiGesXML",
  h_fill = "firebrick",
  h_color = "black",
  p_color = "white",
  url = "github.com/SwissStatsR/SpiGesXML",
  u_color = "white",
  u_size = 3.5,
  p_y = 1.35,
  p_size = 20,
  s_width = 0.5,
  h_size = 1,
  s_x = 1,
  s_y = 0.77,
  filename = "man/figures/logo.png")

logo <- magick::image_read("man/figures/logo.png")
magick::image_scale(logo, "400") |>
  magick::image_write(path = "data-raw/logo.png", format = "png")
