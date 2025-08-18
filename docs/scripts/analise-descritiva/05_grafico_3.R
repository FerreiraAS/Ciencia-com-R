# Simular dados
dados <- data.frame(valor = stats::rnorm(1000, mean = 50, sd = 10))

# Histograma
ggplot2::ggplot(dados, ggplot2::aes(x = valor)) +
  ggplot2::geom_histogram(binwidth = 5, fill = "steelblue", color = "white") +
  ggplot2::labs(title = "Histograma da variável 'valor'",
                x = "Valor", y = "Frequência") +
  ggplot2::theme_minimal()
