# Parâmetros
mu0 <- 0
mu1 <- 1
sigma <- 1
alpha <- 0.05
z_crit <- stats::qnorm(1 - alpha, mean = mu0, sd = sigma)

# Dados principais
x <- base::seq(mu0 - 4 * sigma, mu1 + 4 * sigma, length.out = 1000)

dens_df <- dplyr::tibble(
  x = x,
  dens_H0 = stats::dnorm(x, mean = mu0, sd = sigma),
  dens_H1 = stats::dnorm(x, mean = mu1, sd = sigma)
)

# Dados das regiões de erro
area_alpha <- dplyr::filter(dens_df, x >= z_crit) %>%
  dplyr::mutate(erro = "Erro Tipo I (α)", y = dens_H0)

area_beta <- dplyr::filter(dens_df, x <= z_crit) %>%
  dplyr::mutate(erro = "Erro Tipo II (β)", y = dens_H1)

areas_df <- dplyr::bind_rows(area_alpha, area_beta)

# Gráfico
plot_base <- ggplot2::ggplot() +
  # Áreas de erro com legenda
  ggplot2::geom_area(data = areas_df,
                     ggplot2::aes(x = x, y = y, fill = erro),
                     alpha = 0.3) +
  # Curvas H0 e H1
  ggplot2::geom_line(data = dens_df,
                     ggplot2::aes(x = x, y = dens_H0, color = "H0"),
                     linewidth = 1.2) +
  ggplot2::geom_line(data = dens_df,
                     ggplot2::aes(x = x, y = dens_H1, color = "H1"),
                     linewidth = 1.2) +
  # Linhas verticais
  ggplot2::geom_vline(
    xintercept = z_crit,
    linetype = "dashed",
    color = "black",
    linewidth = 1
  ) +
  ggplot2::geom_vline(
    xintercept = mu0,
    linetype = "dotted",
    color = "blue",
    linewidth = 1
  ) +
  ggplot2::geom_vline(
    xintercept = mu1,
    linetype = "dotted",
    color = "red",
    linewidth = 1
  ) +
  # Anotações matemáticas
  ggplot2::annotate(
    "text",
    x = z_crit + 0.1,
    y = 0.2,
    label = "z[alpha]",
    parse = TRUE,
    hjust = 0,
    color = "black"
  ) +
  ggplot2::annotate(
    "text",
    x = mu0,
    y = 0.3,
    label = "mu[0]",
    parse = TRUE,
    hjust = -0.1,
    color = "blue"
  ) +
  ggplot2::annotate(
    "text",
    x = mu1,
    y = 0.3,
    label = "mu[1]",
    parse = TRUE,
    hjust = -0.1,
    color = "red"
  ) +
  ggplot2::annotate(
    "text",
    x = z_crit + 0.1,
    y = 0.1,
    label = "alpha",
    parse = TRUE,
    hjust = 0,
    color = "blue"
  ) +
  ggplot2::annotate(
    "text",
    x = z_crit - 0.4,
    y = 0.05,
    label = "beta",
    parse = TRUE,
    hjust = 0,
    color = "red"
  ) +
  # Títulos e legendas
  ggplot2::labs(
    title = "Erros tipo I e II",
    x = "Efeito",
    y = "Densidade",
    color = "Distribuições",
    fill = NULL  # Remove título da legenda de preenchimento
  ) +
  # Escalas de cores
  ggplot2::scale_color_manual(
    values = c("H0" = "blue", "H1" = "red"),
    labels = c(expression(H[0]), expression(H[1]))
  ) +
  ggplot2::scale_fill_manual(values = c(
    "Erro Tipo I (α)" = "blue",
    "Erro Tipo II (β)" = "red"
  )) +
  ggplot2::theme_minimal(base_size = 14) +
  ggplot2::theme(legend.position = "bottom")

# Exibir gráfico
plot_base
