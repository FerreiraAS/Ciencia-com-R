URL.site <- "https://sciencer.shinyapps.io/RCTapp/"
file.png <- "images/RCTapp.png"

screen_width <- 1920
screen_height <- 1080

# function to vget screenshot
library("chromote")
screenshot <- function(b, img_path,
                       selector = "html",
                       cliprect = c(top = 0, left = 0, width = screen_width, height = screen_height),
                       expand = NULL) {
  
  b$screenshot(
    img_path,
    selector = selector,
    delay = 15,
    cliprect = cliprect,
    expand = expand
  )
  
  magick::image_read(img_path) |>
    magick::image_shadow() |>
    magick::image_write(img_path, quality = 100)
}

# get URL screenshot
a <- ChromoteSession$new(height = screen_height, width = screen_width)
invisible(a$Page$navigate(URL.site))
Sys.sleep(1)
screenshot(a, file.png)

if(!exists(file.png)) {
  # show image
  img <- magick::image_read(file.png)
  # zero margins
  par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0))
  plot(img)
}
