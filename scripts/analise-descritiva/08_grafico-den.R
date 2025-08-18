# Simular dados
dados <- data.frame(valor = stats::rnorm(1000, mean = 0, sd = 1))

# Gráfico de densidade
ggplot2::ggplot(dados, ggplot2::aes(x = valor)) +
  ggplot2::geom_density(fill = "lightblue", alpha = 0.6) +
  ggplot2::labs(title = "Gráfico de Densidade da variável 'valor'",
                x = "Valor", y = "Densidade") +
  ggplot2::theme_minimal()
