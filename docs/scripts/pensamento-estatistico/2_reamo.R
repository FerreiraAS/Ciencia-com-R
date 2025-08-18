# reproducibilidade
set.seed(123)

# parâmetros
pop_n <- 50
sample_n <- 10
svg_size <- 0.045
y_offsets <- c(6, 3, 0, -3, -6)
raio_reamostra <- 1.2

# População (coluna 1)
radius_pop <- runif(pop_n, 0.5, 2.5)
angle_pop <- seq(0, 2 * pi, length.out = pop_n + 1)[-1]
pop_df <- data.frame(
  id = 1:pop_n,
  x_pop = cos(angle_pop) * radius_pop - 6,
  y_pop = sin(angle_pop) * radius_pop,
  label = "./images/person.svg"
)

# Amostra (coluna 2)
radius_sample <- runif(sample_n, 0.4, 1.2)
angle_sample <- seq(0, 2 * pi, length.out = sample_n + 1)[-1]
sample_ids <- sample(pop_df$id, sample_n)
sample_df <- dplyr::filter(pop_df, id %in% sample_ids) |>
  dplyr::mutate(
    angle = angle_sample,
    x_sample = cos(angle) * radius_sample,
    y_sample = sin(angle) * radius_sample,
    label = "./images/person.svg"
  )

# Reamostras (coluna 3) — agora bootstrap da amostra
reamostra_list <- lapply(seq_along(y_offsets), function(i) {
  offset <- y_offsets[i]
  radius_sample <- runif(sample_n, 0.3, 1.1)
  angle_sample <- seq(0, 2 * pi, length.out = sample_n + 1)[-1]
  
  # Bootstrap da amostra: sorteia com reposição
  re_ids <- sample(sample_df$id, sample_n, replace = TRUE)
  sample_boot <- dplyr::filter(sample_df, id %in% re_ids)
  
  # Para manter mesmo número de pontos, atribuímos posições sequenciais
  sample_boot <- dplyr::arrange(sample_boot, id)[seq_len(sample_n), ] |>
    dplyr::mutate(
      angle = angle_sample,
      x_sample_reamostra = cos(angle) * radius_sample + 6,
      y_sample_reamostra = sin(angle) * radius_sample + offset,
      grupo = paste0("Reamostra ", i)
    )
})
reamostras_df <- dplyr::bind_rows(reamostra_list)

# Setas: População → Amostra
setas_amostra <- dplyr::left_join(
  dplyr::filter(pop_df, id %in% sample_ids),
  dplyr::select(sample_df, id, xend = x_sample, yend = y_sample),
  by = "id"
) |>
  dplyr::rename(x = x_pop, y = y_pop)

# Setas: Amostra → Reamostras (AGORA COMPLETO)
# Faz um join entre a amostra e todas as ocorrências nas reamostras.
setas_reamostras <- dplyr::inner_join(
  dplyr::select(sample_df, id, x_amostra = x_sample, y_amostra = y_sample),
  dplyr::select(
    reamostras_df,
    id,
    x_sample_reamostra,
    y_sample_reamostra,
    grupo
  ),
  by = "id"
) |>
  dplyr::rename(x = x_amostra,
                y = y_amostra,
                xend = x_sample_reamostra,
                yend = y_sample_reamostra)


# Gráfico
ggplot2::ggplot() +
  # Coluna População
  ggforce::geom_circle(ggplot2::aes(x0 = -6, y0 = 0, r = 3),
                       color = "black",
                       linewidth = 1) +
  ggimage::geom_image(data = pop_df,
                      ggplot2::aes(x = x_pop, y = y_pop, image = label),
                      size = svg_size) +
  ggplot2::annotate(
    "text",
    x = -6,
    y = 3.5,
    label = "População",
    size = 5,
    fontface = "bold"
  ) +
  # Coluna Amostra
  ggforce::geom_circle(ggplot2::aes(x0 = 0, y0 = 0, r = 1.8),
                       color = "black",
                       linewidth = 1) +
  ggimage::geom_image(
    data = sample_df,
    ggplot2::aes(x = x_sample, y = y_sample, image = label),
    size = svg_size
  ) +
  ggplot2::annotate(
    "text",
    x = 0,
    y = 2.3,
    label = "Amostra",
    size = 5,
    fontface = "bold"
  ) +
  # Coluna Reamostras
  ggforce::geom_circle(
    data = data.frame(x0 = 6, y0 = y_offsets, r = raio_reamostra),
    ggplot2::aes(x0 = x0, y0 = y0, r = r),
    color = "black",
    linewidth = 1
  ) +
  ggimage::geom_image(
    data = reamostras_df,
    ggplot2::aes(x = x_sample_reamostra, y = y_sample_reamostra, image = label),
    size = svg_size
  ) +
  ggplot2::geom_text(
    data = data.frame(
      x = 6,
      y = y_offsets,
      label = paste0("Reamostra ", 1:5)
    ),
    ggplot2::aes(
      x = x,
      y = y + raio_reamostra + 0.4,
      label = label
    ),
    size = 4.2,
    fontface = "bold"
  ) +
  # Setas: População → Amostra
  ggplot2::geom_curve(
    data = setas_amostra,
    ggplot2::aes(
      x = x,
      y = y,
      xend = xend,
      yend = yend
    ),
    arrow = ggplot2::arrow(length = grid::unit(0.2, "cm")),
    color = "gray50",
    linewidth = 0.6,
    curvature = -0.2
  ) +
  # Setas: Amostra → Reamostras
  ggplot2::geom_curve(
    data = setas_reamostras,
    ggplot2::aes(
      x = x,
      y = y,
      xend = xend,
      yend = yend
    ),
    arrow = ggplot2::arrow(length = grid::unit(0.2, "cm")),
    color = "gray60",
    linewidth = 0.6,
    curvature = -0.2
  ) +
  ggplot2::theme_void()
