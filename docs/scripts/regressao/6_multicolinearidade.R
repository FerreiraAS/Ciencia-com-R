# Set the seed for reproducibility
set.seed(123)

# Generate an independent variable
X1 <- rnorm(100, mean = 50, sd = 10)

# Generate a second variable that is highly correlated with X1
X2 <- 0.8 * X1 + rnorm(100, mean = 0, sd = 5)

# Generate a third variable that is not correlated with X1 or X2
X3 <- rnorm(100, mean = 30, sd = 5)

# Combine the variables into a dataframe
data <- data.frame(X1, X2, X3)

# Create the customized grid plot
GGally::ggpairs(
  data, 
  lower = list(continuous = GGally::wrap("smooth", method = "lm")),
  diag = list(continuous = "densityDiag"),
  upper = list(continuous = "cor")
) +
  ggplot2::theme(
    panel.background = ggplot2::element_blank(),
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    axis.line = ggplot2::element_line(color = "black")
  )
