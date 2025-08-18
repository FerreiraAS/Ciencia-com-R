library(dplyr)
cross.table.kappa <-
  matrix(
    c(
      '$a$', '$c$', '$e=a+c$',
      '$b$', '$d$', '$f=b+d$',
      '$g=a+b$', '$h=c+d$', '$N=a+b+c+d$'
    ),
    nrow = 3,
    ncol = 3,
    byrow = FALSE
  )
rownames(cross.table.kappa) <-
  c("Teste positivo", "Teste negativo", "Total")
colnames(cross.table.kappa) <-
  c("Teste positivo", "Teste negativo", "Total")

# exibe a tabela de dados
kableExtra::kable(
  cross.table.kappa,
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  escape = FALSE,
  caption = "Tabela de confusão 2x2 para análise de concordância de testes e variáveis dicotômicas."
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
  kableExtra::row_spec(dim(cross.table.kappa)[1],
                       extra_css = "border-bottom: 1px solid")
