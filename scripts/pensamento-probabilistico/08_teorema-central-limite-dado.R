# para garantir a reprodutibilidade
set.seed(1234)

# carrega os pacotes
library(dplyr)

# simula o lançamento de 1 dado B vezes
N <- 100
população <- data.frame(Variável = tidydice::roll_dice(times = N)$result)

# histograma de densidade da lançamentos
histograma_pop <-
  ggplot2::ggplot(população, ggplot2::aes(x = Variável)) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    binwidth = 1,
    boundary = 0,
    fill = "grey",
    color = "black",
    alpha = 0.5
  ) +
  ggplot2::geom_density() +
  ggplot2::labs(
    title = paste0(
      "População (N = ",
      N,
      ")",
      "\n",
      "média = ",
      round(mean(população$Variável), digits = 3),
      "\n",
      "desvio-padrão = ",
      round(sd(população$Variável), digits = 3)
    ),
    x = "Variável",
    y = "Densidade"
  ) +
  ggplot2::theme_bw() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(hjust = 0.5),
    axis.title = ggplot2::element_text(size = 12),
    axis.text = ggplot2::element_text(size = 10),
    axis.text.x = ggplot2::element_text(angle = 45, hjust = 1)
  )

B <- 100
# armazena as médias das amostras de tamanho B
reamostra <- data.frame(
  res.5 = rep(NA, B),
  res.50 = rep(NA, B),
  res.500 = rep(NA, B),
  res.5000 = rep(NA, B)
)
for (i in 1:B) {
  sub <- sample(x = população$Variável,
                size = 5,
                replace = TRUE)
  reamostra$res.5[i] <- mean(sub)
  sub <- sample(x = população$Variável,
                size = 50,
                replace = TRUE)
  reamostra$res.50[i] <- mean(sub)
  sub <- sample(x = população$Variável,
                size = 500,
                replace = TRUE)
  reamostra$res.500[i] <- mean(sub)
  sub <- sample(x = população$Variável,
                size = 5000,
                replace = TRUE)
  reamostra$res.5000[i] <- mean(sub)
}
names(reamostra) <- c(
  paste0(
    "Amostra (n = 5)",
    "\n",
    "média = ",
    round(mean(reamostra$res.5), digits = 3),
    "\n",
    "desvio-padrão = ",
    round(sd(reamostra$res.5), digits = 3)
  ),
  paste0(
    "Amostra (n = 50)",
    "\n",
    "média = ",
    round(mean(reamostra$res.50), digits = 3),
    "\n",
    "desvio-padrão = ",
    round(sd(reamostra$res.50), digits = 3)
  ),
  paste0(
    "Amostra (n = 500)",
    "\n",
    "média = ",
    round(mean(reamostra$res.500), digits = 3),
    "\n",
    "desvio-padrão = ",
    round(sd(reamostra$res.500), digits = 3)
  ),
  paste0(
    "Amostra: (n = 5000)",
    "\n",
    "média = ",
    round(mean(reamostra$res.5000), digits = 3),
    "\n",
    "desvio-padrão = ",
    round(sd(reamostra$res.5000), digits = 3)
  )
)

# histograma de densidade da reamostra utilizando grid por reamostra
histograma_reamostra <- reamostra %>%
  tidyr::pivot_longer(cols = 1:4,
                      names_to = "reamostra",
                      values_to = "valor") %>%
  ggplot2::ggplot(ggplot2::aes(x = valor)) +
  ggplot2::geom_histogram(
    ggplot2::aes(y = ggplot2::after_stat(density)),
    binwidth = 1,
    boundary = 0,
    fill = "grey",
    color = "black",
    alpha = 0.5
  ) +
  ggplot2::geom_density() +
  ggplot2::facet_wrap(~ reamostra, ncol = 2) +
  ggplot2::labs(title = "Histogramas representando as médias \n de 100 amostras de tamanhos diferentes \n tomadas da população \n com reposição e igual probabilidade", x = "Variável", y = "Densidade") +
  ggplot2::theme_bw() +
  ggplot2::theme(
    plot.title = ggplot2::element_text(hjust = 0.5),
    axis.title = ggplot2::element_text(size = 9),
    axis.text = ggplot2::element_text(size = 9),
    axis.text.x = ggplot2::element_text(angle = 45, hjust = 1)
  )
