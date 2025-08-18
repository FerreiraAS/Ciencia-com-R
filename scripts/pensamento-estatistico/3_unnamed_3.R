# Reprodutibilidade
set.seed(123)

# Tamanhos
pop_n <- 50
sample_n <- 15
subsample_n <- 5

# Raio dos círculos
radius_pop <- runif(pop_n, 0.5, 2.5)
radius_sample <- runif(sample_n, 0.5, 1.5)
radius_subsample <- runif(subsample_n, 0.5, 1)

# Ângulos para posicionamento circular
angle_pop <- seq(0, 2 * pi, length.out = pop_n + 1)[-1]
angle_sample <- seq(0, 2 * pi, length.out = sample_n + 1)[-1]
angle_subsample <- seq(0, 2 * pi, length.out = subsample_n + 1)[-1]

# População (esquerda)
pop_df <- data.frame(
  id = 1:pop_n,
  x_pop = cos(angle_pop) * radius_pop - 6,
  y_pop = sin(angle_pop) * radius_pop,
  label = "./images/person.svg"
)

# Amostra (centro)
sample_ids <- sample(pop_df$id, sample_n)
sample_df <- pop_df %>%
  dplyr::filter(id %in% sample_ids) %>%
  dplyr::mutate(
    angle = angle_sample,
    x_sample = cos(angle_sample) * radius_sample,
    y_sample = sin(angle_sample) * radius_sample,
    label = "./images/person.svg"
  )

# Subamostra (direita)
subsample_ids <- sample(sample_df$id, subsample_n)
subsample_df <- sample_df %>%
  dplyr::filter(id %in% subsample_ids) %>%
  dplyr::mutate(
    angle = angle_subsample,
    x_sub = cos(angle_subsample) * radius_subsample + 6,
    y_sub = sin(angle_subsample) * radius_subsample,
    label = "./images/person.svg"
  )

# Setas população → amostra
setas_1 <- sample_df %>%
  dplyr::select(id, x_pop, y_pop, x_sample, y_sample)

# Setas amostra → subamostra
setas_2 <- subsample_df %>%
  dplyr::select(id, x_sample, y_sample, x_sub, y_sub)

# Plot
ggplot2::ggplot() +
  # Círculo da população
  ggforce::geom_circle(ggplot2::aes(x0 = -6, y0 = 0, r = 3),
                       color = "black",
                       linewidth = 1) +
  ggimage::geom_image(data = pop_df,
                      ggplot2::aes(x = x_pop, y = y_pop, image = label),
                      size = 0.07) +
  ggplot2::annotate(
    "text",
    x = -6,
    y = 3.5,
    label = "População",
    size = 5,
    fontface = "bold"
  ) +
  # Círculo da amostra
  ggforce::geom_circle(ggplot2::aes(x0 = 0, y0 = 0, r = 2),
                       color = "black",
                       linewidth = 1) +
  ggimage::geom_image(data = sample_df,
                      ggplot2::aes(x = x_sample, y = y_sample, image = label),
                      size = 0.07) +
  ggplot2::annotate(
    "text",
    x = 0,
    y = 2.5,
    label = "Amostra",
    size = 5,
    fontface = "bold"
  ) +
  # Círculo da subamostra
  ggforce::geom_circle(ggplot2::aes(x0 = 6, y0 = 0, r = 1.2),
                       color = "black",
                       linewidth = 1) +
  ggimage::geom_image(data = subsample_df,
                      ggplot2::aes(x = x_sub, y = y_sub, image = label),
                      size = 0.07) +
  ggplot2::annotate(
    "text",
    x = 6,
    y = 1.7,
    label = "Subamostra",
    size = 5,
    fontface = "bold"
  ) +
  # Setas: população → amostra
  ggplot2::geom_curve(
    data = setas_1,
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
  # Setas: amostra → subamostra
  ggplot2::geom_curve(
    data = setas_2,
    ggplot2::aes(
      x = x_sample,
      y = y_sample,
      xend = x_sub,
      yend = y_sub
    ),
    arrow = ggplot2::arrow(length = grid::unit(0.2, "cm")),
    color = "darkgray",
    linewidth = 0.7,
    curvature = 0.2
  ) +
  ggplot2::coord_fixed() +
  ggplot2::theme_void()
