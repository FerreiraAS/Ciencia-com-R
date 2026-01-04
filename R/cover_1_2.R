W <- 8.27
H <- 11.69

par(
  mar  = c(0, 0, 0, 0),
  oma  = c(0, 0, 0, 0),
  mai  = c(0, 0, 0, 0),
  xaxs = "i",
  yaxs = "i",
  bg   = "black"  # or bg
)

# ---------- TEXT EXTRACTION ----------
rmd.files <- list.files("rmd", "\\.Rmd$", full.names = TRUE)

phrases <- unique(unlist(lapply(rmd.files, function(f) {
  lines <- readLines(f, warn = FALSE)
  sel <- grep("^### \\**", lines)
  if (!length(sel)) return(NULL)
  x <- sub("^### \\**", "", lines[sel])
  sub(" \\*$", "", x)
})))

texto <- paste(phrases, collapse = " ")

# ---------- FAST WRAPPING (BINARY SEARCH) ----------
wrap_text <- function(s, max_width, min_chars = 10) {
  lo <- min_chars
  hi <- nchar(s)
  best <- lo
  
  while (lo <= hi) {
    mid <- (lo + hi) %/% 2
    wrapped <- paste(strwrap(s, mid), collapse = "\n")
    
    if (strwidth(wrapped) <= max_width) {
      best <- mid
      lo <- mid + 1
    } else {
      hi <- mid - 1
    }
  }
  
  paste(strwrap(s, best), collapse = "\n")
}

# ---- OPEN TEMP DEVICE FOR METRICS ----
pdf(NULL)
plot.new()
wrappeds <- wrap_text(texto, W + 2)
dev.off()

# ---------- COVER 1 ----------
draw_cover_1 <- function() {
  
  par(
    mar  = c(0, 0, 0, 0),
    oma  = c(0, 0, 0, 0),
    mai  = c(0, 0, 0, 0),
    xaxs = "i",
    yaxs = "i",
    bg   = "black"
  )
  
  plot.new()
  plot.window(xlim = c(0, W), ylim = c(0, H))
  
  lines <- strsplit(wrappeds, "\n")[[1]]
  n_lines <- length(lines)
  line_height <- H / n_lines
  
  y_positions <- seq(
    from = H - line_height / 2,
    to   = line_height / 2,
    length.out = n_lines
  )
  
  for (i in seq_along(lines)) {
    text(W / 2, y_positions[i], lines[i], col = "gray25")
  }
  
  text(W * 0.95, H - 1,
       substitute(bold("Arthur de Sá Ferreira")),
       pos = 2, offset = 0, cex = 2, col = "white")
  
  text(W * 0.95, H / 2 + 1,
       substitute(bold("Ciência com   ")),
       pos = 2, offset = 0, cex = 6.5, col = "yellow")
  
  text(W * 0.95, H / 2 + 1,
       substitute(bold("R")),
       pos = 2, offset = 0, cex = 6.5, col = "#3363B0")
  
  text(W * 0.95, H / 2 + 0.25,
       substitute(italic("Perguntas e respostas para pesquisadores e analistas de dados")),
       pos = 2, offset = 0, cex = 1.5, col = "white")
  
  text(W / 2, 0.5,
       format(Sys.Date(), "%Y"),
       pos = 1, offset = 0, cex = 1.5, col = "white")
}

png("images/Cover_1.png", width = W, height = H, units = "in", res = 300)
draw_cover_1()
dev.off()

pdf("covers/Cover_1.pdf", width = W, height = H)
draw_cover_1()
dev.off()

# ---------- COVER 2 ----------
draw_cover_2 <- function(bg = "white", col = "black") {
  
  par(
    mar  = c(0, 0, 0, 0),
    oma  = c(0, 0, 0, 0),
    mai  = c(0, 0, 0, 0),
    xaxs = "i",
    yaxs = "i",
    bg   = bg
  )
  
  plot.new()
  plot.window(xlim = c(0, W), ylim = c(0, H))
  
  text(W * 0.95, H - 1,
       substitute(bold("Arthur de Sá Ferreira")),
       pos = 2, offset = 0, cex = 2, col = col)
  
  text(W * 0.95, H / 2 + 1,
       substitute(bold("Ciência com   ")),
       pos = 2, offset = 0, cex = 6.5, col = col)
  
  text(W * 0.95, H / 2 + 1,
       substitute(bold("R")),
       pos = 2, offset = 0, cex = 6.5, col = col)
  
  text(W * 0.95, H / 2 + 0.25,
       substitute(italic(
         "Perguntas e respostas para pesquisadores e analistas de dados"
       )),
       pos = 2, offset = 0, cex = 1.5, col = col)
  
  text(W / 2, 0.5,
       format(Sys.Date(), "%Y"),
       pos = 1, offset = 0, cex = 1.5, col = col)
}

png("images/Cover_2.png", width = W, height = H, units = "in", res = 300)
draw_cover_2()
dev.off()

pdf("covers/Cover_2.pdf", width = W, height = H)
draw_cover_2()
dev.off()
