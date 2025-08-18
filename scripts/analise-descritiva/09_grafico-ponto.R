# Simular dados
set.seed(123)
dados <- data.frame(
  grupo = rep(c("Controle", "Tratamento"), each = 20),
  medida = c(stats::rnorm(20, mean = 50, sd = 5),
             stats::rnorm(20, mean = 55, sd = 5))
)

# Dot plot
ggplot2::ggplot(dados, ggplot2::aes(x = grupo, y = medida, color = grupo)) +
  ggplot2::geom_dotplot(binaxis = "y", stackdir = "center", dotsize = 0.7) +
  ggplot2::labs(title = "Dot Plot por Grupo",
                x = "Grupo", y = "Medida") +
  ggplot2::theme_minimal()
