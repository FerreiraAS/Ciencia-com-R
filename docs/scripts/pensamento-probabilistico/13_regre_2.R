# gráfico de distribuição da amostra com os dois dados aleatórios
ggplot2::ggplot(amostra, ggplot2::aes(x = Variável)) +
  ggplot2::geom_density(alpha = 0.2, fill = "grey") +
  ggplot2::geom_vline(xintercept = dado1,
                      color = "black",
                      linetype = "dashed") +
  ggplot2::geom_vline(xintercept = dado2,
                      color = "black",
                      linetype = "dashed") +
  ggplot2::geom_vline(
    xintercept = mean(amostra$Variável),
    color = "black",
    linetype = "dashed"
  ) +
  ggplot2::geom_text(
    ggplot2::aes(
      x = dado1,
      y = 0,
      label = "Dado 1",
      hjust = 1.1,
      vjust = 1.1
    ),
    color = "black",
    size = 3
  ) +
  ggplot2::geom_text(
    ggplot2::aes(
      x = dado2,
      y = 0,
      label = "Dado 2",
      hjust = 1.1,
      vjust = 1.1
    ),
    color = "black",
    size = 3
  ) +
  ggplot2::geom_text(
    ggplot2::aes(
      x = mean(amostra$Variável),
      y = 0,
      label = "Média (valor real)",
      hjust = 1.1,
      vjust = 1.1
    ),
    color = "black",
    size = 3
  ) +
  ggplot2::labs(x = "Variável", y = "Densidade") +
  ggplot2::theme(
    ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major = ggplot2::element_blank()
  ) +
  ggplot2::scale_x_continuous(breaks = round(seq(
    min(amostra$Variável), max(amostra$Variável), by = 1
  ), 0))
