# Parâmetros
mu0 <- 0
sigma <- 1
alpha <- 0.05

# Valores críticos (duas caudas)
z_lower <- qnorm(alpha / 2, mean = mu0, sd = sigma)
z_upper <- qnorm(1 - alpha / 2, mean = mu0, sd = sigma)

# Dados
x <- seq(mu0 - 4 * sigma, mu0 + 4 * sigma, length.out = 1000)
dens_H0 <- dnorm(x, mean = mu0, sd = sigma)
dados <- data.frame(x = x, densidade = dens_H0)

# Caudas separadas
dados_cauda_inf <- subset(dados, x <= z_lower)
dados_cauda_sup <- subset(dados, x >= z_upper)

# Gráfico
ggplot2::ggplot(dados, ggplot2::aes(x = x, y = densidade)) +
  
  # Linha da distribuição H0 com legenda
  ggplot2::geom_line(ggplot2::aes(color = "H0"), size = 1.2) +
  
  # Área das caudas com legenda
  ggplot2::geom_area(data = dados_cauda_inf,
                     ggplot2::aes(x = x, y = densidade, fill = "rc"),
                     alpha = 0.3) +
  ggplot2::geom_area(data = dados_cauda_sup,
                     ggplot2::aes(x = x, y = densidade, fill = "rc"),
                     alpha = 0.3) +
  
  # Linha pontilhada em mu0
  ggplot2::geom_vline(
    xintercept = mu0,
    linetype = "dotted",
    color = "blue",
    size = 1
  ) +
  
  # Linhas dos valores críticos com legenda
  ggplot2::geom_vline(
    ggplot2::aes(xintercept = z_lower, linetype = "zcrit"),
    color = "black",
    size = 1
  ) +
  ggplot2::geom_vline(
    ggplot2::aes(xintercept = z_upper, linetype = "zcrit"),
    color = "black",
    size = 1
  ) +
  
  # Anotações
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
    x = z_upper + 0.1,
    y = max(dens_H0) * 0.95,
    label = expression(z[1 - alpha / 2]),
    color = "black",
    parse = TRUE,
    hjust = 0
  ) +
  ggplot2::annotate(
    "text",
    x = z_lower - 0.1,
    y = max(dens_H0) * 0.95,
    label = expression(z[alpha / 2]),
    color = "black",
    parse = TRUE,
    hjust = 1
  ) +
  # Legendas
  ggplot2::scale_color_manual(
    name = NULL,
    values = c("H0" = "blue"),
    labels = c(expression("Distribuição H"[0]))
  ) +
  ggplot2::scale_fill_manual(
    name = NULL,
    values = c("rc" = "blue"),
    labels = c("Regiões críticas (α)")
  ) +
  ggplot2::scale_linetype_manual(
    name = NULL,
    values = c("zcrit" = "dashed"),
    labels = c(expression("Valores críticos (z"[alpha / 2] * ", z"[1 - alpha /
                                                                     2] * ")"))
  ) +
  ggplot2::labs(title = "Teste Bicaudal da Hipótese Nula", x = "Efeito", y = "Densidade") +
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
