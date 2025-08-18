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

# Simular dados perdidos - MCAR
rct_mcar <- rct_data
rct_mcar[["Desfecho (pós)"]][sample(1:n, 30)] <- NA
rct_mcar$Idade[sample(1:n, 20)] <- NA

p1 <- naniar::gg_miss_upset(rct_mcar, nsets = 5)
p1
