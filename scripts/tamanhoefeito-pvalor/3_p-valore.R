# Criar grid 10x10 (100 quadrados)
set.seed(42)  # Para reprodutibilidade
grid <- expand.grid(x = 1:10, y = 1:10)

# Criar vetor de cor com todos brancos
grid$cor <- "branco"

# Selecionar aleatoriamente 5 índices para serem cinza escuro
cinzas <- sample(1:100, 5)
grid$cor[cinzas] <- "cinza escuro"

# Criar o gráfico
ggplot2::ggplot(grid, ggplot2::aes(x = x, y = y, fill = cor)) +
  ggplot2::geom_tile(color = "black") +
  ggplot2::scale_fill_manual(values = c("cinza escuro" = "gray30", "branco" = "white")) +
  ggplot2::coord_fixed() +
  ggplot2::theme_minimal() +
  ggplot2::theme(axis.title = ggplot2::element_blank(),
        axis.text = ggplot2::element_blank(),
        axis.ticks = ggplot2::element_blank(),
        legend.position = "none") +
  ggplot2::ggtitle("Visualização de p < 0,05 (5 quadrados aleatórios em 100)")
