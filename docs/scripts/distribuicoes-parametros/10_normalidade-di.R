scaleFUN <- function(x)
  sprintf("%.2f", x)

# Simulate random sample from normal distribution
set.seed(123)
n <- 50
data <- rnorm(n, mean = 0, sd = 1)

# Calcular a média e o desvio padrão
mean_data <- mean(data)
sd_data <- sd(data)

# Realizar os testes
ks_test <- ks.test(data, "pnorm", mean = 0, sd = 1)
shapiro_test <- shapiro.test(data)
ad_test <- nortest::ad.test(data)

# Função para formatar p-values
format_p_value <- function(p_value) {
  if (p_value < 0.001) {
    return("p < 0.001")
  } else {
    return(paste("p-value:", format(p_value, digits = 4)))
  }
}

# Normal Distribution plot (d1) com média e desvio padrão no título
d1 <- ggfortify::ggdistribution(
  dnorm,
  seq(-3, 3, 0.1),
  mean = 0,
  sd = 1,
  main = paste(
    "Distribuição de probabilidade\nMédia:",
    sprintf("%.2f", mean_data),
    "Desvio Padrão:",
    sprintf("%.2f", sd_data)
  )
) +
  ggplot2::scale_y_continuous(labels = scaleFUN) +
  ggplot2::theme_minimal() +
  ggplot2::theme(aspect.ratio = 1,
                 text = ggplot2::element_text(size = 8))

# CDF plot (p1)
p1 <- ggfortify::ggdistribution(pnorm,
                                seq(-3, 3, 0.1),
                                mean = 0,
                                sd = 1,
                                main = "Função de distribuição cumulativa") +
  ggplot2::scale_y_continuous(labels = scaleFUN) +
  ggplot2::theme_minimal() +
  ggplot2::theme(aspect.ratio = 1,
                 text = ggplot2::element_text(size = 8))

# QQ-plot for Normal distribution
qqplot <- ggplot2::ggplot(data.frame(x = data), ggplot2::aes(sample = x)) +
  ggplot2::stat_qq() +
  ggplot2::stat_qq_line(color = "red") +
  ggplot2::ggtitle("QQ-Plot") +
  ggplot2::theme_minimal() +
  ggplot2::theme(aspect.ratio = 1,
                 text = ggplot2::element_text(size = 8))

# Kolmogorov-Smirnov Test plot (kolmogorov)
kolmogorov <- ggplot2::ggplot(data.frame(x = sort(data)), ggplot2::aes(x)) +
  ggplot2::stat_ecdf(geom = "step", color = "blue") +  # ECDF of data
  ggplot2::stat_function(
    fun = stats::pnorm,
    args = list(mean = 0, sd = 1),
    color = "red",
    size = 1
  ) +
  ggplot2::ggtitle(paste("Kolmogorov-Smirnov Test\n", format_p_value(ks_test$p.value))) +
  ggplot2::theme_minimal() +
  ggplot2::theme(aspect.ratio = 1,
                 text = ggplot2::element_text(size = 8))

# Shapiro-Wilk Test plot (shapiro)
shapiro <- ggplot2::ggplot(data.frame(x = sort(data)), ggplot2::aes(x)) +
  ggplot2::stat_ecdf(geom = "step", color = "green") +  # ECDF of data
  ggplot2::stat_function(
    fun = stats::pnorm,
    args = list(mean = 0, sd = 1),
    color = "red",
    size = 1
  ) +
  ggplot2::ggtitle(paste("Shapiro-Wilk Test\n", format_p_value(shapiro_test$p.value))) +
  ggplot2::theme_minimal() +
  ggplot2::theme(aspect.ratio = 1,
                 text = ggplot2::element_text(size = 8))

# Anderson-Darling Test plot (anderson)
anderson <- ggplot2::ggplot(data.frame(x = sort(data)), ggplot2::aes(x)) +
  ggplot2::stat_ecdf(geom = "step", color = "purple") +  # ECDF of data
  ggplot2::stat_function(
    fun = stats::pnorm,
    args = list(mean = 0, sd = 1),
    color = "red",
    size = 1
  ) +  # Normal CDF
  ggplot2::ggtitle(paste("Anderson-Darling Test\n", format_p_value(ad_test$p.value))) +
  ggplot2::theme_minimal() +
  ggplot2::theme(aspect.ratio = 1,
                 text = ggplot2::element_text(size = 8))

# Combine all plots into one grid
ggpubr::ggarrange(
  d1,
  p1,
  qqplot,
  kolmogorov,
  shapiro,
  anderson,
  heights = c(1, 1),
  widths = c(1, 1, 1),
  nrow = 2,
  ncol = 3,
  align = "h"
)
