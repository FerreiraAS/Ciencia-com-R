SavePost <- function(entry, bib, j) {
  chapter <- entry$chapter
  section <- entry$section
  question <- entry$question
  answer <- entry$answer
  key <- entry$key
  
  source <- bib[key]
  citation <- format(source, style = "text")
  citation <- gsub("\\[1\\]", "", citation)
  
  # Ensure chapter folder exists
  chapter_folder <- file.path(getwd(), "posts", chapter)
  dir.create(chapter_folder,
             showWarnings = FALSE,
             recursive = TRUE)
  
  # Ensure section folder exists
  section_folder <- file.path(chapter_folder, section)
  dir.create(section_folder,
             showWarnings = FALSE,
             recursive = TRUE)
  
  # File name based on question
  file_name <- paste0(gsub(" ", "_", question), ".png")
  # add number j to file name
  file_name <- paste0(j, "_", file_name)
  file_path <- file.path(section_folder, file_name)
  
  plot <- ggplot2::ggplot() +
    ggplot2::theme_void() +
    # you will read this first (QUESTION)
    ggplot2::geom_rect(
      ggplot2::aes(
        xmin = -1,
        xmax = 2,
        ymin = 0.4,
        ymax = 0.8
      ),
      fill = "white",
      color = "white",
      linetype = "solid"
    ) +
    ggplot2::annotate(
      "text",
      x = 0,
      y = 0.6,
      label = stringr::str_wrap(question, width = 20),
      size = 6,
      hjust = 0,
      vjust = 0.5,
      color = "black",
      fontface = 2 # bold format
    ) +
    # And then you will read this (ANSWER)
    ggplot2::annotate(
      "text",
      x = 0,
      y = 0.225,
      label = stringr::str_wrap(answer, width = 60),
      size = 3,
      hjust = 0,
      vjust = 0.5,
      color = "white"
    ) +
    # Then this one (CITATION)
    ggplot2::annotate(
      "text",
      x = 0.5,
      y = 0.0,
      label = stringr::str_wrap(citation, width = 120),
      size = 1.5,
      hjust = 0.5,
      vjust = 0.5,
      color = "white"
    ) +
    # And you will read this last (CHAPTER)
    ggplot2::annotate(
      "text",
      x = 0,
      y = 0.97,
      label = chapter,
      size = 3,
      hjust = 0,
      vjust = 0.5,
      color = "yellow"
    ) +
    # And you will read this last (Section)
    ggplot2::annotate(
      "text",
      x = 0,
      y = 0.93,
      label = section,
      size = 2,
      hjust = 0,
      vjust = 0.5,
      color = "yellow"
    ) +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "black", color = NA),
      plot.margin = ggplot2::margin(0, 0, 0, 0, "cm")
    ) +
    ggplot2::coord_fixed(ratio = 1) +
    ggplot2::coord_cartesian(xlim = c(0, 1), ylim = c(0, 1))
  
  png(
    filename = file_path,
    width = 1080,
    height = 1080,
    res = 300
  )
  print(plot)
  dev.off()
  
  img <- magick::image_read(file_path)
  logo <- magick::image_read(file.path(getwd(), "images", "Cover_1.png"))
  logo <- magick::image_scale(logo, "200x200")  # Ajuste o tamanho conforme necessário
  img <- magick::image_composite(img, logo, offset = "+935+10")  # Ajuste a posição conforme necessário
  magick::image_write(img, path = file_path, format = "png")
}
