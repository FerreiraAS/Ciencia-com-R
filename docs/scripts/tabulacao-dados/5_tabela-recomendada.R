# cria a tabela de exemplos
table.final <-
  data.frame(table.1[, 1], table.1[, 2], table.2[, 3], table.3[, 3])
colnames(table.final) <-
  c("ID", "Data.Coleta", "Estado.Civil", "Numero.Filhos")

# exibe a tabela
kableExtra::kable(
  table.final,
  align = "l",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  caption = "Formatação recomendada para tabela de dados."
) %>%
  kableExtra::kable_styling(
    latex_options = c("striped"),
    bootstrap_options = c("striped", "hover", "condensed", "responsive"),
    full_width = ifelse(knitr::is_html_output(), T, T),
    position = "center"
  ) %>%
  kableExtra::row_spec(
    0,
    bold = TRUE,
    extra_css = "border-top: 1px solid; border-bottom: 1px solid"
  ) %>%
  kableExtra::row_spec(
    dim(table.final)[1],
    extra_css = "border-bottom: 1px solid"
  )
