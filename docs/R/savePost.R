SavePost <- function(entry, bib) {
    chapter <- entry$chapter
    section <- entry$section
    question <- entry$question
    answer <- entry$answer
    key <- entry$key

    # detect if there is a r`` code block
    if (grepl("`r", answer)) {
        # extract code block
        code <- gsub(".*`r", "", answer)
        code <- gsub("`.*", "", code)
        # evaluate code
        code.eval <- eval(parse(text = code))
        # replace code block with result
        answer <- gsub("`r.*`", code.eval, answer)
    }

    # double $ to do not convert to math
    answer <- gsub("\\$", "$$", answer)
    # convert markdown to HTML text
    answer <- markdown::markdownToHTML(text = answer, fragment.only = TRUE)
    # convert back $$ to $
    answer <- gsub("\\$\\$", "$", answer)
    # remove HTML <p> tags
    answer <- gsub("<p>", "", answer)
    answer <- gsub("</p>", "", answer)
    # remove \n t the end
    answer <- gsub("\n", "", answer)

    # function to convert italic and bold to tex
    emphasis <- function(text) {
        text <- gsub("<em>", "\\\textit{", text)
        text <- gsub("</em>", "}", text)
        text <- gsub("<strong>", "\\\textbf{", text)
        text <- gsub("</strong>", "}", text)
        return(text)
    }

    question <- emphasis(question)
    answer <- emphasis(answer)

    source <- bib[key]
    citation <- format(source, style = "text")
    citation <- gsub("\\[1\\]", "", citation)
    # remove underline character
    citation <- gsub("_", "", citation)
    # remove content within < >.
    citation <- gsub("<.*?>.", "", citation)
    # merge citations
    citation <- paste0(citation, collapse = "\\")

    # Ensure chapter folder exists
    chapter_folder <- file.path(getwd(), "posts", chapter)
    dir.create(chapter_folder, showWarnings = FALSE, recursive = TRUE)

    # Ensure section folder exists
    section_folder <- file.path(chapter_folder, section)
    dir.create(section_folder, showWarnings = FALSE, recursive = TRUE)

    # File name based on question
    file_name <- paste0(gsub(" ", "_", question), ".png")
    # add a number to file name
    file_name <- paste0(as.character(length(list.files(section_folder, pattern = ".png"))),
        "_", file_name)
    file_path <- file.path(section_folder, file_name)

    # read tex file
    tex <- readLines(file.path("tex", "POST.tex"))

    # replace CAPITULO with chapter
    tex <- gsub("CAPITULO", chapter, tex)
    # replace SECAO with section
    tex <- gsub("SECAO", section, tex)
    # replace QUESTAO with question
    tex <- gsub("QUESTAO", question, tex)
    # replace RESPOSTA with answer
    tex <- gsub("RESPOSTA", answer, tex)
    # replace CITACAO with citation
    tex <- gsub("CITACAO", citation, tex)
    # escape & character
    tex <- gsub("\\&", "\\\\&", tex)
    # escape % character
    tex <- gsub("\\%", "\\\\%", tex)

    # compile tex
    writeLines(tex, file.path("posts", "POST.tex"))

    # render text file to pdf
    tools::texi2pdf(file.path("posts", "POST.tex"), clean = TRUE)

    # move pdf to posts
    file.rename(from = file.path("POST.pdf"), to = file.path("posts", "POST.pdf"))

    # render PDF to PNG file
    bitmap <- pdftools::pdf_render_page(file.path("posts", "POST.pdf"), dpi = 300)
    png::writePNG(bitmap, file_path)

    img <- magick::image_read(file_path)
    cover <- magick::image_read(file.path(getwd(), "images", "Cover_1.png"))
    cover <- magick::image_scale(cover, "400x400")  # Ajuste o tamanho conforme necessário
    img <- magick::image_composite(img, cover, offset = "+1200+0")  # Ajuste a posição conforme necessário
    magick::image_write(img, path = file_path, format = "png", quality = 100, density = 300)

    # delete pdf and tex files
    file.remove(file.path("posts", "POST.pdf"))
    file.remove(file.path("posts", "POST.tex"))
}
