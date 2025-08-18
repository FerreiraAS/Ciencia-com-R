# Simular dados
dados <- data.frame(
  x = stats::rnorm(100, mean = 50, sd = 10),
  y = 2 * stats::rnorm(100, mean = 50, sd = 10) + 10
)

# Gráfico de dispersão
ggplot2::ggplot(dados, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_point(color = "darkblue", alpha = 0.7) +
  ggplot2::labs(title = "Gráfico de Dispersão",
                x = "Variável X", y = "Variável Y") +
  ggplot2::theme_minimal()
