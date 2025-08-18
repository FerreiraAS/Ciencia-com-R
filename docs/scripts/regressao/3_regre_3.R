# simulate X
set.seed(123)
X <- seq(-10, 10, length.out = 100)

# simulate Y based on a polynomial function of X
Y <- 5 + 2 * X^3 - 0.1 * X^2 + rnorm(100, mean = 0, sd = 30)

# create a dataframe
data <- data.frame(X, Y)

# create the regression model
model <- lm(Y ~ poly(X, 3), data = data)

ggplot2::ggplot(data, ggplot2::aes(x = X, y = Y)) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "lm",
                       formula = y ~ poly(x, 3),
                       color = "blue",      # cor da linha
                       fill = "grey70",     # cor da faixa IC95%
                       se = TRUE) +         # ativa o intervalo de confiança
  ggplot2::labs(title = "Regressão polinomial",
                x = "Variável Independente (X)",
                y = "Variável Dependente (Y)") +
  ggplot2::theme_minimal()
