# para reprodutibilidade
set.seed(1234)

# simula o lançamento de moeda
população.coin <- tidydice::flip_coin(times = 1000,
                                      rounds = 1,
                                      success = c(1))
# remove lances duplicados
população.coin <- população.coin[!duplicated(população.coin$result), ]
# coloca em ordem
população.coin <- população.coin[order(população.coin$result), ]

espaço.amostral.coin <- tidydice::plot_coin(população.coin, fill_success = NA, ) + ggplot2::ggtitle("") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5)) +
  ggplot2::annotate(
    "text",
    x = c(1.45, 2.45),
    y = c(1.45, 1.45),
    label = c("cara", "coroa"),
    color = "black",
    size = 6,
    fontface = "bold",
    hjust = 0.5,
    vjust = 0.5
  )

# simula o lançamento de dado
população.dice <- tidydice::roll_dice(times = 1000,
                                      rounds = 1,
                                      success = 4)
# remove lances duplicados
população.dice <- população.dice[!duplicated(população.dice$result), ]
# coloca em ordem
população.dice <- população.dice[order(população.dice$result), ]

espaço.amostral.dice <- tidydice::plot_dice(população.dice, fill_success = NA) + ggplot2::ggtitle("") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

gridExtra::grid.arrange(espaço.amostral.coin, espaço.amostral.dice, nrow = 2)
