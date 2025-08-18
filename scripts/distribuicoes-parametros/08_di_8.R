# Definir semente para reprodutibilidade
set.seed(42)

# Definir cor padrão para os gráficos
cor_padrao <- "lightblue"

# 13. Distribuição Pareto (shape = 2, scale = 1)
# Gerar a distribuição Pareto usando a função rpareto
pareto_data <- actuar::rpareto(100, shape = 2, scale = 1)
p13 <- ggplot2::ggplot(data.frame(pareto_data), ggplot2::aes(x = pareto_data)) +
  ggdist::stat_halfeye(fill = cor_padrao,
                       color = "black",
                       alpha = 0.7) +
  ggplot2::labs(title = "Pareto", x = "Valor", y = "Densidade") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# Criar painel 1x1 com os gráficos p13
gridExtra::grid.arrange(p13, ncol = 1, nrow = 1)
