# Definir semente para reprodutibilidade
set.seed(42)

# Definir cor padrão para os gráficos
cor_padrao <- "lightblue"

# 3. Distribuição Normal (mu = 0, sigma = 1)
normal_data <- rnorm(100000, mean = 0, sd = 1)
p3 <- ggplot2::ggplot(data.frame(normal_data), ggplot2::aes(x = normal_data)) +
ggdist::stat_halfeye(fill = cor_padrao,
color = "black",
alpha = 0.7) +
ggplot2::labs(title = "Normal", x = "Valor", y = "Densidade") +
ggplot2::theme_minimal() +
ggplot2::theme(text = ggplot2::element_text(size = 8))

# Criar painel 1x1 com os gráficos p1
gridExtra::grid.arrange(p3, ncol = 1, nrow = 1)
