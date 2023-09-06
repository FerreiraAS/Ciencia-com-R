W <- 8.3
H <- 11.7

grDevices::png(file = "R-Book-Cover.png",
    width = W,
    height = H,
    units = "in",
    res = 300)

grDevices::pdf(file = "R-Book-Cover.pdf",
               width = W,
               height = H)

par(mar = c(0, 0, 0, 0), oma = c(0, 0, 0, 0))

plot(1, type = "n", xlab = "", ylab = "", xlim = c(0,W), ylim = c(0,H))

# author name
text(x = W, y = H - H/9, labels = "Arthur de Sá Ferreira", pos = 2, cex = 1.5)

# book title
text(x = W, y = H/2, labels = "Ciência com R", pos = 2, cex = 3)
lines(x = (W - 4):W, y = rep(H/2 - 0.5, 5), lwd = 4)

# author name
text(x = W/2, y = H - H/1, labels = format(Sys.Date(), "%Y"), adj = c(0,0), cex = 1)

dev.off()