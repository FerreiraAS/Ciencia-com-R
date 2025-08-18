# Simular dados com dois grupos
dados <- data.frame(
  grupo = rep(c("Controle", "Tratamento"), each = 100),
  medida = c(stats::rnorm(100, mean = 50, sd = 5),
             stats::rnorm(100, mean = 55, sd = 7))
)

# Violin plot
ggplot2::ggplot(dados, ggplot2::aes(x = grupo, y = medida, fill = grupo)) +
  ggplot2::geom_violin(trim = FALSE, alpha = 0.6) +
  ggplot2::geom_boxplot(width = 0.1, fill = "white", outlier.shape = NA) +
  ggplot2::labs(title = "Violin Plot por Grupo",
                x = "Grupo", y = "Medida") +
  ggplot2::theme_minimal()
