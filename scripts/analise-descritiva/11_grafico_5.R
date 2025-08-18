# Simular dados com três variáveis
dados <- data.frame(
  x = stats::rnorm(100, 10, 3),
  y = stats::rnorm(100, 20, 5),
  z = abs(stats::rnorm(100, 5, 2)) # Tamanho da bolha (positivo)
)

# Gráfico de bolhas
ggplot2::ggplot(dados, ggplot2::aes(x = x, y = y, size = z)) +
  ggplot2::geom_point(alpha = 0.6, color = "purple") +
  ggplot2::labs(title = "Gráfico de Bolhas",
                x = "Eixo X", y = "Eixo Y", size = "Variável Z") +
  ggplot2::theme_minimal()
