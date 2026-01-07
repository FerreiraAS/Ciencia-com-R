ParseRmdContent <- function(rmd_files, bib) {
  
  for (k in seq_along(rmd_files)) {
    
    message("📄 Processando: ", rmd_files[k])
    
    # =========================================================
    # 1. Parse do Rmd → AST (NÃO converter ainda!)
    # =========================================================
    ast <- parsermd::parse_rmd(rmd_files[k])
    
    # =========================================================
    # 2. Documento textual completo (a partir do AST)
    # =========================================================
    doc <- parsermd::as_document(ast)
    
    # =========================================================
    # 3. Só agora converter o AST em tibble para navegação
    # =========================================================
    rmd <- tibble::as_tibble(ast) |>
      dplyr::filter(!type %in% c("rmd_chunk", "rmd_heading")) |>
      dplyr::filter(!is.na(sec_h1), !is.na(sec_h2))
    
    if (nrow(rmd) == 0) next
    
    # Remover última linha espúria
    rmd <- rmd[-nrow(rmd), ]
    
    for (i in seq_len(nrow(rmd))) {
      
      # ---------------- Capítulo ----------------
      chapter <- rmd$sec_h1[i]
      chapter <- gsub("\\*\\*", "", chapter)
      chapter <- gsub("\\{.*?\\}", "", chapter)
      chapter <- trimws(chapter)
      
      # ---------------- Seção ----------------
      section <- rmd$sec_h2[i]
      section <- gsub("\\{.*?\\}", "", section)
      section <- trimws(section)
      
      # ---------------- Pergunta ----------------
      question <- ifelse(
        is.na(rmd$sec_h3[i]),
        "Sem pergunta explícita",
        trimws(rmd$sec_h3[i])
      )
      
      # ---------------- Intervalo textual ----------------
      start <- rmd$line[i]
      end   <- rmd$end_line[i]
      
      if (is.na(start) || is.na(end)) next
      if (start > length(doc) || end > length(doc)) next
      
      block <- doc[start:end]
      
      # ---------------- Respostas ----------------
      answers <- block[
        grepl("^\\s*([-*]|[0-9]+\\.)\\s+", block)
      ]
      
      if (length(answers) == 0) next
      
      answers <- gsub("^\\s*([-*]|[0-9]+\\.)\\s+", "", answers)
      answers <- trimws(answers)
      
      # ---------------- LaTeX ----------------
      answers <- gsub("\\$\\$", "$", answers)
      answers <- gsub("\\$([a-zA-Z])", "$\\\\\\1", answers)
      answers <- gsub("\\$\\\\", "$", answers)
      
      # ---------------- Citações ----------------
      keys <- unique(unlist(
        regmatches(answers, gregexpr("@[[:alnum:]]+", answers))
      ))
      keys <- gsub("@", "", keys)
      
      answers <- gsub("\\s*\\[@[^\\]]+\\]", "", answers)
      answers <- trimws(answers)
      
      if (length(answers) == 0) next
      
      entries <- data.frame(
        chapter  = chapter,
        section  = section,
        question = question,
        answer   = answers,
        key      = paste(keys, collapse = "; "),
        stringsAsFactors = FALSE
      )
      
      for (j in seq_len(nrow(entries))) {
        SavePost(entries[j, ], bib)
      }
    }
  }
}
