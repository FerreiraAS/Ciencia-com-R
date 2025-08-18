# Reprodutibilidade
set.seed(123)

# simulate X
X <- rnorm(100, mean = 50, sd = 10)

# simulate Y based on X
Y <- 5 + 2 * X + rnorm(100, mean = 0, sd = 5)

# create a dataframe
data <- data.frame(X, Y)

# create the regression model
model <- lm(Y ~ X, data = data)

# calcular resíduos padronizados
data$resid <- rstandard(model)

# marcar outliers (|resíduo padronizado| > 2)
data$outlier <- abs(data$resid) > 2

# plot the regression line e outliers
ggplot2::ggplot(data, ggplot2::aes(x = X, y = Y)) +
  ggplot2::geom_point(ggplot2::aes(color = outlier)) +
  ggplot2::scale_color_manual(values = c("black", "red"),
                              labels = c("Normal", "Discrepante"),
                              name = "Pontos") +
  ggplot2::geom_smooth(method = "lm", color = "blue") +
  ggplot2::labs(title = "Regressão linear",
                x = "Variável Independente (X)",
                y = "Variável Dependente (Y)") +
  ggplot2::theme_minimal()
