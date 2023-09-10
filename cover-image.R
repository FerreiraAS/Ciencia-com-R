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

rect(-1, -0.2 + 0.5, rectangleWidth + 1, textHeight + 0.2 + 0.5, col = "#5ABFBF", lwd = NA)     
text(W/2, H/3.5 + 1.0, wrappeds, col = "black")
