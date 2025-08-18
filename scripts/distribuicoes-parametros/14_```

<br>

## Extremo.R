```

<br>

## Extremos

<br>

### O que são extremos?

-   Valores extremos podem constituir valores legítimos ou ilegítimos de uma distribuição.[@leys2019]

<br>

### Que parâmetros extremos podem ser estimados?

-   *Mínimo*.[@Ali2016]

-   *Máximo*.[@Ali2016]

<br>

```{r regressao-linear-extremos, echo = FALSE, warning = FALSE, message = FALSE, appendix = TRUE, fig.align = 'center', layout='Blank', ph=officer::ph_location_fullsize(), results = "asis", fig.fullwidth = TRUE, fig.cap = "Regressão linear com valores extremos."}
# Reprodutibilidade
set.seed(123)

# 1) Dados "normais"
n <- 100
X <- rnorm(n, mean = 50, sd = 10)
Y <- 5 + 2 * X + rnorm(n, mean = 0, sd = 5)
data <- data.frame(X, Y, is_extreme = FALSE)

# 2) Injeta valores extremos
#   a) Outliers verticais (grande erro em Y)
X_ext1 <- rnorm(5, mean = 50, sd = 10)
Y_ext1 <- 5 + 2 * X_ext1 + rnorm(5, mean = 0, sd = 25) + 60

#   b) Alta alavancagem (X muito distante)
X_ext2 <- c(5, 95, 110, -10, 120)  # bem fora do centro
Y_ext2 <- 5 + 2 * X_ext2 + rnorm(5, mean = 0, sd = 5)

data_ext <- rbind(
  data,
  data.frame(X = X_ext1, Y = Y_ext1, is_extreme = TRUE),
  data.frame(X = X_ext2, Y = Y_ext2, is_extreme = TRUE)
)

# 3) Ajuste do modelo
model <- lm(Y ~ X, data = data_ext)

# 4) Diagnósticos
data_ext$resid_std <- rstandard(model)
data_ext$cook_d   <- cooks.distance(model)

# Regras simples:
thr_resid <- 2                        # |resíduo padronizado| > 2
thr_cook  <- 4 / nrow(data_ext)       # regra prática para Cook

data_ext$outlier_resid <- abs(data_ext$resid_std) > thr_resid
data_ext$influente     <- data_ext$cook_d > thr_cook

# 5) Plot: pontos normais, outliers e influentes
library(ggplot2)
ggplot(data_ext, aes(x = X, y = Y)) +
  geom_point(aes(
    color = case_when(
      influente ~ "Influente (Cook)",
      outlier_resid ~ "Outlier (resíduo)",
      TRUE ~ "Normal"
    ),
    shape = is_extreme
  ), size = 2.4) +
  scale_color_manual(values = c(
    "Normal" = "grey30",
    "Outlier (resíduo)" = "red",
    "Influente (Cook)" = "orange"
  )) +
  scale_shape_manual(values = c(`FALSE` = 16, `TRUE` = 17),
                     labels = c("FALSE" = "Gerado normal", "TRUE" = "Injetado extremo"),
                     name = "Origem do ponto") +
  geom_smooth(method = "lm", se = FALSE, color = "blue") +
  labs(
    title = "Regressão linear com valores extremos",
    subtitle = paste0("Outlier (|resíduo| > ", thr_resid,
                      "); Influente (Cook > ", round(thr_cook, 3), ")"),
    x = "Variável Independente (X)",
    y = "Variável Dependente (Y)",
    color = "Classificação"
  ) +
  theme_minimal()
