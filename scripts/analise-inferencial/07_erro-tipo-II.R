# Reprodutibilidade
set.seed(42)

# Parâmetros da simulação
n_tests <- 100
n_samples <- 34  # Ajustado para obter ~80% de poder (20% de erro tipo II)
true_mean <- 0.5  # H₀ é falsa: média real ≠ 0

# Vetor para armazenar p-valores
p_values <- numeric(n_tests)

for (i in 1:n_tests) {
  # Gerar amostra de uma normal com média ≠ 0
  sample_data <- rnorm(n_samples, mean = true_mean, sd = 1)
  
  # Teste t contra H₀: mu = 0
  test_result <- t.test(sample_data, mu = 0)
  
  # Armazenar p-valor
  p_values[i] <- test_result$p.value
}

# Contar quantos testes NÃO rejeitaram H₀ (erro tipo II)
p_greater_than_0_05 <- sum(p_values > 0.05)
erro_tipo_II_percentual <- round(p_greater_than_0_05 / n_tests * 100)

# Gráfico
ggplot2::ggplot(data.frame(p_values), ggplot2::aes(x = p_values)) +
  ggplot2::geom_histogram(binwidth = 0.01, fill = "lightcoral", color = "black", alpha = 0.7) +
  ggplot2::geom_vline(xintercept = 0.05, color = "red", linetype = "dashed", size = 1) +
  ggplot2::annotate("text", x = 0.25, y = 15,
                    label = paste0("Erro tipo II (p > 0,05): ", erro_tipo_II_percentual, "%"),
                    color = "red", size = 5) +
  ggplot2::theme_minimal() +
  ggplot2::labs(
    title = expression("Distribuição dos p-valores com H"[0]*" falsa"),
    subtitle = paste("Número de testes com p > 0,05 (erro tipo II):", p_greater_than_0_05, "de", n_tests, "\n"),
    x = "P-valor",
    y = "Frequência"
  ) +
  ggplot2::theme(axis.text = ggplot2::element_text(size = 12),
                 axis.title = ggplot2::element_text(size = 14)) +
  ggplot2::scale_x_continuous(
  limits = c(0, 1),
  breaks = seq(0, 1, by = 0.25)
)
