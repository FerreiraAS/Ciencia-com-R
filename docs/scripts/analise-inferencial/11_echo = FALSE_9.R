# Reprodutibilidade
set.seed(123)

# Parâmetros
mu0 <- 0
mu1 <- 0.2
sigma <- 1
alpha <- 0.05
n <- 30
se <- sigma / sqrt(n)

# Simula um efeito superestimado (erro tipo-M)
repeat {
  obs_mean <- rnorm(1, mean = mu1, sd = se)
  z <- (obs_mean - mu0) / se
  if (abs(z) > qnorm(1 - alpha / 2) && obs_mean > mu1)
    break
}

# Densidades para visualização
x <- seq(-1, 1, length.out = 1000)
dens_H0 <- dnorm(x, mean = mu0, sd = se)
dens_H1 <- dnorm(x, mean = mu1, sd = se)
dens_estimado <- dnorm(x, mean = obs_mean, sd = se)

# Picos das curvas
pico_H1 <- dnorm(mu1, mean = mu1, sd = se)
pico_estimado <- dnorm(obs_mean, mean = obs_mean, sd = se)

# Limite superior do eixo y
y_lim_sup <- max(pico_H1, pico_estimado) + 0.15

# Dados para o gráfico
dados <- data.frame(
  x = x,
  H0 = dens_H0,
  H1 = dens_H1,
  Estimado = dens_estimado
)

# Gráfico
plot_base <- ggplot2::ggplot(dados, ggplot2::aes(x = x)) +
  ggplot2::geom_line(ggplot2::aes(y = H0, color = "H0"), size = 1) +
  ggplot2::geom_line(ggplot2::aes(y = H1, color = "H1"), size = 1) +
  ggplot2::geom_line(ggplot2::aes(y = Estimado, color = "Estimado"), size = 1) +
  
  # Linhas verticais para médias
  ggplot2::geom_vline(xintercept = mu0,
                      linetype = "dotted",
                      color = "blue") +
  ggplot2::geom_vline(xintercept = mu1,
                      linetype = "dotted",
                      color = "red") +
  
  # Anotações
  ggplot2::annotate(
    "text",
    x = mu0,
    y = max(dens_H0) * 0.95,
    label = expression(mu[0]),
    color = "blue",
    hjust = -0.1,
    parse = TRUE
  ) +
  ggplot2::annotate(
    "text",
    x = mu1,
    y = max(dens_H1) * 0.95,
    label = expression(mu[1]),
    color = "red",
    hjust = -0.1,
    parse = TRUE
  ) +
  
  # Setas e texto: efeito real
  ggplot2::annotate(
    "segment",
    x = mu1,
    xend = mu1,
    y = y_lim_sup,
    yend = pico_H1,
    arrow = ggplot2::arrow(length = grid::unit(0.2, "cm")),
    color = "red"
  ) +
  ggplot2::annotate(
    "text",
    x = mu1,
    y = y_lim_sup + 0.05,
    label = "Real (+)",
    color = "red",
    hjust = 0.5
  ) +
  
  # Setas e texto: efeito estimado (superestimado)
  ggplot2::annotate(
    "segment",
    x = obs_mean,
    xend = obs_mean,
    y = y_lim_sup,
    yend = pico_estimado,
    arrow = ggplot2::arrow(length = grid::unit(0.2, "cm")),
    color = "darkgreen"
  ) +
  ggplot2::annotate(
    "text",
    x = obs_mean,
    y = y_lim_sup + 0.05,
    label = "Estimado (++)",
    color = "darkgreen",
    hjust = 0.5
  ) +
  
  # Estilo
  ggplot2::scale_color_manual(
    name = "Densidades",
    values = c(
      "H0" = "blue",
      "H1" = "red",
      "Estimado" = "darkgreen"
    )
  ) +
  ggplot2::labs(title = "Erro Tipo-M: Superestimação da Magnitude", x = "Efeito estimado", y = "Densidade") +
  ggplot2::coord_cartesian(xlim = c(-1, 1), ylim = c(0, y_lim_sup + 0.03)) +
  ggplot2::theme_minimal() +
  ggplot2::theme(legend.position = "none")

# Exibir gráfico
plot_base
