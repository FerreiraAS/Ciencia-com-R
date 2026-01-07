normalize_inline_math <- function(text) {
  gsub(
    "\\\\\\((.*?)\\\\\\)",
    "$\\1$",
    text
  )
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

parse_tex_structure <- function(tex_vec) {
  
  current_chapter <- NA_character_
  current_section <- NA_character_
  current_subsection <- NA_character_
  
  rows <- list()
  i <- 1
  
  while (i <= length(tex_vec)) {
    line <- tex_vec[i]
    
    # ---- Chapter ----
    if (stringr::str_detect(line, "^\\\\chapter\\{")) {
      current_chapter <- stringr::str_extract(
        line,
        "(?<=\\\\textbf\\{).*?(?=\\})"
      )
      current_section <- NA_character_
      current_subsection <- NA_character_
    }
    
    # ---- Section ----
    else if (stringr::str_detect(line, "^\\\\section\\{")) {
      current_section <- stringr::str_extract(
        line,
        "(?<=\\\\section\\{).*?(?=\\})"
      )
      current_subsection <- NA_character_
    }
    
    # ---- Subsection ----
    else if (stringr::str_detect(line, "^\\\\subsection\\{")) {
      current_subsection <- stringr::str_extract(
        line,
        "(?<=\\\\subsection\\{).*?(?=\\})"
      )
    }
    
    # ---- Item ----
    else if (stringr::str_detect(line, "^\\\\item")) {
      
      # capture text that appears on the same line as \item
      item_text <- stringr::str_trim(
        stringr::str_remove(line, "^\\\\item\\s*")
      )
      item_text <- normalize_inline_math(item_text)
      
      # if item text is empty, look ahead
      if (item_text == "") {
        j <- i + 1
        while (j <= length(tex_vec) &&
               (tex_vec[j] == "" || stringr::str_detect(tex_vec[j], "^\\\\"))) {
          j <- j + 1
        }
        
        if (j <= length(tex_vec)) {
          item_text <- stringr::str_trim(tex_vec[j])
          i <- j
        }
      }
      
      item_text <- normalize_inline_math(
        stringr::str_trim(tex_vec[j])
      )
      
      rows[[length(rows) + 1]] <- tibble::tibble(
        chapter    = current_chapter,
        section    = current_section,
        subsection = current_subsection,
        item       = item_text,
        references = extract_references(item_text)
      )
      
      i <- i + 1
      next
    }
    
    i <- i + 1
  }
  
  dplyr::bind_rows(rows)
}
