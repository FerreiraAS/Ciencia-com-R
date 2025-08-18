# para reprodutibilidade
set.seed(1234)

# simula 1 lançamento de 1 dado
evento <- tidydice::plot_dice(tidydice::roll_dice(
  times = 1,
  rounds = 1,
  success = 4
),
fill_success = "grey") + ggplot2::ggtitle("Evento") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

# simula 1 lançamento de 1 dado
p1 <- tidydice::plot_dice(tidydice::roll_dice(
  times = 1,
  rounds = 1,
  success = 4
),
fill_success = "grey") + ggplot2::ggtitle("1 lançamento de 1 dado") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

# simula 3 lançamentos de 1 dado
p3 <- tidydice::plot_dice(tidydice::roll_dice(
  times = 3,
  rounds = 1,
  success = 4
),
fill_success = "grey") + ggplot2::ggtitle("3 lançamentos de 1 dado") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

# simula 10 lançamentos de 1 dado
p10 <- tidydice::plot_dice(tidydice::roll_dice(
  times = 10,
  rounds = 1,
  success = 4
),
fill_success = "grey") + ggplot2::ggtitle("10 lançamentos de 1 dado") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

gridExtra::grid.arrange(evento, p1, evento, p3, evento, p10, nrow = 3)
