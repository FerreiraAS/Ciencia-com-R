extract_latex_argument <- function(line, command) {
  
  pattern <- paste0("^\\\\", command, "\\{")
  if (!grepl(pattern, line)) return(NA_character_)
  
  start <- regexpr(pattern, line)
  pos <- start + attr(start, "match.length")
  
  depth <- 1
  chars <- strsplit(line, "")[[1]]
  out <- character()
  
  while (pos <= length(chars) && depth > 0) {
    ch <- chars[pos]
    
    if (ch == "{") depth <- depth + 1
    if (ch == "}") depth <- depth - 1
    
    if (depth > 0) out <- c(out, ch)
    pos <- pos + 1
  }
  
  paste(out, collapse = "")
}

strip_outer_textbf <- function(text) {
  if (is.na(text)) return(text)
  
  m <- regexec("^\\\\textbf\\{(.*)\\}$", text)
  res <- regmatches(text, m)[[1]]
  
  if (length(res) > 1) res[2] else text
}

normalize_inline_math <- function(text) {
  gsub(
    "\\\\\\((.*?)\\\\\\)",
    "$\\1$",
    text,
    perl = TRUE
  )
}

# Remove \texorpdfstring{A}{B} -> A
# (preserva matemática e grupos internos)
normalize_texorpdfstring <- function(text) {
  gsub(
    "\\\\texorpdfstring\\{([^{}]*(?:\\{[^}]*\\}[^}]*)*)\\}\\{[^}]*\\}",
    "\\1",
    text,
    perl = TRUE
  )
}

extract_includegraphics <- function(line) {
  
  m <- regexpr("\\\\centering \\\\includegraphics\\{", line)
  if (m == -1) return(NA_character_)
  
  pos <- m + attr(m, "match.length")
  
  depth <- 1
  chars <- strsplit(line, "")[[1]]
  out <- character()
  
  while (pos <= length(chars) && depth > 0) {
    ch <- chars[pos]
    
    if (ch == "{") depth <- depth + 1
    if (ch == "}") depth <- depth - 1
    
    if (depth > 0) out <- c(out, ch)
    pos <- pos + 1
  }
  
  paste(out, collapse = "")
}

extract_references <- function(text) {
  refs <- stringr::str_extract_all(
    text,
    "(?<=\\\\citeproc\\{)[^}]+"
  )[[1]]
  
  if (length(refs) == 0) {
    NA_character_
  } else {
    refs <- sub("^ref-", "", refs)
    paste(unique(refs), collapse = "; ")
  }
}

# Parser principal
parse_tex_structure <- function(tex_vec) {
  
  # Pré-normalizações críticas
  tex_vec <- normalize_texorpdfstring(tex_vec)
  
  current_chapter    <- NA_character_
  current_section    <- NA_character_
  current_subsection <- NA_character_
  
  rows <- list()
  i <- 1
  
  while (i <= length(tex_vec)) {
    line <- tex_vec[i]
    
    # ---- Chapter ----
    if (stringr::str_detect(line, "^\\\\chapter\\{")) {
      current_chapter <- extract_latex_argument(line, "chapter")
      current_chapter <- strip_outer_textbf(current_chapter)
      
      current_section <- NA_character_
      current_subsection <- NA_character_
    }
    
    # ---- Section ----
    else if (stringr::str_detect(line, "^\\\\section\\{")) {
      current_section <- extract_latex_argument(line, "section")
      current_subsection <- NA_character_
    }
    
    # ---- Subsection ----
    else if (stringr::str_detect(line, "^\\\\subsection\\{")) {
      current_subsection <- extract_latex_argument(line, "subsection")
    }
    
    # ---- Item ----
    else if (stringr::str_detect(line, "^\\\\item")) {
      
      # Texto na mesma linha do \item
      item_text <- stringr::str_trim(
        stringr::str_remove(line, "^\\\\item\\s*")
      )
      
      # Look-ahead se o item estiver vazio
      if (item_text == "") {
        j <- i + 1
        while (
          j <= length(tex_vec) &&
          (tex_vec[j] == "" || stringr::str_detect(tex_vec[j], "^\\\\"))
        ) {
          j <- j + 1
        }
        
        if (j <= length(tex_vec)) {
          item_text <- stringr::str_trim(tex_vec[j])
          i <- j
        }
      }
      
      # Normalizações finais do item
      item_text <- normalize_inline_math(item_text)
      
      rows[[length(rows) + 1]] <- tibble::tibble(
        chapter    = current_chapter,
        section    = current_section,
        subsection = current_subsection,
        item       = item_text,
        graphic    = NA_character_,
        references = extract_references(item_text)
      )
      
      i <- i + 1
      next
    } 
    # ---- Includegraphics ----
    else if (stringr::str_detect(line, "\\\\includegraphics\\{")) {
      
      graphic_path <- extract_includegraphics(line)
      
      rows[[length(rows) + 1]] <- tibble::tibble(
        chapter    = current_chapter,
        section    = current_section,
        subsection = current_subsection,
        item       = NA_character_,
        graphic    = graphic_path,
        references = NA_character_
      )
      
      i <- i + 1
      next
    }
    
    i <- i + 1
  }
  
  dplyr::bind_rows(rows)
}
