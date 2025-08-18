# Simular série temporal
set.seed(42)
tempo <- seq.Date(from = as.Date("2025-01-01"), by = "day", length.out = 100)
medida <- cumsum(stats::rnorm(100, mean = 0.2, sd = 1))
dados <- data.frame(data = tempo, valor = medida)

# Gráfico de linha com pontos
ggplot2::ggplot(dados, ggplot2::aes(x = data, y = valor)) +
  ggplot2::geom_line(color = "darkgreen") +
  ggplot2::geom_point(color = "black", size = 1.5) +
  ggplot2::labs(title = "Série Temporal Simulada",
                x = "Data", y = "Valor") +
  ggplot2::theme_minimal()
