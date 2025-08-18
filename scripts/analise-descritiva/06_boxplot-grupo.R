# Simular dados com dois grupos
dados <- data.frame(
  grupo = rep(c("Controle", "Tratamento"), each = 100),
  medida = c(stats::rnorm(100, mean = 50, sd = 5),
             stats::rnorm(100, mean = 55, sd = 7))
)

# Boxplot
ggplot2::ggplot(dados, ggplot2::aes(x = grupo, y = medida, fill = grupo)) +
  ggplot2::geom_boxplot() +
  ggplot2::labs(title = "Boxplot por grupo",
                x = "Grupo", y = "Medida") +
  ggplot2::theme_minimal()
