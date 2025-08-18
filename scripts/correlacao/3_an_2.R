library(dplyr)
anscombe.dt <- datasets::anscombe
anscombe.dt$ID <- seq(1, dim(anscombe.dt)[1])

# exibe o gráfico
datLong <- data.frame(
  group  = paste0("Quarteto ", rep(1:4, each = 11)),
  x = unlist(anscombe.dt[, c(1:4)]),
  y = unlist(anscombe.dt[, c(5:8)])
)
rownames(datLong) <- NULL
ggplot2::ggplot(data = datLong,
                mapping = ggplot2::aes(x = x, y = y, group = group)) +
  ggplot2::geom_point(fill = "black") +
  ggplot2::geom_smooth(
    method = "lm",
    se = FALSE,
    fullrange = TRUE,
    colour = "grey"
  ) +
  ggplot2::facet_wrap(~ group) +
  ggplot2::theme(
    panel.background = ggplot2::element_blank(),
    panel.grid.major = ggplot2::element_blank(),
    panel.grid.minor = ggplot2::element_blank(),
    axis.line = ggplot2::element_line(colour = "black")
  ) +
  ggplot2::theme(legend.key = ggplot2::element_blank()) +
  ggplot2::coord_fixed()
