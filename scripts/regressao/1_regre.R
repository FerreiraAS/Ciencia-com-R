# simulate X
set.seed(123)
X <- rnorm(100, mean = 50, sd = 10)

# simulate Y based on X
Y <- 5 + 2 * X + rnorm(100, mean = 0, sd = 30)

# create a dataframe
data <- data.frame(X, Y)

# create the regression model
model <- lm(Y ~ X, data = data)

ggplot2::ggplot(data, ggplot2::aes(x = X, y = Y)) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "lm",
                       color = "blue",   # cor da linha
                       fill = "grey70",  # cor da área IC95%
                       se = TRUE) +      # mostra o intervalo de confiança
  ggplot2::labs(title = "Regressão linear", 
                x = "Variável Independente (X)", 
                y = "Variável Dependente (Y)") +
  ggplot2::theme_minimal()
