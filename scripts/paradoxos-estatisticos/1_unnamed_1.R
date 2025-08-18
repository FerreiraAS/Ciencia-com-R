# Define global shapes and colors
global_shapes <- c(16, 16)  # Circle and triangle
global_colors <- c("black", "gray50")  # Black and gray

# Function to generate data
generate_data <- function(n, r1, r2) {
  x <- c(rnorm(n / 2, mean = -1), rnorm(n / 2, mean = 1))
  y <- r1 * x + rnorm(n)
  
  # Introduce a third variable z that acts as a confounding variable
  z <- rep(c(0, 1), each = n / 2)
  y[z == 1] <- r2 * x[z == 1] + rnorm(sum(z))
  
  data.frame(x = x, y = y, z = z)
}

# Generate data
set.seed(123)
n <- 100
r1 <- 0.8
r2 <- -0.6
data <- generate_data(n, r1, r2)

# Calculate correlation coefficients
cor_aggregated <- cor(data$x, data$y)
cor_disaggregated <- by(data, data$z, function(df)
  cor(df$x, df$y))

# Define the limits for x and y axes
x_limits <- range(data$x)
y_limits <- range(data$y)

# Plot for aggregated trend
aggregated_plot <- ggplot2::ggplot(data, ggplot2::aes(x = x, y = y, color = factor(z)), shape = global_shapes) +
  ggplot2::geom_point(size = 2, shape = ifelse(data$z == 0, 16, 16)) +
  ggplot2::geom_smooth(
    method = "lm",
    se = FALSE,
    ggplot2::aes(group = 1),
    color = "blue"
  ) +
  ggplot2::labs(
    title = "População agregada",
    x = "X",
    y = "Y",
    color = "Z"
  ) +
  ggplot2::scale_color_manual(values = global_colors) +
  ggplot2::theme_minimal() +
  ggplot2::xlim(x_limits) +
  ggplot2::ylim(y_limits) +
  ggplot2::theme(
    aspect.ratio = 1,
    legend.position = "right",
    plot.title = ggplot2::element_text(hjust = 0.5, size = 10)
  )

# Plot for disaggregated trends
disaggregated_plots <- lapply(unique(data$z), function(z_value) {
  ggplot2::ggplot(data[data$z == z_value, ], ggplot2::aes(x = x, y = y, color = factor(z))) +
    ggplot2::geom_point(
      size = 2,
      shape = ifelse(z_value == 0, 16, 16),
      color = ifelse(z_value == 0, "black", "gray50")
    ) +
    ggplot2::geom_smooth(
      method = "lm",
      se = FALSE,
      ggplot2::aes(group = 1),
      color = "blue"
    ) +
    ggplot2::labs(
      title = paste("Subpopulação desagregada (Z=", z_value, ")", sep = ""),
      x = "X",
      y = "Y"
    ) +
    ggplot2::scale_color_manual(values = global_colors) +
    ggplot2::theme_minimal() +
    ggplot2::xlim(x_limits) +
    ggplot2::ylim(y_limits) +
    ggplot2::theme(
      aspect.ratio = 1,
      plot.title = ggplot2::element_text(size = 10)
    )
})

aggregated_plot <- aggregated_plot + 
  ggplot2::theme(plot.margin = ggplot2::margin(2, 2, 2, 2))

disaggregated_plots <- lapply(disaggregated_plots, function(p) {
  p + ggplot2::theme(plot.margin = ggplot2::margin(2, 2, 2, 2))
})

# Arrange plots
cowplot::plot_grid(
  aggregated_plot,
  cowplot::plot_grid(plotlist = disaggregated_plots, align = "v"),
  ncol = 1,
  align = "v",
  axis = "lr"
)
