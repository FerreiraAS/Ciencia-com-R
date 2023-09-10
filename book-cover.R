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
  par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0), bg = "#0B508C")
  plot(1, type = "n", xlab = "", ylab = "", xlim = c(0,W), ylim = c(0,H))
  
  # author name
  text(x = W, y = H - 0.5, labels = "Arthur de Sá Ferreira", pos = 2, cex = 1.5, col = "white")
  
  # book title
  text(x = W, y = H/1.5 + 1.5, labels = "Ciência com R", pos = 2, cex = 4, col = "white")

  # book subtitle
  text(x = W, y = H/1.5 + 1.0, labels = substitute(paste(italic("Perguntas e respostas para pesquisadores e analistas de dados"))), pos = 2, cex = 1.5, col = "white")
  
  # author name
  text(x = W/2, y = H - H/1 - 0.1, labels = format(Sys.Date(), "%Y"), adj = c(0,0), cex = 1, col = "white")
  
  source("cover-image.R")
  dev.off()
}
