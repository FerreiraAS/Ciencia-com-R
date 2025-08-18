# Simular matriz de correlação
set.seed(2)
dados <- data.frame(
  A = stats::rnorm(50),
  B = stats::rnorm(50, mean = 5),
  C = stats::rnorm(50, mean = 10, sd = 3)
)
matriz_cor <- stats::cor(dados)

# Converter para formato longo e renomear variáveis
library(reshape2)
dados_long <- reshape2::melt(matriz_cor)
names(dados_long) <- c("Variável 1", "Variável 2", "Correlação")

# Heatmap com nomes atualizados (sem aspas em aes)
ggplot2::ggplot(dados_long, ggplot2::aes(x = `Variável 1`, y = `Variável 2`, fill = Correlação)) +
  ggplot2::geom_tile(color = "white") +
  ggplot2::scale_fill_gradient2(low = "blue", high = "red", mid = "white",
                                midpoint = 0, limit = c(-1, 1), name = "Correlação") +
  ggplot2::labs(title = "Mapa de Calor da Correlação entre Variáveis") +
  ggplot2::theme_minimal()
