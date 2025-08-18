library(dplyr)
anscombe.dt <- datasets::anscombe
anscombe.dt$ID <- seq(1, dim(anscombe.dt)[1])
anscombe.dt <- anscombe.dt[c(9, 1:8)]

# exibe a tabela de dados
kableExtra::kable(
  anscombe.dt,
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  escape = FALSE,
  caption = "Quarteto de Anscombe."
) %>%
  kableExtra::kable_styling(
    latex_options = c("basic"),
    bootstrap_options = c("basic", "hover", "condensed", "responsive"),
    full_width = ifelse(knitr::is_html_output(), T, T),
    position = "center"
  ) %>%
  kableExtra::row_spec(0, bold = TRUE, extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  kableExtra::column_spec(1, bold = TRUE) %>%
  kableExtra::row_spec(dim(anscombe.dt)[1], extra_css = "border-bottom: 1px solid")

anscombe.dt <- anscombe.dt %>% dplyr::select(-ID)

cat('<br>')
cat('<br>')

# exibe a tabela descritiva
anscombe.summ <- data.frame(
  "X1Y1" = c(NA, NA, NA, NA, NA, NA, NA, NA),
  "X2Y2" = c(NA, NA, NA, NA, NA, NA, NA, NA),
  "X3Y3" = c(NA, NA, NA, NA, NA, NA, NA, NA),
  "X4Y4" = c(NA, NA, NA, NA, NA, NA, NA, NA)
)
ff <- y ~ x
mods <- setNames(as.list(1:4), paste0("lm", 1:4))
for (i in 1:4) {
  ff[2:3] <- lapply(paste0(c("y", "x"), i), as.name)
  mods[[i]] <- lmi <- lm(ff, data = anscombe.dt)
  # observacoes
  anscombe.summ[1, i] <- dim(anscombe.dt)[1]
  # media x,y
  anscombe.summ[2, i] <- mean(anscombe.dt[, paste0("x", i)])
  anscombe.summ[3, i] <- mean(anscombe.dt[, paste0("y", i)])
  # variancia x,y
  anscombe.summ[4, i] <- var(anscombe.dt[, paste0("x", i)])
  anscombe.summ[5, i] <- var(anscombe.dt[, paste0("y", i)])
  # correlacao
  anscombe.summ[6, i] <-
    cor(anscombe.dt[, paste0("x", i)], anscombe.dt[, paste0("y", i)])
  # coeficiente angular
  anscombe.summ[7, i] <- coef(lmi)[2]
  # coeficiente linear
  anscombe.summ[8, i] <- coef(lmi)[1]
  # coeficiente de determinacao
  anscombe.summ[9, i] <- summary(lmi)$r.squared
}
rownames(anscombe.summ) <-
  c(
    "Observações",
    "Média x",
    "Média y",
    "Variância x",
    "Variância y",
    "Correlação",
    "Coeficiente angular",
    "Coeficiente linear",
    "Coeficiente de determinação"
  )
anscombe.summ <- round(anscombe.summ, 2)

# exibe a tabela de dados
kableExtra::kable(
  anscombe.summ,
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  escape = FALSE,
  caption = "Análise descritiva do Quarteto de Anscombe demostrando os conjuntos de dados bivariados com parâmetros quase idênticos."
) %>%
  kableExtra::kable_styling(
    latex_options = c("basic"),
    bootstrap_options = c("basic", "hover", "condensed", "responsive"),
    full_width = ifelse(knitr::is_html_output(), T, T),
    position = "center"
  ) %>%
  kableExtra::row_spec(0, bold = TRUE, extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  kableExtra::column_spec(1, bold = TRUE) %>%
  kableExtra::row_spec(dim(anscombe.summ)[1], extra_css = "border-bottom: 1px solid")
