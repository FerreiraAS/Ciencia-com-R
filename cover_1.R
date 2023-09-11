W <- 8.3
H <- 11.7

for(i in 1:2){
  
  if(i == 1){
    grDevices::png(file = "Cover_1.png",
                   width = W,
                   height = H,
                   units = "in",
                   res = 300)
  } else {
    grDevices::pdf(file = "Cover_1.pdf",
                   width = W,
                   height = H)
  }
  par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0), bg = "black")
  plot(1, type = "n", xlab = "", ylab = "", xlim = c(0,W), ylim = c(0,H))
  
  # background image
  rmd.files <- list.files(getwd(), ".Rmd")
  phrases <- c()
  for(i in 1:length(rmd.files)){
    content <- readLines(rmd.files[i])
    lines <- stringr::str_extract(content, "^\\### \\**")
    select.lines <- content[!is.na(lines)]
    clean.lines <- gsub("\\### \\**", "", select.lines) 
    clean.lines <- gsub(" $\\*", "", clean.lines)
    phrases <- c(phrases, clean.lines)
  }
  phrases <- phrases[!duplicated(phrases)]
  texto <- paste0(phrases, collapse = " ")
  rectangleWidth <- W
  s <- texto
  n <- nchar(s)
  for(i in n:1) {
    wrappeds <- paste0(strwrap(s, i), collapse = "\n")
    if(strwidth(wrappeds) < rectangleWidth) break
  }
  textHeight <- strheight(wrappeds)
  text(W/2, H/2, labels = wrappeds, col = "gray25")
  
  # author name
  text(x = W, y = H - 0.5, labels = substitute(paste(bold("Arthur de Sá Ferreira"))), pos = 2, cex = 2, col = "white")
  
  # book title
  rect(xleft = 0,  ybottom = H/2 + 2.0 - 1, xright = W, ytop = H/2 + 2.0 + 1, col = "black")
  text(x = W, y = H/2 + 2.0, labels = substitute(paste(bold("Ciência com R"))), pos = 2, cex = 5, col = "yellow")
  text(x = W, y = H/2 + 2.0, labels = substitute(paste(bold("R"))), pos = 2, cex = 5, col = "#3363B0")
  
  # book subtitle
  text(x = W, y = H/2 + 1.25, labels = substitute(paste(italic("Perguntas e respostas para pesquisadores e analistas de dados"))), pos = 2, cex = 1.5, col = "white")
  text(x = W, y = H/2 + 1.25, labels = substitute(paste(italic("pesquisadores e analistas de dados"))), pos = 2, cex = 1.5, col = "#3363B0")
  
  # year
  text(x = W/2, y = -0.2, labels = format(Sys.Date(), "%Y"), adj = c(0,0), cex = 1, col = "white")
  
  dev.off()
}
