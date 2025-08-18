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

# --- modelo de efeito fixo) ---
res_fe <- metafor::rma.uni(yi = es$yi,
                           vi = es$vi,
                           method = "FE")

# --- modelo de efeito aleatório (REML) ---
res_re <- metafor::rma.uni(
  yi = es$yi,
  vi = es$vi,
  method = "REML"  # método para efeito aleatório
)
tau2   <- base::as.numeric(res_re$tau2)
fe_est <- base::as.numeric(res_fe$b)
re_est <- base::as.numeric(res_re$b)

# Funnel com “contour enhancement” para significância
#    As áreas sombreadas ajudam a distinguir assimetria por viés vs. heterogeneidade/azar.
metafor::funnel(
  res_re,
  xlab   = "Hedges g (SMD)",
  ylab   = "Precisão (1/SE)",
  yaxis  = "seinv",
  level  = c(90, 95, 99),   # contornos de significância
  refline = as.numeric(res_re$b),
  back   = "gray95",        # fundo suave
  shade  = c("white", "gray90", "gray80")
)

# Adiciona rótulos dos estudos
# A função funnel() devolve um gráfico, mas não retorna coordenadas,
# então usamos os próprios yi e vi para calcular posições
with(es, {
  precisao <- 1 / sqrt(vi) # eixo vertical (seinv)
  text(x = yi, y = precisao, labels = dat$study_id, pos = 4, cex = 0.7)
})
