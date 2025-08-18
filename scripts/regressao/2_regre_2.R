# simulate X
set.seed(123)
X <- seq(-10, 10, length.out = 100)

# simulate Y based on a non-linear function of X
Y <- 5 + 2 * X^2 + rnorm(100, mean = 0, sd = 30)

# create a dataframe
data <- data.frame(X, Y)

# create the regression model
model <- lm(Y ~ poly(X, 2), data = data)

# plot the regression line
ggplot2::ggplot(data, ggplot2::aes(x = X, y = Y)) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "lm",
                       formula = y ~ poly(x, 2),
                       color = "blue",
                       fill = "grey70", # cor da área do IC
                       se = TRUE) +     # ativa o intervalo de confiança
  ggplot2::labs(title = "Regressão não-linear", 
                x = "Variável Independente (X)", 
                y = "Variável Dependente (Y)") +
  ggplot2::theme_minimal()
