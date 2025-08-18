# Para reprodutibilidade
set.seed(42)

# Parâmetros da simulação
n_tests <- 100  # Número de testes
n_samples <- 30  # Tamanho da amostra em cada teste

# Simular 100 testes com amostras de 30 elementos
p_values <- numeric(n_tests)  # Vetor para armazenar os p-valores

for (i in 1:n_tests) {
  # Gerar uma amostra aleatória de uma distribuição normal
  sample_data <- rnorm(n_samples)
  
  # Realizar um teste t para a média da amostra (teste bilateral)
  test_result <- t.test(sample_data)
  
  # Armazenar o p-valor
  p_values[i] <- test_result$p.value
}

# Contar quantos p-valores são menores que 0,05
p_less_than_0_05 <- sum(p_values < 0.05)

# Criar gráfico de distribuição dos p-valores
ggplot2::ggplot(data.frame(p_values), ggplot2::aes(x = p_values)) +
  ggplot2::geom_histogram(binwidth = 0.01, fill = "lightblue", color = "black", alpha = 0.7) +
  ggplot2::geom_vline(xintercept = 0.05, color = "red", linetype = "dashed", size = 1) +
  ggplot2::annotate("text", x = 0.06, y = 15, label = "p < 0,05", color = "red", size = 5) +
  ggplot2::theme_minimal() +
  ggplot2::labs(
    title = expression("Distribuição dos p-valores com H"[0]*" verdadeira"),
    subtitle = paste("Número de testes com p < 0,05 (erro tipo I):", p_less_than_0_05, "de", n_tests, "\n"),
    x = "P-valor",
    y = "Frequência") +
  ggplot2::theme(axis.text = ggplot2::element_text(size = 12),
        axis.title = ggplot2::element_text(size = 14)) +
  ggplot2::scale_x_continuous(
  limits = c(0, 1),
  breaks = seq(0, 1, by = 0.25)
)
