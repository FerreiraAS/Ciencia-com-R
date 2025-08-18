# Parâmetros
mu0 <- 0
sigma <- 1
alpha <- 0.05

# Valor crítico (cauda esquerda)
z_crit <- qnorm(alpha, mean = mu0, sd = sigma)

# Dados
x <- seq(mu0 - 4 * sigma, mu0 + 4 * sigma, length.out = 1000)
dens_H0 <- dnorm(x, mean = mu0, sd = sigma)
dados <- data.frame(x = x, densidade = dens_H0)
dados$regiao_critica <- ifelse(x <= z_crit, "regiao_critica", "h0")

# Gráfico
ggplot2::ggplot(dados, ggplot2::aes(x = x, y = densidade)) +
  ggplot2::geom_line(ggplot2::aes(color = "h0"), size = 1.2) +
  ggplot2::geom_area(
    data = subset(dados, regiao_critica == "regiao_critica"),
    ggplot2::aes(fill = "regiao_critica"),
    alpha = 0.3
  ) +
  ggplot2::geom_vline(
    xintercept = mu0,
    linetype = "dotted",
    color = "blue",
    size = 1
  ) +
  ggplot2::geom_vline(
    ggplot2::aes(xintercept = z_crit, linetype = "zcrit"),
    color = "black",
    size = 1
  ) +
  ggplot2::annotate(
    "text",
    x = mu0 + 0.1,
    y = max(dens_H0) * 0.85,
    label = expression(mu[0]),
    color = "blue",
    parse = TRUE,
    hjust = 0
  ) +
  ggplot2::annotate(
    "text",
    x = z_crit + 0.1,
    y = max(dens_H0) * 0.95,
    label = expression(z[alpha]),
    color = "black",
    parse = TRUE,
    hjust = 0
  ) +
  ggplot2::scale_color_manual(
    name = NULL,
    values = c("h0" = "blue"),
    labels = c(expression("Distribuição H"[0]))
  ) +
  ggplot2::scale_linetype_manual(
    name = NULL,
    values = c("zcrit" = "dashed"),
    labels = c(expression("Valor crítico (z"[alpha] * ")"))
  ) +
  ggplot2::scale_fill_manual(
    name = NULL,
    values = c("regiao_critica" = "blue"),
    labels = c("Região crítica (α)")
  ) +
  ggplot2::labs(title = "Teste Unicaudal (cauda esquerda) da Hipótese Nula", x = "Efeito", y = "Densidade") +
  ggplot2::theme_minimal(base_size = 14) +
  ggplot2::theme(legend.position = "bottom",
                 legend.text = ggplot2::element_text(size = 12)) +
  ggplot2::guides(
    color = ggplot2::guide_legend(order = 1, override.aes = list(linetype = "solid")),
    linetype = ggplot2::guide_legend(
      order = 2,
      override.aes = list(color = "black", size = 1)
    ),
    fill = ggplot2::guide_legend(order = 3, override.aes = list(alpha = 0.3))
  )
