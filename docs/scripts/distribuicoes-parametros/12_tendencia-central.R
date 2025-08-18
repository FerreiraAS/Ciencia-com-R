# Função para gerar um dataframe com a densidade e os valores de média, mediana e moda
gerar_dados <- function(tipo_dist) {
  set.seed(123)  # Para reprodutibilidade
  n <- 10000
  
  if (tipo_dist == "assimetria_positiva") {
    x <- rlnorm(n, meanlog = 0, sdlog = 0.5)
    titulo <- "Assimetria Positiva"
  } else if (tipo_dist == "normal") {
    x <- rnorm(n, mean = 0, sd = 1)
    titulo <- "Distribuição Normal (Gaussiana)"
  } else if (tipo_dist == "assimetria_negativa") {
    x <- -rlnorm(n, meanlog = 0, sdlog = 0.5)
    titulo <- "Assimetria Negativa"
  }
  
  # Estimar a moda com base no pico da densidade
  d <- density(x)
  moda <- d$x[which.max(d$y)]
  
  data.frame(
    x = x,
    media = mean(x),
    mediana = median(x),
    moda = moda,
    titulo = titulo
  )
}

# Gerar os conjuntos de dados
dados_pos <- gerar_dados("assimetria_positiva")
dados_norm <- gerar_dados("normal")
dados_neg <- gerar_dados("assimetria_negativa")

# Função para plotar cada distribuição
plotar_distribuicao <- function(dados) {
  ggplot2::ggplot(dados, ggplot2::aes(x = x)) +
    ggplot2::geom_density(fill = "lightblue", alpha = 0.6) +
    ggplot2::geom_vline(
      ggplot2::aes(xintercept = media),
      color = "red",
      linetype = "dashed",
      size = 1
    ) +
    ggplot2::geom_vline(
      ggplot2::aes(xintercept = mediana),
      color = "blue",
      linetype = "dotted",
      size = 1
    ) +
    ggplot2::geom_vline(
      ggplot2::aes(xintercept = moda),
      color = "darkgreen",
      linetype = "solid",
      size = 1
    ) +
    ggplot2::labs(
      title = unique(dados$titulo),
      x = "Valor",
      y = "Densidade",
      subtitle = "Vermelho: Média | Azul: Mediana | Verde: Moda"
    ) +
    ggplot2::theme_minimal()
}

# Criar os gráficos individuais
g1 <- plotar_distribuicao(dados_pos)
g2 <- plotar_distribuicao(dados_norm)
g3 <- plotar_distribuicao(dados_neg)

# Combinar os gráficos em um painel
gridExtra::grid.arrange(g1, g2, g3, nrow = 3)
