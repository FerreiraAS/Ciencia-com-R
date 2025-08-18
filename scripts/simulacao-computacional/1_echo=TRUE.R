# Simulação de 1000 médias de amostras de tamanho 30 de uma N(0,1)
set.seed(123)
n_sim <- 1000
amostras <- replicate(n_sim, mean(rnorm(30, mean = 0, sd = 1)))
hist(
  amostras,
  main = "Distribuição das médias simuladas",
  xlab = "Média",
  col = "lightblue",
  border = "white"
)
