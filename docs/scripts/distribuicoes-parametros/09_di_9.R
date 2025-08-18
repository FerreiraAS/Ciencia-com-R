scaleFUN <- function(x)
  sprintf("%.2f", x)

# normal
d1 <- ggfortify::ggdistribution(dnorm,
                                seq(-3, 3, 0.1),
                                mean = 0,
                                sd = 1,
                                main = "Distribuição de probabilidade") + ggplot2::scale_y_continuous(labels = scaleFUN) +
  ggplot2::theme_minimal() +
  ggplot2::theme(aspect.ratio = 1,
                 text = ggplot2::element_text(size = 8))

p1 <- ggfortify::ggdistribution(pnorm,
                                seq(-3, 3, 0.1),
                                mean = 0,
                                sd = 1,
                                main = "Função de distribuição cumulativa") + ggplot2::scale_y_continuous(labels = scaleFUN) +
  ggplot2::theme_minimal() +
  ggplot2::theme(aspect.ratio = 1,
                 text = ggplot2::element_text(size = 8))

ggpubr::ggarrange(
  d1,
  p1,
  heights = c(1, 1),
  widths = c(1, 1),
  nrow = 1,
  ncol = 2,
  align = "h"
)
