# Reprodutibilidade
set.seed(42)

# Cor padrão
cor_padrao <- "lightblue"

# 1. Unimodal
dados_uni <- rnorm(100000, mean = 0, sd = 1)
df_uni <- data.frame(valor = dados_uni, grupo = "Unimodal")

# 2. Bimodal
dados_bi <- c(rnorm(50000, mean = -1, sd = 0.8), rnorm(50000, mean = 1, sd = 0.8))
df_bi <- data.frame(valor = dados_bi, grupo = "Bimodal")

# 3. Multimodal
dados_multi <- c(rnorm(33333, mean = -2, sd = 0.5),
                 rnorm(33334, mean = 0, sd = 0.4),
                 rnorm(33333, mean = 2, sd = 0.5))
df_multi <- data.frame(valor = dados_multi, grupo = "Multimodal")

# Juntar os dados
dados_todos <- rbind(df_uni, df_bi, df_multi)

# Reordenar os níveis do fator explicitamente
dados_todos$grupo <- factor(dados_todos$grupo,
                            levels = rev(c("Unimodal", "Bimodal", "Multimodal")))

# Plot com stat_halfeye (sem slab_type)
p <- ggplot2::ggplot(dados_todos, ggplot2::aes(x = valor, y = grupo)) +
  ggdist::stat_halfeye(
    ggplot2::aes(thickness = ggplot2::after_stat(pdf)),
    fill = cor_padrao,
    color = "black",
    alpha = 0.7
  ) +
  ggplot2::labs(
    title = "Distribuições Unimodal, Bimodal e Multimodal",
    x = "Valor", y = NULL
  ) +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 9))

# Mostrar gráfico
p
