# para reprodutibilidade
set.seed(42)

# Definir cor padrão para os gráficos
cor_padrao <- "lightblue"

# 6. Distribuição t-Student (df = 10)
tstudent_data <- rt(100000, df = 10)
p6 <- ggplot2::ggplot(data.frame(tstudent_data), ggplot2::aes(x = tstudent_data)) +
  ggdist::stat_halfeye(fill = cor_padrao,
                       color = "black",
                       alpha = 0.7) +
  ggplot2::labs(title = "t-Student", x = "Valor", y = "Densidade") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 7. Distribuição Qui-Quadrado (df = 10)
chi_squared_data <- rchisq(100000, df = 10)
p7 <- ggplot2::ggplot(data.frame(chi_squared_data),
                      ggplot2::aes(x = chi_squared_data)) +
  ggdist::stat_halfeye(fill = cor_padrao,
                       color = "black",
                       alpha = 0.7) +
  ggplot2::labs(title = "Qui-Quadrado", x = "Valor", y = "Densidade") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# Criar painel 1x2 com os gráficos p6 e p7
gridExtra::grid.arrange(p6, p7, ncol = 2, nrow = 1)
