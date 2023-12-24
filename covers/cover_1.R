W <- 8.27
H <- 11.69

grDevices::png(
  file = "images/Cover_1.png",
  width = W,
  height = H,
  units = "in",
  res = 300
)
par(
  mar = c(0, 0, 0, 0),
  oma = c(0, 0, 0, 0),
  omi = c(0, 0, 0, 0),
  mai = c(0, 0, 0, 0),
  bg = "black"
)
plot(
  1,
  type = "n",
  xlab = "",
  ylab = "",
  xlim = c(0, W),
  ylim = c(0, H)
)

# background image
rmd.files <-
  list.files(file.path(getwd(), "rmd"), ".Rmd", full.names = TRUE)
phrases <- c()
for (i in 1:length(rmd.files)) {
  content <- readLines(rmd.files[i])
  lines <- stringr::str_extract(content, "^\\### \\**")
  select.lines <- content[!is.na(lines)]
  clean.lines <- gsub("\\### \\**", "", select.lines)
  clean.lines <- gsub(" $\\*", "", clean.lines)
  phrases <- c(phrases, clean.lines)
}
phrases <- phrases[!duplicated(phrases)]
texto <- paste0(phrases, collapse = " ")
rectangleWidth <- W + 2 # to simulate a text justified
s <- texto
n <- nchar(s)
for (i in n:1) {
  wrappeds <- paste0(strwrap(s, i), collapse = "\n")
  if (strwidth(wrappeds) < rectangleWidth)
    break
}
#  wrappeds <- paste(wrappeds, wrappeds)
textHeight <- strheight(wrappeds)
text(W / 2, H / 2, labels = wrappeds, col = "gray25")

# author name
text(
  x = W,
  y = H - 0.5,
  labels = substitute(paste(bold(
    "Arthur de Sá Ferreira"
  ))),
  pos = 2,
  cex = 2,
  col = "white"
)

# book title
text(
  x = W,
  y = H / 2 + 2 - 1,
  labels = substitute(paste(bold("Ciência com   "))),
  pos = 2,
  cex = 6.5,
  col = "yellow"
)
text(
  x = W,
  y = H / 2 + 2 - 1,
  labels = substitute(paste(bold("R"))),
  pos = 2,
  cex = 6.5,
  col = "#3363B0"
)

# book subtitle
text(
  x = W,
  y = H / 2 + 3 - 2.75,
  labels = substitute(paste(
    italic("Perguntas e respostas para pesquisadores e analistas de dados")
  )),
  pos = 2,
  cex = 1.5,
  col = "white"
)

# year
text(
  x = W / 2,
  y = 0,
  labels = format(Sys.Date(), "%Y"),
  adj = c(0.5, 0.5),
  cex = 1.5,
  col = "white"
)

grDevices::dev.off()

# save PDF
grDevices::pdf(file = "covers/Cover_1.pdf",
               width = W,
               height = H)
img <- png::readPNG("images/Cover_1.png")
img <- grDevices::as.raster(img[, , 1:3])
par(
  mar = c(0, 0, 0, 0),
  oma = c(0, 0, 0, 0),
  omi = c(0, 0, 0, 0),
  mai = c(0, 0, 0, 0),
  bg = "black"
)
plot(img)
grDevices::dev.off()