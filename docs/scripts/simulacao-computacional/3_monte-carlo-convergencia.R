# Pacotes
library(dplyr)

# reproducibilidade
set.seed(42)

# Tamanhos de amostra e número de repetições
ns   <- c(10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000)
reps <- 500

# Função para simular
sim_summary_normal <- function(ns, reps) {
  tibble::tibble(n = ns) %>%
    dplyr::mutate(
      sims = purrr::map(n, ~ replicate(reps, {
        x <- rnorm(.x, mean = 0, sd = 1)
        c(mean = mean(x), sd = sd(x))
      }))
    ) %>%
    dplyr::mutate(
      mean_vals = purrr::map(sims, ~ .x["mean", ]),
      sd_vals   = purrr::map(sims, ~ .x["sd", ])
    ) %>%
    dplyr::select(-sims) %>%
    tidyr::pivot_longer(cols = c(mean_vals, sd_vals),
                 names_to = "stat", values_to = "values") %>%
    tidyr::unnest(values) %>%
    dplyr::group_by(n, stat) %>%
    dplyr::summarise(
      med = median(values),
      lo  = quantile(values, 0.05),
      hi  = quantile(values, 0.95),
      .groups = "drop"
    ) %>%
    dplyr::mutate(
      stat = recode(stat, mean_vals = "Média", sd_vals = "Desvio-padrão"),
      true = ifelse(stat == "Média", 0, 1)
    )
}

normal_sum <- sim_summary_normal(ns, reps)

# Gráfico
ggplot2::ggplot(normal_sum, ggplot2::aes(x = n, y = med)) +
  ggplot2::geom_ribbon(ggplot2::aes(ymin = lo, ymax = hi, fill = stat), alpha = 0.2) +
  ggplot2::geom_line(ggplot2::aes(color = stat), size = 1) +
  ggplot2::geom_hline(ggplot2::aes(yintercept = true, color = stat), linetype = 2) +
  ggplot2::facet_wrap(~ stat, scales = "free_y") +
  ggplot2::scale_x_log10(breaks = ns) +
  ggplot2::labs(
    title = "Convergência da Média e do Desvio-padrão – Normal(0,1)",
    x = "Tamanho da amostra (n, escala log)", y = "Estimativa"
  ) +
  ggplot2::theme_minimal(base_size = 13) +
  ggplot2::theme(legend.position = "none")
