W <- 8.27
H <- 11.69

for(i in 1:2){
  
  if(i == 1){
    grDevices::png(file = "images/Cover_2.png",
                   width = W,
                   height = H,
                   units = "in",
                   res = 300)
  } else {
    grDevices::pdf(file = "covers/Cover_2.pdf",
                   width = W,
                   height = H)
  }
  par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0), omi = c(0, 0, 0, 0), mai = c(0, 0, 0, 0), bg = "white")
  plot(1, type = "n", xlab = "", ylab = "", xlim = c(0,W), ylim = c(0,H))
  
  # author name
  text(x = W, y = H - 0.5, labels = substitute(paste(bold("Arthur de Sá Ferreira"))), pos = 2, cex = 2, col = "black")
  
  # book title
  text(x = W, y = H/2 + 2 - 1, labels = substitute(paste(bold("Ciência com   "))), pos = 2, cex = 6.5, col = "black")
  text(x = W, y = H/2 + 2 - 1, labels = substitute(paste(bold("R"))), pos = 2, cex = 6.5, col = "black")
  
  # book subtitle
  text(x = W, y = H/2 + 3 - 2.75, labels = substitute(paste(italic("Perguntas e respostas para pesquisadores e analistas de dados"))), pos = 2, cex = 1.5, col = "black")

  # year
  text(x = W/2, y = 0, labels = format(Sys.Date(), "%Y"), adj = c(0,0), cex = 1.5, col = "black")
  
  grDevices::dev.off()
}
