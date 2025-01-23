ParseRmdContent <- function(rmd_files, bib, k) {
  # parse Rmd files to get questions, answers, section and chapter
  rmd_rawdata <- parsermd::parse_rmd(rmd_files[k],
                                     allow_incomplete = FALSE,
                                     parse_yaml = FALSE) |> tibble::as_tibble()
  
  # clean R chunks and headings
  rmd_data <- rmd_rawdata[rmd_rawdata$type != "rmd_chunk", ]
  rmd_data <- rmd_data[rmd_data$type != "rmd_heading", ]
  
  # keep rows with complete headers 1 to 3
  rmd_data <- rmd_data[complete.cases(dplyr::select(rmd_data, c("sec_h1", "sec_h2", "sec_h3"))), ]
  
  # loop over all entries
  index <- 1
  for (i in 1:nrow(rmd_data)) {
    chapter <- rmd_data[index, ]$sec_h1
    # remove ** from chapter
    chapter <- gsub("\\*\\*", "", chapter)
    section <- rmd_data[index, ]$sec_h2
    question <- rmd_data[index, ]$sec_h3
    answers <- rmd_data[index, ] |> parsermd::as_document()
    # keep only rows starting with "- "
    answers <- answers[grep("^- ", answers)]
    # remove - from answers
    answers <- gsub("^- ", "", answers)
    # get content within brackets starting with @ [@]
    key <- gsub(".*\\[@(.*?)\\].*", "\\1", answers)
    # get source from answers [@key]
    answers <- trimws(gsub("\\[@(.*?)\\]", "", answers), which = "left")
    
    # create data entry
    entries <- data.frame(
      chapter = rep(chapter, length(answers)),
      section = rep(section, length(answers)),
      question = rep(question, length(answers)),
      answer = answers,
      key = key
    )
    
    # save entries
    for (j in 1:nrow(entries)) {
      entry <- entries[j, ]
      SavePost(entry, bib, j)
    }
    
    # update index
    index <- index + nrow(entries)
  }
}