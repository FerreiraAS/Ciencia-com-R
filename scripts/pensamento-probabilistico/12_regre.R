# simula uma distribuição normal
set.seed(1234)
amostra <- data.frame(Variável = rnorm(100000, mean = 120, sd = 1))

# seleciona um dado aleatório da amostra
dado1 <- round(sample(amostra$Variável, 1), digits = 0)

# seleciona outro dado aleatório da amostra
dado2 <- round(sample(amostra$Variável, 1), digits = 0)
