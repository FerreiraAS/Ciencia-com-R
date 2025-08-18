# Generate data with given correlation
generate_data <- function(n, rho) {
  Sigma <- base::matrix(c(1, rho, rho, 1), ncol = 2)
  MASS::mvrnorm(n = n, mu = c(0, 0), Sigma = Sigma)
}

# Reproducibility
base::set.seed(123)
n <- 100

# Define correlation matrix for 25 panels (5x5), center = 0
rho_mat <- base::matrix(c(
  -0.99, -0.95, -0.90, -0.85, -0.80,
  -0.70, -0.60, -0.50, -0.40, -0.30,
  -0.20, -0.10,  0.00,  0.10,  0.20,
   0.30,  0.40,  0.50,  0.60,  0.70,
   0.80,  0.85,  0.90,  0.95,  0.99
), nrow = 5, byrow = TRUE)

# Build dataframe
layout_df <- base::do.call(base::rbind,
  base::lapply(base::seq_len(base::nrow(rho_mat)), function(r) {
    base::do.call(base::rbind,
      base::lapply(base::seq_len(base::ncol(rho_mat)), function(c) {
        rho <- rho_mat[r, c]
        m <- generate_data(n, rho)
        base::data.frame(
          x = m[,1],
          y = m[,2],
          rho = rho,
          row = base::factor(r, levels = 1:5),
          col = base::factor(c, levels = 1:5),
          label = base::sprintf("r = %.2f", rho)
        )
      })
    )
  })
)

# Plot
ggplot2::ggplot(layout_df, ggplot2::aes(x = x, y = y)) +
  ggplot2::geom_point(alpha = 0.7) +
  ggplot2::geom_smooth(method = "lm", se = FALSE, color = "gray40") +
  ggplot2::facet_grid(rows = ggplot2::vars(row), cols = ggplot2::vars(col), drop = FALSE) +
  ggplot2::labs(x = "X", y = "Y") +
  ggplot2::theme_minimal() +
  ggplot2::theme(
    strip.text        = ggplot2::element_blank(),
    panel.grid.major  = ggplot2::element_blank(),
    panel.grid.minor  = ggplot2::element_blank(),
    axis.line         = ggplot2::element_line(color = "black"),
    aspect.ratio      = 1,
    panel.spacing     = grid::unit(0.35, "lines"),
    plot.margin       = ggplot2::margin(10, 5, 10, 5)
  ) +
  ggplot2::geom_text(
    data = stats::aggregate(cbind(x, y) ~ label + row + col, layout_df, function(z) NA)[, c("label","row","col")],
    inherit.aes = FALSE,
    ggplot2::aes(x = -Inf, y = Inf, label = label),
    hjust = -0.05, vjust = 1.1
  )
