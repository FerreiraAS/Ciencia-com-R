# para reprodutibilidade
set.seed(1234)

# simula o lançamento de dado
população <- tidydice::roll_dice(times = 1000,
                                 rounds = 1,
                                 success = c(3, 4))
# remove lances duplicados
população <- população[!duplicated(população$result), ]
# coloca em ordem
população <- população[order(população$result), ]

espaço.amostral <- tidydice::plot_dice(população, fill_success = "grey") + ggplot2::ggtitle("") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

# seleciona espaço de eventos
população <- população[população$result == 3 |
                         população$result == 4, ]

espaço.eventos <- tidydice::plot_dice(população, fill_success = "grey") + ggplot2::ggtitle("") +
  ggplot2::theme(plot.title = ggplot2::element_text(hjust = 0.5))

gridExtra::grid.arrange(espaço.eventos, espaço.amostral, nrow = 2)
