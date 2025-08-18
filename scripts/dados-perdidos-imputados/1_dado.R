# Reprodutibilidade
set.seed(123)

# Simulação de dados de um RCT (n = 10)
n <- 10
rct10 <- data.frame(
  id = 1:n,
  Grupo = sample(c("Controle", "Intervenção"), n, replace = TRUE),
  Idade = sample(40:75, n, replace = TRUE),
  Sexo = sample(c("M", "F"), n, replace = TRUE),
  "Desfecho (pré)" = rnorm(n, mean = 50, sd = 10),
  "Desfecho (pós)" = rnorm(n, mean = 55, sd = 12),
  check.names = FALSE
)

# Introduzir dados perdidos (MCAR)
rct10[["Desfecho (pós)"]][sample(1:n, 3)] <- NA  # 3 perdas no pós
rct10$Idade[sample(1:n, 2)] <- NA                # 2 perdas em Idade

# (Opcional) arredondar desfechos para visualização
rct10[["Desfecho (pré)"]] <- round(rct10[["Desfecho (pré)"]], 1)
rct10[["Desfecho (pós)"]] <- round(rct10[["Desfecho (pós)"]], 1)

# exibir a tabela de 10 indivíduos simulada
kableExtra::kable(
  rct10,
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  escape = FALSE,
  caption = "Tabela simulada com 10 indivíduos de um RCT (dados com perdas aleatórias)."
) %>%
  kableExtra::kable_styling(
    latex_options = c("basic"),
    bootstrap_options = c("basic", "hover", "condensed", "responsive"),
    full_width = ifelse(knitr::is_html_output(), TRUE, TRUE),
    position = "center"
  ) %>%
  kableExtra::row_spec(0, bold = TRUE, extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  kableExtra::row_spec((dim(rct10)[1] - 1), bold = TRUE, extra_css = "border-bottom: 1px solid") %>%
  kableExtra::column_spec(1, bold = TRUE) %>%
  kableExtra::row_spec(dim(rct10)[1], extra_css = "border-bottom: 1px solid")
