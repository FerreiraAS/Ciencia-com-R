SavePost_df <- function(entry, bib) {
  
  # ---------- Mapping from df ----------
  chapter    <- entry$chapter
  section    <- entry$section
  question   <- entry$subsection
  answer     <- entry$item
  key        <- entry$references
  
  escape_latex <- function(x) {
    x <- gsub("\\\\", "\\\\textbackslash{}", x)
    x <- gsub("([#$%&_{}])", "\\\\\\1", x)
    x
  }
  
  # ---------- Executa bloco `r ----------
  if (!is.na(answer) && grepl("`r", answer)) {
    code <- gsub(".*`r", "", answer)
    code <- gsub("`.*", "", code)
    
    code.eval <- tryCatch(
      eval(parse(text = code)),
      error = function(e) "[ERRO NO CÓDIGO R]"
    )
    
    answer <- gsub("`r.*`", as.character(code.eval), answer)
  }
  
  # Remove TODOS os citeproc (1 ou vários)
  answer <- gsub(
    "\\\\citeproc\\{[^}]*\\}\\{[^}]*\\}",
    "",
    answer
  )
  
  # Remove o textsuperscript agora vazio ou só com vírgulas
  answer <- gsub(
    "\\\\textsuperscript\\{[[:space:],]*\\}",
    "",
    answer
  )
  
  # Remove equations
  answer <- gsub(
    "\\\\eqref\\{[^}]+\\}",
    "",
    answer
  )
  
  # remove double spaces
  answer <- gsub(
    "\\s*\\\\eqref\\{[^}]+\\}\\s*",
    " ",
    answer
  )
  
  # Escapa barras invertidas
  answer <- gsub("\\\\", "\\\\\\\\", answer)
  
  # ---------- Citações ----------
  refs <- if (!is.na(key)) unique(strsplit(key, "; ")[[1]]) else character(0)
  refs <- refs[refs != ""]
  # drop REF from vector
  refs <- refs[!grepl("REF", refs)]
  
  
  citations <- c()
  for (k in refs) {
    src <- bib[k]
    if (is.null(src)) next
    cit <- format(src, style = "text")
    cit <- gsub("\\[\\d+\\]", "", cit)
    cit <- gsub("_", "", cit)
    cit <- gsub("<.*?>", "", cit)
    cit <- gsub("(\\s*\\.){2,}\\s*$", ".", cit)
    cit <- escape_latex(cit)
    citations <- c(citations, cit)
  }
  
  citation_block <- if (length(citations) > 0) {
    paste0("[", seq_along(citations), "] ", citations,
           collapse = "\\newline")
  } else {
    ""
  }
  # Escapa barras invertidas
  citation_block <- gsub("\\\\", "\\\\\\\\", citation_block)
  
  # ---------- Pastas ----------
  base <- file.path(getwd(), "posts", chapter, section)
  dir.create(base, recursive = TRUE, showWarnings = FALSE)
  
  n <- length(list.files(base, pattern = "\\.png$"))
  fname <- paste0(
    n + 1, "_",
    gsub("\\s+", "_", question),
    ".png"
  )
  fpath <- file.path(base, fname)
  
  # ---------- TeX ----------
  tex <- readLines(file.path("tex", "POST.tex"))
  tex <- gsub("CAPITULO", chapter, tex)
  tex <- gsub("SECAO", section, tex)
  tex <- gsub("QUESTAO", question, tex)
  tex <- gsub("RESPOSTA", answer, tex)
  tex <- gsub("CITACAO", citation_block, tex)
  
  writeLines(tex, file.path("posts", "POST.tex"))
  
  tools::texi2pdf("posts/POST.tex", clean = TRUE, quiet = TRUE)
  
  file.rename("POST.pdf", "posts/POST.pdf")
  
  img <- pdftools::pdf_render_page("posts/POST.pdf", dpi = 300)
  png::writePNG(img, fpath)
  
  cover <- magick::image_read("images/Cover_2.png") |>
    magick::image_scale("400x400")
  
  final <- magick::image_composite(
    magick::image_read(fpath),
    cover,
    offset = "+1200+0"
  )
  
  magick::image_write(final, fpath, density = 300)
  
  file.remove("posts/POST.pdf", "posts/POST.tex")
}
