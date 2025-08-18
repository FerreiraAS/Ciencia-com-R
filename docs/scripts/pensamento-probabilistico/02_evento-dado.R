# para reprodutibilidade
set.seed(1234)

# simula 1 lançamento de 1 moeda
evento.coin <- tidydice::plot_coin(tidydice::flip_coin(
  times = 1,
  rounds = 1,
  success = c(1)
),
fill_success = "grey") + ggplot2::ggtitle("") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
  ggplot2::annotate(
    "text",
    x = c(1.45),
    y = c(1.45),
    label = c("cara"),
    color = "black",
    size = 6,
    fontface = "bold",
    hjust = 0.5,
    vjust = 0.5
  )

espaço.amostral.coin <- tidydice::plot_coin(população.coin, fill_success = "grey") + ggplot2::ggtitle("") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
  ggplot2::annotate(
    "text",
    x = c(1.45, 2.45),
    y = c(1.45, 1.45),
    label = factor(
      população.coin$result,
      levels = c(1, 2),
      labels = c("cara", "coroa")
    ),
    color = "black",
    size = 6,
    fontface = "bold",
    hjust = 0.5,
    vjust = 0.5
  )

# simula 1 lançamento de 1 dado
evento.dice <- tidydice::plot_dice(tidydice::roll_dice(
  times = 1,
  rounds = 1,
  success = 4
),
fill_success = "grey") + ggplot2::ggtitle("") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

espaço.amostral.dice <- tidydice::plot_dice(população.dice, fill_success = "grey") + ggplot2::ggtitle("") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

gridExtra::grid.arrange(
  evento.coin,
  espaço.amostral.coin,
  evento.dice,
  espaço.amostral.dice,
  nrow = 2,
  ncol = 2
)
