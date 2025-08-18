library(dplyr)
cross.table.psico <-
  matrix(
    c(
      'Adequado', 'Inadequado',
      'Inadequado', 'Inadequado'
    ),
    nrow = 2,
    ncol = 2,
    byrow = FALSE
  )
rownames(cross.table.psico) <-
  c("Validade alta", "Validade baixa")
colnames(cross.table.psico) <-
  c("Concordância alta", "Concordância baixa")

# exibe a tabela de dados
kableExtra::kable(
  cross.table.psico,
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  escape = FALSE,
  caption = "Tabela de confusão sobre propriedades psicométricas de instrumentos."
) %>%
  kableExtra::kable_styling(
    latex_options = c("basic"),
    bootstrap_options = c("basic", "hover", "condensed", "responsive"),
    full_width = ifelse(knitr::is_html_output(), T, T),
    position = "center"
  ) %>%
  kableExtra::row_spec(0,
                       bold = TRUE,
                       extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  kableExtra::column_spec(1, bold = TRUE) %>%
  kableExtra::row_spec(dim(cross.table.psico)[1],
                       extra_css = "border-bottom: 1px solid")
