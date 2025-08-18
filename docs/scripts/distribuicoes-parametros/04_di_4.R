# Definir semente para reprodutibilidade
set.seed(42)

# Definir cor padrão para os gráficos
cor_padrao <- "lightblue"

# 4. Aproximação Binomial (n = 100, p = 0.5)
binomial_data <- rbinom(100000, size = 100, prob = 0.5)
p4 <- ggplot2::ggplot(data.frame(binomial_data), ggplot2::aes(x = binomial_data)) +
  ggdist::stat_halfeye(fill = cor_padrao,
                       color = "black",
                       alpha = 0.7) +
  ggplot2::labs(title = "Aproximação Binomial", x = "Sucessos", y = "Densidade") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 5. Aproximação Poisson (lambda = 5)
poisson_data <- rpois(100000, lambda = 5)
p5 <- ggplot2::ggplot(data.frame(poisson_data), ggplot2::aes(x = poisson_data)) +
  ggdist::stat_halfeye(fill = cor_padrao,
                       color = "black",
                       alpha = 0.7) +
  ggplot2::labs(title = "Poisson", x = "Ocorrências", y = "Densidade") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# Criar painel 1x2 com os gráficos p4 e p5
gridExtra::grid.arrange(p4, p5, ncol = 2, nrow = 1)
