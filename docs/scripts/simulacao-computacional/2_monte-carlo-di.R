# reproducibilidade
set.seed(42)

# Tamanhos de amostra
sizes <- c(10, 100, 1000, 10000)

# Dados simulados
normal_data <- lapply(sizes, function(n) {
  tibble::tibble(
    x = rnorm(n, mean = 0, sd = 1),
    n = factor(paste0("n = ", n), levels = paste0("n = ", sizes))
  )
}) %>% dplyr::bind_rows()

# PDF teórica Normal(0,1)
x_seq <- seq(-4, 4, length.out = 400)
pdf_norm <- tibble::tibble(x = x_seq, y = dnorm(x_seq, mean = 0, sd = 1))

# Figura 2x2
normal_plot_2x2 <-
  ggplot2::ggplot(normal_data, ggplot2::aes(x = x)) +
  ggplot2::geom_histogram(ggplot2::aes(y = ..density..), bins = 30, fill = "skyblue", color = "white") +
  ggplot2::geom_line(
    data = pdf_norm, ggplot2::aes(x = x, y = y),
    linewidth = 1, inherit.aes = FALSE
  ) +
  ggplot2::facet_wrap(~ n, ncol = 2) +
  ggplot2::coord_cartesian(xlim = c(-4, 4)) +
  ggplot2::labs(
    title = "Convergência do histograma → Normal(0,1)",
    x = "Valor", y = "Densidade"
  ) +
  ggplot2::theme_minimal(base_size = 14)

normal_plot_2x2
