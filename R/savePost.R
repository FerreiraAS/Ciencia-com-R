SavePost <- function(entry, bib) {
  
  chapter  <- entry$chapter
  section  <- entry$section
  question <- entry$question
  answer   <- entry$answer
  key      <- entry$key
  
  # ---------- Executa bloco `r ----------
  if (grepl("`r", answer)) {
    code <- gsub(".*`r", "", answer)
    code <- gsub("`.*", "", code)
    
    code.eval <- tryCatch(
      eval(parse(text = code)),
      error = function(e) "[ERRO NO CÓDIGO R]"
    )
    
    answer <- gsub("`r.*`", as.character(code.eval), answer)
  }
  
  # ---------- Markdown → HTML ----------
  answer <- gsub("\\$", "$$", answer)
  answer <- markdown::markdownToHTML(answer, fragment.only = TRUE)
  answer <- gsub("\\$\\$", "$", answer)
  answer <- gsub("</?p>", "", answer)
  answer <- gsub("\n$", "", answer)
  
  # ---------- Ênfase ----------
  emphasis <- function(x) {
    x <- gsub("<em>", "\\\\textit{", x)
    x <- gsub("</em>", "}", x)
    x <- gsub("<strong>", "\\\\textbf{", x)
    x <- gsub("</strong>", "}", x)
    x
  }
  
  question <- emphasis(question)
  answer   <- emphasis(answer)
  
  # ---------- Citações ----------
  key <- unique(strsplit(key, "; ")[[1]])
  key <- key[key != ""]
  
  citations <- c()
  for (k in key) {
    src <- bib[k]
    if (is.null(src)) next
    cit <- format(src, style = "text")
    cit <- gsub("\\[\\d+\\]", "", cit)
    cit <- gsub("_", "", cit)
    cit <- gsub("<.*?>", "", cit)
    citations <- c(citations, cit)
  }
  
  citation_block <- if (length(citations) > 0) {
    paste0("[", seq_along(citations), "] ", citations,
           collapse = "\\\\newline")
  } else {
    ""
  }
  
  # ---------- Pastas ----------
  base <- file.path(getwd(), "posts", chapter, section)
  dir.create(base, recursive = TRUE, showWarnings = FALSE)
  
  n <- length(list.files(base, pattern = "\\.png$"))
  fname <- paste0(n + 1, "_", gsub("\\s+", "_", question), ".png")
  fpath <- file.path(base, fname)
  
  # ---------- TeX ----------
  tex <- readLines(file.path("tex", "POST.tex"))
  tex <- gsub("CAPITULO", chapter, tex)
  tex <- gsub("SECAO", section, tex)
  tex <- gsub("QUESTAO", question, tex)
  tex <- gsub("RESPOSTA", answer, tex)
  tex <- gsub("CITACAO", citation_block, tex)
  tex <- gsub("\\&", "\\\\&", tex)
  tex <- gsub("\\%", "\\\\%", tex)
  
  writeLines(tex, file.path("posts", "POST.tex"))
  
  ok <- tryCatch(
    tools::texi2pdf("posts/POST.tex", clean = TRUE),
    error = function(e) FALSE
  )
  
  if (!ok) return(invisible(NULL))
  
  file.rename("POST.pdf", "posts/POST.pdf")
  
  img <- pdftools::pdf_render_page("posts/POST.pdf", dpi = 300)
  png::writePNG(img, fpath)
  
  cover <- magick::image_read("images/Cover_1.png") |>
    magick::image_scale("400x400")
  
  final <- magick::image_composite(
    magick::image_read(fpath),
    cover,
    offset = "+1200+0"
  )
  
  magick::image_write(final, fpath, density = 300)
  
  file.remove("posts/POST.pdf", "posts/POST.tex")
}
