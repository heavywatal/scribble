# install.package("png")

grob_png = function(file) {
  grid::rasterGrob(png::readPNG(file))
}
