W <- 8.3
H <- 11.7

for(i in 1:2){
  
  if(i == 1){
    grDevices::png(file = "R-Book-Cover.png",
                   width = W,
                   height = H,
                   units = "in",
                   res = 300)
  } else {
    grDevices::pdf(file = "R-Book-Cover.pdf",
                   width = W,
                   height = H)
  }
  par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0), bg = "black")
  plot(1, type = "n", xlab = "", ylab = "", xlim = c(0,W), ylim = c(0,H))
  
  # background image
  source("cover-image.R")
  
  # author name
  text(x = W, y = H - 0.5, labels = "Arthur de Sá Ferreira", pos = 2, cex = 2, col = "white")
  
  # book title
  text(x = W, y = H/2 + 2.0, labels = substitute(paste(bold("Ciência com R"))), pos = 2, cex = 5, col = "white")

  # book subtitle
  text(x = W, y = H/2 + 1.25, labels = substitute(paste(italic("Perguntas e respostas para pesquisadores e analistas de dados"))), pos = 2, cex = 1.5, col = "white")
  
  # year
  text(x = W/2, y = -0.2, labels = format(Sys.Date(), "%Y"), adj = c(0,0), cex = 1, col = "white")
  
  dev.off()
}
