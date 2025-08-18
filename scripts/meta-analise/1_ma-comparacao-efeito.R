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

# --- preparar dados (Trial_1 no topo) ---
plotdat <- es %>%
  dplyr::mutate(se = base::sqrt(vi),
                study_id = base::factor(study_id, levels = study_id))

# --- curvas para FE (sd = se) ---
curve_FE <- plotdat %>%
  dplyr::rowwise() %>%
  dplyr::do({
    m <- .$yi
    s <- .$se
    xseq <- base::seq(m - 4 * s, m + 4 * s, length.out = 200)
    tibble::tibble(
      study_id = .$study_id,
      model = "FE",
      x = xseq,
      density = stats::dnorm(xseq, mean = m, sd = s)
    )
  }) %>%
  dplyr::ungroup()

# --- curvas para RE (sd = sqrt(se^2 + tau2)) ---
curve_RE <- plotdat %>%
  dplyr::rowwise() %>%
  dplyr::do({
    m <- .$yi
    s <- base::sqrt(.$se^2 + tau2)
    xseq <- base::seq(m - 4 * s, m + 4 * s, length.out = 200)
    tibble::tibble(
      study_id = .$study_id,
      model = "RE",
      x = xseq,
      density = stats::dnorm(xseq, mean = m, sd = s)
    )
  }) %>%
  dplyr::ungroup()

# --- juntar e normalizar ---
curve_data <- dplyr::bind_rows(curve_FE, curve_RE) %>%
  dplyr::group_by(study_id, model) %>%
  dplyr::mutate(density = density / base::max(density)) %>%
  dplyr::ungroup()

# --- paleta ---
cols <- c(FE = "gray20", RE = "steelblue4")
lts  <- c(FE = "solid", RE = "longdash")

# --- plot ---
ggplot2::ggplot(curve_data,
                ggplot2::aes(
                  x = x,
                  y = density,
                  color = model,
                  linetype = model
                )) +
  ggplot2::geom_line(linewidth = 0.8) +
  ggplot2::facet_wrap(
    ~ study_id,
    ncol = 1,
    strip.position = "left",
    scales = "free_y"
  ) +
  ggplot2::geom_vline(
    xintercept = fe_est,
    color = cols["FE"],
    linetype = lts["FE"],
    linewidth = 0.8
  ) +
  ggplot2::geom_vline(
    xintercept = re_est,
    color = cols["RE"],
    linetype = lts["RE"],
    linewidth = 0.8
  ) +
  ggplot2::scale_color_manual(values = cols, name = "Modelo") +
  ggplot2::scale_linetype_manual(values = lts, name = "Modelo") +
  ggplot2::labs(
    title = "Curvas Normais por Estudo: FE vs RE",
    subtitle = "Curvas por estudo (FE = σ; RE = √(σ² + τ²)). Linhas verticais: pooled FE (preta) e pooled RE (azul).",
    x = "Hedges g",
    y = "Densidade (normalizada)"
  ) +
  ggplot2::theme_minimal(base_size = 12) +
  ggplot2::theme(strip.text.y.left = ggplot2::element_text(angle = 0),
                 legend.position = "top")
