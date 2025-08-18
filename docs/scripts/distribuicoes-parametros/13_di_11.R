# Geração de dados: distribuição normal
set.seed(123)
n <- 200
dados <- rnorm(n, mean = 50, sd = 10)

# Cálculo das medidas
media <- mean(dados)
variancia <- var(dados)
desvio_padrao <- sd(dados)
erro_padrao <- desvio_padrao / sqrt(n)
amplitude <- max(dados) - min(dados)
iqr <- IQR(dados)

# Criar dataframe com os dados
df <- data.frame(valor = dados)

# Plotar histograma com densidade
ggplot2::ggplot(df, ggplot2::aes(x = valor)) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ..density..),
    bins = 30,
    fill = "lightblue",
    color = "black",
    alpha = 0.6
  ) +
  ggplot2::geom_density(color = "darkblue", size = 1) +
  
  # Média
  ggplot2::geom_vline(ggplot2::aes(xintercept = media, color = "Média"), size = 1.2) +
  
  # Desvio padrão
  ggplot2::geom_vline(
    ggplot2::aes(xintercept = media + desvio_padrao, color = "Desvio Padrão +1σ"),
    size = 1,
    linetype = "dashed"
  ) +
  ggplot2::geom_vline(
    ggplot2::aes(xintercept = media - desvio_padrao, color = "Desvio Padrão -1σ"),
    size = 1,
    linetype = "dashed"
  ) +
  
  # Erro padrão
  ggplot2::geom_vline(
    ggplot2::aes(xintercept = media + erro_padrao, color = "Erro Padrão +SE"),
    size = 1,
    linetype = "dotted"
  ) +
  ggplot2::geom_vline(
    ggplot2::aes(xintercept = media - erro_padrao, color = "Erro Padrão -SE"),
    size = 1,
    linetype = "dotted"
  ) +
  
  # Intervalo interquartil (IQR)
  ggplot2::geom_vline(
    ggplot2::aes(xintercept = quantile(dados, 0.25), color = "Q1 (25%)"),
    size = 1,
    linetype = "dotdash"
  ) +
  ggplot2::geom_vline(
    ggplot2::aes(xintercept = quantile(dados, 0.75), color = "Q3 (75%)"),
    size = 1,
    linetype = "dotdash"
  ) +
  
  # Limites mínimo e máximo (Amplitude)
  ggplot2::geom_vline(
    ggplot2::aes(xintercept = min(dados), color = "Mínimo"),
    size = 0.8,
    linetype = "longdash"
  ) +
  ggplot2::geom_vline(
    ggplot2::aes(xintercept = max(dados), color = "Máximo"),
    size = 0.8,
    linetype = "longdash"
  ) +
  
  # Legenda
  ggplot2::scale_color_manual(
    values = c(
      "Desvio Padrão -1σ" = "orange",
      "Desvio Padrão +1σ" = "orange",
      "Erro Padrão -SE" = "purple",
      "Erro Padrão +SE" = "purple",
      "Q1 (25%)" = "green",
      "Q3 (75%)" = "green",
      "Mínimo" = "black",
      "Máximo" = "black",
      "Média" = "red"
    ),
    breaks = c(
      "Erro Padrão -SE",
      "Erro Padrão +SE",
      "Q1 (25%)",
      "Q3 (75%)",
      "Desvio Padrão -1σ",
      "Desvio Padrão +1σ",
      "Mínimo",
      "Máximo",
      "Média"
    )
  ) +
  
  ggplot2::labs(
    title = "Visualização de Medidas de Dispersão",
    subtitle = paste0(
      "Média = ",
      round(media, 2),
      " | SD = ",
      round(desvio_padrao, 2),
      " | SE = ",
      round(erro_padrao, 2),
      " | Var = ",
      round(variancia, 2),
      " | IQR = ",
      round(iqr, 2),
      " | Amplitude = ",
      round(amplitude, 2)
    ),
    x = "Valor",
    y = "Densidade",
    color = "Medidas de Dispersão"
  ) +
  ggplot2::theme_minimal() +
  ggplot2::theme(legend.position = "bottom")
