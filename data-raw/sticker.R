library(hexSticker)
library(magick)
library(rsvg)

sticker_SpiGesXML <- sticker(
  subplot = "data-raw/medical-record-logo.svg",
  package = "SpiGesXML",
  h_fill = "firebrick",
  p_color = "white",
  u_size = 3.5,
  p_y = 0.65,
  p_size = 19,
  s_width = 0.45,
  h_size = 0,
  s_x = 1,
  s_y = 1.25,
  filename = "man/figures/logo.png")

logo <- magick::image_read("man/figures/logo.png")
magick::image_scale(logo, "400") |>
  magick::image_write(path = "data-raw/logo.png", format = "png")
