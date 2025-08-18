# Definir semente para reprodutibilidade
set.seed(42)

# Definir cor padrão para os gráficos
cor_padrao <- "lightblue"

# 11. Distribuição Beta (alpha = 2, beta = 5)
beta_data <- rbeta(100000, shape1 = 2, shape2 = 5)
p11 <- ggplot2::ggplot(data.frame(beta_data), ggplot2::aes(x = beta_data)) +
  ggdist::stat_halfeye(fill = cor_padrao,
                       color = "black",
                       alpha = 0.7) +
  ggplot2::labs(title = "Beta", x = "Valor", y = "Densidade") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 12. Distribuição Logística (mu = 0, s = 1)
logistica_data <- rlogis(100000, location = 0, scale = 1)
p12 <- ggplot2::ggplot(data.frame(logistica_data), ggplot2::aes(x = logistica_data)) +
  ggdist::stat_halfeye(fill = cor_padrao,
                       color = "black",
                       alpha = 0.7) +
  ggplot2::labs(title = "Logística", x = "Valor", y = "Densidade") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# Criar painel 2x2 com os gráficos p11 e p12
gridExtra::grid.arrange(p11, p12, ncol = 2, nrow = 1)
