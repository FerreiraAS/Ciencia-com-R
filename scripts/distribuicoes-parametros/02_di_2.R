# Definir semente para reprodutibilidade
set.seed(42)

# Definir cor padrão para os gráficos
cor_padrao <- "lightblue"

# 1. Distribuição Uniforme (a = 0, b = 1)
uniforme_data <- runif(1000000, min = 0, max = 1)
p1 <- ggplot2::ggplot(data.frame(uniforme_data), ggplot2::aes(x = uniforme_data)) +
  ggdist::stat_halfeye(fill = cor_padrao,
                       color = "black",
                       alpha = 0.7) +
  ggplot2::labs(title = "Uniforme", x = "Valor", y = "Densidade") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 2. Distribuição Exponencial (lambda = 1)
exponencial_data <- rexp(1000000, rate = 1)
p2 <- ggplot2::ggplot(data.frame(exponencial_data),
                      ggplot2::aes(x = exponencial_data)) +
  ggdist::stat_halfeye(fill = cor_padrao,
                       color = "black",
                       alpha = 0.7) +
  ggplot2::labs(title = "Exponencial", x = "Valor", y = "Densidade") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# Criar painel 1x2 com os gráficos p1 e p2
gridExtra::grid.arrange(p1, p2, ncol = 2, nrow = 1)
