# Reprodutibilidade
set.seed(123)

# Simular dados de 10 ensaios clínicos (Tratamento vs. Controle)
k   <- 10
n_t <- sample(30:200, k, replace = TRUE)  # tamanho do grupo Tratamento
n_c <- sample(30:200, k, replace = TRUE)  # tamanho do grupo Controle

# Médias e desvios-padrão simulados
mu_c <- rnorm(k, mean = 0.00, sd = 0.40)
mu_t <- mu_c + rnorm(k, mean = 0.30, sd = 0.15)  # efeito médio positivo para Tratamento
sd_c <- runif(k, min = 0.6, max = 1.4)
sd_t <- runif(k, min = 0.6, max = 1.4)

dat <- data.frame(
  study_id = paste0("Trial_", seq_len(k)),
  n_t      = n_t,
  n_c      = n_c,
  mean_t   = mu_t,
  mean_c   = mu_c,
  sd_t     = sd_t,
  sd_c     = sd_c,
  stringsAsFactors = FALSE
)

# Calcular SMD (Hedges g) com escalc()
# measure = "SMD" usa a correção de Hedges por padrão (J)
es <- metafor::escalc(
  measure = "SMD",
  m1i = dat$mean_t,
  sd1i = dat$sd_t,
  n1i = dat$n_t,
  m2i = dat$mean_c,
  sd2i = dat$sd_c,
  n2i = dat$n_c,
  data = dat,
  vtype = "UB"
)

# Ajustar meta-análise de efeito fixo (variância inversa, sem tau^2)
res_fe <- metafor::rma.uni(yi = es$yi,
                           vi = es$vi,
                           method = "FE")

# Forest plot
metafor::forest(
  res_fe,
  slab = es$study_id,
  xlab = "Hedges g",
  header = "Ensaios Clínicos",
  cex = 0.9,
  refline = 0,
  mlab = "Modelo de Efeito Fixo"
)
