# Cria uma tabela de erros tipo I e II
cross.table.erros <-
  matrix(
    c(
      'Decisão correta',
      'Decisão incorreta (erro tipo II)',
      'Decisão incorreta (erro tipo I)',
      'Decisão correta'
    ),
    nrow = 2,
    ncol = 2,
    byrow = FALSE
  )
rownames(cross.table.erros) <-
  c("Hipótese nula $H_{0}$ foi rejeitada",
    "Hipótese nula $H_{0}$ não foi rejeitada")
colnames(cross.table.erros) <-
  c("Hipótese nula $H_{0}$ é falsa",
    "Hipótese nula $H_{0}$ é verdadeira")

# exibe a tabela de dados
kableExtra::kable(
  cross.table.erros,
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  escape = FALSE,
  caption = "Tabela de erros tipos I e II de inferência estatística."
) %>%
  kableExtra::kable_styling(
    latex_options = c("basic"),
    bootstrap_options = c("basic", "hover", "condensed", "responsive"),
    full_width = ifelse(knitr::is_html_output(), T, T),
    position = "center"
  ) %>%
  kableExtra::row_spec(0, bold = TRUE, extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  kableExtra::column_spec(1, bold = TRUE) %>%
  kableExtra::row_spec(dim(cross.table.erros)[1], extra_css = "border-bottom: 1px solid")
