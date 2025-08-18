# Simular dados com correlação
set.seed(1)
x <- stats::rnorm(100)
y <- 2 * x + stats::rnorm(100, sd = 0.5)
dados <- data.frame(x = x, y = y)

# Gráfico de dispersão com linha de tendência
ggplot2::ggplot(dados, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_point(color = "darkblue", alpha = 0.6) +
  ggplot2::geom_smooth(method = "lm", color = "red", se = FALSE) +
  ggplot2::labs(title = "Correlação entre Variáveis",
                x = "Variável X", y = "Variável Y") +
  ggplot2::theme_minimal()
