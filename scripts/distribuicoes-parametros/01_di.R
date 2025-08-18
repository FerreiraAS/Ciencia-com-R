# Definir semente para reprodutibilidade
set.seed(42)

# Definir cor padrão para os gráficos
cor_padrao <- "lightblue"

# 1. Distribuição Bernoulli (p = 0.5)
bernoulli_data <- rbinom(1000, 1, 0.5)
p1 <- ggplot2::ggplot(data.frame(bernoulli_data), ggplot2::aes(x = bernoulli_data)) +
  ggplot2::geom_bar(stat = "count", fill = cor_padrao) +
  ggplot2::labs(title = "Bernoulli", x = "Resultado", y = "Frequência") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 2. Distribuição Binomial (n = 10, p = 0.5)
binomial_data <- rbinom(1000, 10, 0.5)
p2 <- ggplot2::ggplot(data.frame(binomial_data), ggplot2::aes(x = binomial_data)) +
  ggplot2::geom_bar(stat = "count", fill = cor_padrao) +
  ggplot2::labs(title = "Binomial", x = "Sucessos", y = "Frequência") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 3. Distribuição Geométrica (p = 0.5)
geom_data <- rgeom(1000, 0.5) # número de tentativas até o 1º sucesso com p = 0.5
p3 <- ggplot2::ggplot(data.frame(geom_data), ggplot2::aes(x = geom_data)) +
  ggplot2::geom_bar(stat = "count", fill = cor_padrao) +
  ggplot2::labs(title = "Geométrica", x = "Tentativas até o Sucesso", y = "Frequência") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 4. Distribuição Binomial Negativa (r = 3, p = 0.5)
neg_binomial_data <- rnbinom(1000, 3, 0.5)
p4 <- ggplot2::ggplot(data.frame(neg_binomial_data),
                      ggplot2::aes(x = neg_binomial_data)) +
  ggplot2::geom_bar(stat = "count", fill = cor_padrao) +
  ggplot2::labs(title = "Binomial Negativa", x = "Tentativas até o 3º Sucesso", y = "Frequência") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 5. Distribuição Hipergeométrica (m = 10, n = 30, k = 5)
hypergeom_data <- rhyper(1000, 10, 30, 5)
p5 <- ggplot2::ggplot(data.frame(hypergeom_data), ggplot2::aes(x = hypergeom_data)) +
  ggplot2::geom_bar(stat = "count", fill = cor_padrao) +
  ggplot2::labs(title = "Hipergeométrica", x = "Sucessos", y = "Frequência") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 6. Distribuição Poisson (lambda = 3)
poisson_data <- rpois(1000, 3)
p6 <- ggplot2::ggplot(data.frame(poisson_data), ggplot2::aes(x = poisson_data)) +
  ggplot2::geom_bar(stat = "count", fill = cor_padrao) +
  ggplot2::labs(title = "Poisson", x = "Eventos", y = "Frequência") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 7. Distribuição Uniforme Discreta (min = 1, max = 6)
uniform_data <- sample(1:6, 1000, replace = TRUE)
p7 <- ggplot2::ggplot(data.frame(uniform_data), ggplot2::aes(x = uniform_data)) +
  ggplot2::geom_bar(stat = "count", fill = cor_padrao) +
  ggplot2::labs(title = "Uniforme Discreta", x = "Resultado", y = "Frequência") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# 8. Distribuição Multinomial (probabilidades: 1/3, 1/3, 1/3)
# Gerar 1000 experimentos com 3 resultados possíveis e 10 tentativas em cada experimento
multinomial_data <- rmultinom(1000, 10, prob = c(1 / 3, 1 / 3, 1 / 3))

# Convertendo os dados para um formato adequado para ggplot
multinomial_df <- data.frame(Result = rep(1:3, times = 1000),
                             Freq = as.vector(multinomial_data))

# Criando o gráfico
p8 <- ggplot2::ggplot(multinomial_df, ggplot2::aes(x = factor(Result), y = Freq)) +
  ggplot2::geom_bar(stat = "identity", fill = cor_padrao) +
  ggplot2::labs(title = "Multinomial", x = "Resultado", y = "Frequência") +
  ggplot2::theme_minimal() +
  ggplot2::theme(text = ggplot2::element_text(size = 8))

# Criar painel 2x4 com todos os gráficos
gridExtra::grid.arrange(p1, p2, p3, p4, p5, p6, p7, p8, ncol = 4, nrow = 2)
