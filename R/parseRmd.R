ParseRmdContent <- function(rmd_files, bib, k) {
    # parse Rmd files to get questions, answers, section and chapter
    rmd_rawdata <- parsermd::parse_rmd(rmd_files[k], allow_incomplete = FALSE, parse_yaml = FALSE) |>
        tibble::as_tibble()

    # clean R chunks and headings
    rmd_data <- rmd_rawdata[rmd_rawdata$type != "rmd_chunk", ]
    rmd_data <- rmd_data[rmd_data$type != "rmd_heading", ]

    # keep rows with complete headers 1 to 3
    rmd_data <- rmd_data[complete.cases(dplyr::select(rmd_data, c("sec_h1", "sec_h2", "sec_h3"))), ]

    # loop over all answers
    for (i in 1:nrow(rmd_data)) {
        chapter <- rmd_data[i, ]$sec_h1
        # remove ** from chapter
        chapter <- gsub("\\*\\*", "", chapter)
        # remove {.numbered} from chapter
        chapter <- gsub("\\{.numbered\\}", "", chapter)

        section <- rmd_data[i, ]$sec_h2
        # remove {.numbered} from section
        section <- gsub("\\{.numbered\\}", "", section)

        question <- rmd_data[i, ]$sec_h3

        answers <- rmd_data[i, ] |> parsermd::as_document()
        # keep only rows starting with '- '
        answers <- answers[grep("^- ", answers)]
        # remove - from answers
        answers <- gsub("^- ", "", answers)
        # replace $$ by $ from LaTeX equations
        answers <- gsub("\\$\\$", "$", answers)
        # replacE $ in begining of any word string by $\\
        answers <- gsub("\\$([a-zA-Z])", "$\\\\\\1", answers)
        # replace $\\ by $ from answers
        answers <- gsub("\\$\\\\", "$", answers)

        # Extrair todas as chaves citadas (removendo o '@' e separando por ponto e vírgula)
        key <- unlist(regmatches(answers, gregexpr("@[[:alnum:]]+", answers)))
        key <- gsub("@", "", key)
        
        # Remover a parte da citação do texto
        answers <- trimws(gsub("\\s*\\[@.*?\\]", "", answers), which = "left")
        
        # Chave string separada por ponto e vírgula
        key_string <- paste(key, collapse = "; ")
        
        entry <- data.frame(chapter = rep(chapter, length(answers)), section = rep(section,
            length(answers)), question = rep(question, length(answers)), answer = answers,
            key = key_string)

        if (nrow(entry) != 0) {
            for (j in 1:nrow(entry)) {
                # save post to PNG
                SavePost(entry[j, ], bib)
            }
        }
    }
}
