# Criar um conjunto de dados de exemplo
dados <- data.frame(
  Grupo = rep(c("A", "B", "C"), each = 3),
  Categoria = rep(c("X", "Y", "Z"), times = 3),
  Contagem = c(30, 20, 10, 25, 15, 5, 20, 10, 10)
)

# Frequência por Categoria (soma total de contagens)
dados_barras <- dados %>%
  dplyr::group_by(Categoria) %>%
  dplyr::summarise(Total = sum(Contagem))

ggplot2::ggplot(dados, ggplot2::aes(x = Grupo, y = Contagem, fill = Categoria)) +
  ggplot2::geom_bar(stat = "identity") +
  ggplot2::labs(title = "Gráfico de Barras Empilhadas",
       x = "Grupo", y = "Contagem") +
  ggplot2::theme_minimal()
