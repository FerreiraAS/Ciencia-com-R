# para reprodutibilidade
set.seed(1234)

# Função para criar o alvo com os pontos
target_board_ggplot <- function(title,
                                m_shift = 0,
                                sd_spread = 0.1) {
  # Cria um dataframe com os pontos aleatórios
  df_points <- tibble::tibble(
    x = runif(10, min = m_shift - sd_spread, max = m_shift + sd_spread),
    y = runif(10, min = m_shift - sd_spread, max = m_shift + sd_spread)
  )
  
  ggplot2::ggplot(df_points, ggplot2::aes(x = x, y = y)) +
    # Círculos concêntricos do alvo
    ggplot2::geom_point(
      ggplot2::aes(x = 0, y = 0),
      shape = 21,
      size = 40,
      fill = "gray80",
      color = "black"
    ) +
    ggplot2::geom_point(
      ggplot2::aes(x = 0, y = 0),
      shape = 21,
      size = 36,
      fill = "white",
      color = "white"
    ) +
    ggplot2::geom_point(
      ggplot2::aes(x = 0, y = 0),
      shape = 21,
      size = 32,
      fill = "gray70",
      color = "gray70"
    ) +
    ggplot2::geom_point(
      ggplot2::aes(x = 0, y = 0),
      shape = 21,
      size = 28,
      fill = "white",
      color = "white"
    ) +
    ggplot2::geom_point(
      ggplot2::aes(x = 0, y = 0),
      shape = 21,
      size = 24,
      fill = "gray60",
      color = "gray60"
    ) +
    ggplot2::geom_point(
      ggplot2::aes(x = 0, y = 0),
      shape = 21,
      size = 20,
      fill = "white",
      color = "white"
    ) +
    ggplot2::geom_point(
      ggplot2::aes(x = 0, y = 0),
      shape = 21,
      size = 16,
      fill = "gray50",
      color = "gray50"
    ) +
    ggplot2::geom_point(
      ggplot2::aes(x = 0, y = 0),
      shape = 21,
      size = 12,
      fill = "white",
      color = "white"
    ) +
    
    # Adiciona os pontos aleatórios
    ggplot2::geom_point(
      shape = 4,
      size = 4,
      stroke = 1.2,
      color = "black"
    ) +
    
    # Define as coordenadas e o tema
    ggplot2::coord_fixed(xlim = c(-1.0, 1.0), ylim = c(-1.0, 1.0)) +
    ggplot2::theme_void() +
    ggplot2::ggtitle(title) +
    ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))
}

p1 <- target_board_ggplot("Viés alto, Variância baixa",
                          m_shift = 0.3,
                          sd_spread = 0.1)
p2 <- target_board_ggplot("Viés baixo, Variância alta",
                          m_shift = 0,
                          sd_spread = 0.2)
p3 <- target_board_ggplot("Viés baixo, Variância baixa",
                          m_shift = 0,
                          sd_spread = 0.1)

# Grid de 1x3 para exibir os plots
gridExtra::grid.arrange(p1, p2, p3, ncol = 3)
