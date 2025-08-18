# Gerar dados de exemplo
set.seed(123)
df <- base::expand.grid(Fator1 = c("A", "B"),
                        Fator2 = c("X", "Y"),
                        Rep = 1:15) |>
  dplyr::mutate(Y = stats::rnorm(dplyr::n(), 
                                 mean = dplyr::if_else(Fator1 == "A", 5, 7) + dplyr::if_else(Fator2 == "X", 0, 2), 
                                 sd = 1.5))

# Calcular estatísticas por grupo
summary_df <- df |>
  dplyr::group_by(Fator1, Fator2) |>
  dplyr::summarise(
    media = mean(Y),
    sd = stats::sd(Y),
    n = dplyr::n(),
    se = sd / sqrt(n),
    ic95 = 1.96 * se,
    .groups = "drop"
  )

# 1. Gráfico com apenas as médias
p1 <- ggplot2::ggplot(summary_df, ggplot2::aes(x = interaction(Fator1, Fator2), y = media, fill = Fator1)) +
  ggplot2::geom_bar(stat = "identity", position = ggplot2::position_dodge(), width = 0.6) +
  ggplot2::labs(title = "Média", y = "Média", x = "Grupo") +
  ggplot2::theme_minimal()

# 2. Gráfico com média + intervalo de confiança
p2 <- ggplot2::ggplot(summary_df, ggplot2::aes(x = interaction(Fator1, Fator2), y = media, fill = Fator1)) +
  ggplot2::geom_bar(stat = "identity", position = ggplot2::position_dodge(), width = 0.6) +
  ggplot2::geom_errorbar(ggplot2::aes(ymin = media - ic95, ymax = media + ic95), width = 0.2) +
  ggplot2::labs(
    title = "Média com Intervalo de Confiança",
    subtitle = "Barras de erro representam IC 95%",
    y = "Média", x = "Grupo"
  ) +
  ggplot2::theme_minimal()

# 3. Gráfico com média + pontos individuais
p3 <- ggplot2::ggplot(df, ggplot2::aes(x = interaction(Fator1, Fator2), y = Y, fill = Fator1)) +
  ggplot2::stat_summary(fun = mean, geom = "bar", width = 0.6, color = "black") +
  ggplot2::geom_jitter(position = ggplot2::position_jitter(width = 0.1), shape = 21, color = "black", size = 2, alpha = 0.6) +
  ggplot2::labs(
    title = "Média e Pontos Individuais",
    subtitle = "Pontos representam dados individuais",
    y = "Valor", x = "Grupo"
  ) +
  ggplot2::guides(fill = "none") +  # <- oculta a legenda
  ggplot2::theme_minimal()

# Empilhar os gráficos verticalmente
library(patchwork)
(p1 / p2 / p3) + patchwork::plot_layout(guides = "collect")
