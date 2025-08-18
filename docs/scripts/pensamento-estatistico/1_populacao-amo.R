# Dados da população e amostra
set.seed(123)
pop_n <- 50
sample_n <- 10

# Reduzindo os raios internos para posicionar os ícones mais perto do centro
radius_pop <- runif(pop_n, 0.5, 2.5)
radius_sample <- runif(sample_n, 0.5, 1.5)

# Geração das posições para a população (círculo à esquerda)
angle_pop <- seq(0, 2 * pi, length.out = pop_n + 1)[-1]
pop_df <- data.frame(
  id = 1:pop_n,
  x_pop = cos(angle_pop) * radius_pop - 4,
  y_pop = sin(angle_pop) * radius_pop
)

# Seleção aleatória da amostra
sample_ids <- sample(pop_df$id, sample_n)
sample_df <- pop_df %>%
  dplyr::filter(id %in% sample_ids) %>%
  dplyr::mutate(
    angle = seq(0, 2 * pi, length.out = sample_n + 1)[-1],
    x_sample = cos(angle) * radius_sample + 4,
    y_sample = sin(angle) * radius_sample
  )

# Atribui o ícone após os data.frames estarem prontos
pop_df$label <- "./images/person.svg"
sample_df$label <- "./images/person.svg"

# Base de setas
setas_df <- sample_df %>%
  dplyr::select(id, x_pop, y_pop, x_sample, y_sample)

# Plot
ggplot2::ggplot() +
  # Círculo da população
  ggforce::geom_circle(ggplot2::aes(x0 = -4, y0 = 0, r = 3),
                       color = "black",
                       linewidth = 1) +
  ggimage::geom_image(data = pop_df,
                      ggplot2::aes(x = x_pop, y = y_pop, image = label),
                      size = 0.07) +
  ggplot2::annotate(
    "text",
    x = -4,
    y = 3.5,
    label = "População",
    size = 5,
    fontface = "bold"
  ) +
  
  # Círculo da amostra
  ggforce::geom_circle(ggplot2::aes(x0 = 4, y0 = 0, r = 1.8),
                       color = "black",
                       linewidth = 1) +
  ggimage::geom_image(
    data = sample_df,
    ggplot2::aes(x = x_sample, y = y_sample, image = label),
    size = 0.07
  ) +
  ggplot2::annotate(
    "text",
    x = 4,
    y = 2.3,
    label = "Amostra",
    size = 5,
    fontface = "bold"
  ) +
  # Setas
  ggplot2::geom_curve(
    data = setas_df,
    ggplot2::aes(
      x = x_pop,
      y = y_pop,
      xend = x_sample,
      yend = y_sample
    ),
    arrow = ggplot2::arrow(length = grid::unit(0.2, "cm")),
    color = "darkgray",
    linewidth = 0.7,
    curvature = -0.2
  ) +
  ggplot2::coord_fixed() +
  ggplot2::theme_void() +
  # Texto "Amostragem"
  ggplot2::annotate(
    "text",
    x = 0,
    y = 3,
    label = "Amostragem",
    color = "darkgray",
    size = 5,
    fontface = "italic"
  )
