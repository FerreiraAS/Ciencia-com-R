# simulate X
set.seed(123)
X <- rnorm(100, mean = 50, sd = 10)

# simulate a binary outcome Y based on X
prob <- 1 / (1 + exp(-( -5 + 0.1 * X)))  # logistic function
Y <- rbinom(100, size = 1, prob = prob) # sample Y ~ Bernoulli(prob)

# create a dataframe
data <- data.frame(X, Y)

# create the logistic regression model
model <- glm(Y ~ X, data = data, family = binomial)

# plot the regression line
ggplot2::ggplot(data, ggplot2::aes(x = X, y = Y)) +
  ggplot2::geom_point() +
  ggplot2::geom_smooth(method = "glm", method.args = list(family = "binomial"), color = "blue") +
  ggplot2::labs(title = "Regressão logística",
       x = "Variável Independente (X)",
       y = "Probabilidade de Sucesso (Y)") +
  ggplot2::theme_minimal()
