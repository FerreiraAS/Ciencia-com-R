# simulate X
set.seed(123)
X <- seq(-10, 10, length.out = 100)
Y <- 5 + 2 * X + rnorm(100, mean = 0, sd = 5)
data <- data.frame(X, Y)

# criar matriz de preditores com intercepto
X_matrix <- model.matrix(~ X, data = data)

# ajustar modelo de regressão ridge
model <- glmnet::glmnet(X_matrix, data$Y, alpha = 0)

# predições (usando lambda padrão)
predicted_Y <- predict(model, newx = X_matrix, s = 0.01)

# adicionar ao dataframe
data$Y_pred <- as.numeric(predicted_Y)

# plotar com ggplot
ggplot2::ggplot(data, ggplot2::aes(x = X, y = Y)) +
  ggplot2::geom_point(color = "gray40") +
  ggplot2::geom_line(ggplot2::aes(y = Y_pred), color = "blue", size = 1) +
  ggplot2::labs(title = "Regressão Ridge",
       x = "Variável Independente (X)",
       y = "Variável Dependente (Y)") +
  ggplot2::theme_minimal()
