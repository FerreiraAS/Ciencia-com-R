# para reproduzir o exemplo
set.seed(123)

# Simulação de dados de um RCT
n <- 200
rct_data <- data.frame(
  id = 1:n,
  Grupo = sample(c("Controle", "Intervenção"), n, replace = TRUE),
  Idade = sample(40:75, n, replace = TRUE),
  Sexo = sample(c("M", "F"), n, replace = TRUE),
  "Desfecho (pré)" = rnorm(n, mean = 50, sd = 10),
  "Desfecho (pós)" = rnorm(n, mean = 55, sd = 12),
  check.names = FALSE
)

# Simular dados perdidos - MNAR
rct_mnar <- rct_data
rct_mnar[["Desfecho (pós)"]][rct_mnar[["Desfecho (pós)"]] > 60 &
                               runif(n) < 0.5] <- NA
rct_mnar[["Desfecho (pré)"]][rct_mnar[["Desfecho (pré)"]] < 45 &
                               runif(n) < 0.4] <- NA

# Visualização dos padrões de dados ausentes
graphics::par(mar = c(5, 4, 4, 2) + 0.1)

p3 <- naniar::gg_miss_upset(rct_mnar, nsets = 5)
p3
