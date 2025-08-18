allocation_plot <- function(n_left = 6,
                            lab_title = "Alocação Aleatória (1:1)",
                            img_path  = "./images/person.svg",
                            right_split_y = 3,
                            gap = 0.2,
                            curve_frac = 0.85) {

  # painéis
  left_panel  <- data.frame(xmin = 0, xmax = 4,  ymin = 0, ymax = 6)
  right_panel <- data.frame(xmin = 7, xmax = 11, ymin = 0, ymax = 6)

  # pessoas no painel esquerdo
  left_people <- data.frame(
    x = seq(0.6, 3.4, length.out = n_left),
    y = rep(3, n_left),
    id = 1:n_left,
    image = img_path
  )

  # alocação aleatória balanceada
  arms <- sample(rep(c("A","B"), length.out = n_left))
  ids_A <- left_people$id[arms == "A"]
  ids_B <- left_people$id[arms == "B"]

  make_row <- function(ids, yval, xmin = 7.7, xmax = 10.3) {
    xs <- seq(xmin, xmax, length.out = max(3, length(ids)))
    data.frame(x = xs[seq_along(ids)], y = yval, id = ids, image = img_path)
  }
  right_top <- make_row(ids_A, yval = 4.8); right_top$arm <- "A"
  right_bot <- make_row(ids_B, yval = 1.2); right_bot$arm <- "B"
  right_people <- rbind(right_top, right_bot)

  # setas: origem, nó e destinos (primeiros de cada fileira)
  origin <- data.frame(x = left_panel$xmax + 0.2, y = 3.0)
  node   <- data.frame(x = 5.5, y = 3.0)
  dest_A <- subset(right_top, id == min(right_top$id))[1, c("x","y")]
  dest_B <- subset(right_bot, id == min(right_bot$id))[1, c("x","y")]

  # encurtar curvas para não entrar no ícone
  shorten <- function(x0, y0, x1, y1, frac = 0.85) {
    data.frame(x = x0 + frac * (x1 - x0),
               y = y0 + frac * (y1 - y0))
  }
  end_A <- shorten(node$x, node$y, dest_A$x, dest_A$y, frac = curve_frac)
  end_B <- shorten(node$x, node$y, dest_B$x, dest_B$y, frac = curve_frac)

  ggplot2::ggplot() +
    # painel esquerdo
    ggplot2::annotate("rect",
      xmin = left_panel$xmin, xmax = left_panel$xmax,
      ymin = left_panel$ymin, ymax = left_panel$ymax,
      fill = "grey90", colour = "black"
    ) +
    # painel direito superior
    ggplot2::annotate("rect",
      xmin = right_panel$xmin, xmax = right_panel$xmax,
      ymin = right_split_y + gap/2, ymax = right_panel$ymax,
      fill = "grey90", colour = "black"
    ) +
    # painel direito inferior
    ggplot2::annotate("rect",
      xmin = right_panel$xmin, xmax = right_panel$xmax,
      ymin = right_panel$ymin, ymax = right_split_y - gap/2,
      fill = "grey85", colour = "black"
    ) +

    # pessoas
    ggimage::geom_image(data = left_people,
                        ggplot2::aes(x, y, image = image), size = 0.08) +
    ggplot2::geom_text(data = left_people,
                       ggplot2::aes(x, y, label = id), vjust = 3, size = 3) +
    ggimage::geom_image(data = right_people,
                        ggplot2::aes(x, y, image = image), size = 0.08) +
    ggplot2::geom_text(data = right_people,
                       ggplot2::aes(x, y, label = id), vjust = 3, size = 3) +

    # setas
    ggplot2::annotate("segment",
      x = origin$x, y = origin$y,
      xend = node$x,  yend = node$y,
      colour = "black", linewidth = 1
    ) +
    ggplot2::annotate("curve",
      x = node$x, y = node$y,
      xend = end_A$x, yend = end_A$y,
      curvature = 0.28,
      arrow = grid::arrow(length = grid::unit(0.25, "inches"), type = "closed"),
      colour = "black", linewidth = 1
    ) +
    ggplot2::annotate("curve",
      x = node$x, y = node$y,
      xend = end_B$x, yend = end_B$y,
      curvature = -0.28,
      arrow = grid::arrow(length = grid::unit(0.25, "inches"), type = "closed"),
      colour = "black", linewidth = 1
    ) +

    # rótulos
    ggplot2::annotate("text", x = 2, y = 5.6, label = "Amostra", size = 4) +
    ggplot2::annotate("text",
      x = right_panel$xmin + 0.5, y = 5.5,
      label = "Grupo A", hjust = 0, size = 4
    ) +
    ggplot2::annotate("text",
      x = right_panel$xmin + 0.5, y = 2.0,
      label = "Grupo B", hjust = 0, size = 4
    ) +

    ggplot2::ggtitle(lab_title) +
    ggplot2::theme_void() +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "white", colour = NA),
      plot.title = ggplot2::element_text(hjust = 0.5, size = 14),
      plot.margin = ggplot2::margin(14, 14, 14, 14)
    )
}

# exemplo
allocation_plot(n_left = 10)
