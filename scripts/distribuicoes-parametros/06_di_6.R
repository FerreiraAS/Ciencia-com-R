# Definir semente para reprodutibilidade
set.seed(42)

# Definir cor padrão para os gráficos
cor_padrao <- "lightblue"

# 8. Distribuição Weibull (shape = 1.5, scale = 1)
weibull_data <- rweibull(100000, shape = 1.5, scale = 1)
p8 <- ggplot2::ggplot(data.frame(weibull_data), ggplot2::aes(x = weibull_data)) +
  ggdist::stat_halfeye(fill = cor_padrao,
                       color = "black",
                       alpha = 0.7) +
  ggplot2::labs(title = "Weibull", x = "Valor", y = "Densidade") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 9. Distribuição Gama (shape = 5, scale = 1)
gama_data <- rgamma(100000, shape = 5, scale = 1)
p9 <- ggplot2::ggplot(data.frame(gama_data), ggplot2::aes(x = gama_data)) +
  ggdist::stat_halfeye(fill = cor_padrao,
                       color = "black",
                       alpha = 0.7) +
  ggplot2::labs(title = "Gama", x = "Valor", y = "Densidade") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 10. Distribuição Log-Normal (meanlog = 0, sdlog = 1)
log_normal_data <- rlnorm(100000, meanlog = 0, sdlog = 1)
p10 <- ggplot2::ggplot(data.frame(log_normal_data),
                       ggplot2::aes(x = log_normal_data)) +
  ggdist::stat_halfeye(fill = cor_padrao,
                       color = "black",
                       alpha = 0.7) +
  ggplot2::labs(title = "Log-Normal", x = "Valor", y = "Densidade") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# Criar painel 2x2 com os gráficos p8, p9 e p10
gridExtra::grid.arrange(p8, p9, p10, ncol = 3, nrow = 1)
