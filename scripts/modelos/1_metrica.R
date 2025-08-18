# Reprodutibilidade
set.seed(123)

# Modelo
dados <- data.frame(x = rnorm(100, 5, 2),
                    y = 3 + 1.5 * rnorm(100, 5, 2) + rnorm(100))
modelo <- lm(y ~ x, data = dados)

# Resultado
resultado <- performance::model_performance(modelo)

# Reestruturando para exibir como "Métrica | Valor"
resultado_df <- as.data.frame(t(resultado)) # transpor para linhas
resultado_df$Métrica <- rownames(resultado_df)
colnames(resultado_df)[1] <- "Valor"
rownames(resultado_df) <- NULL
resultado_df <- resultado_df[, c("Métrica", "Valor")]

# Formatando os valores numéricos
resultado_df$Valor <- formatC(
  resultado_df$Valor,
  format = "f",
  digits = 3,
  big.mark = ",",
  decimal.mark = "."
)

resultado_df$Métrica <- dplyr::recode(
  resultado_df$Métrica,
  AIC = "AIC",
  AICc = "AIC corrigido",
  BIC = "BIC",
  R2 = "$R^2$",
  R2_adjusted = "$R^2$ ajustado",
  RMSE = "Erro quadrático médio (RMSE)",
  Sigma = "Desvio residual (Sigma)"
)

# Exibindo com estilo avançado
kableExtra::kable(
  resultado_df,
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  escape = FALSE,
  caption = "Métricas de desempenho do modelo de regressão linear."
) %>%
  kableExtra::kable_styling(
    latex_options = c("basic"),
    bootstrap_options = c("basic", "hover", "condensed", "responsive"),
    full_width = ifelse(knitr::is_html_output(), TRUE, TRUE),
    position = "center"
  ) %>%
  kableExtra::row_spec(0, bold = TRUE, extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  kableExtra::column_spec(1, bold = TRUE) %>%
  kableExtra::row_spec(nrow(resultado_df), extra_css = "border-bottom: 1px solid")
