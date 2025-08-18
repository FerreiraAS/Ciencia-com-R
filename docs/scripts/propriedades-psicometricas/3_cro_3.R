library(dplyr)
cross.table.kappa <-
  matrix(
    c(
      '$a$', '$d$', '$g$', '$j=a+d+g$',
      '$b$', '$e$', '$h$', '$k=b+e+h$',
      '$c$', '$f$', '$i$', '$l=c+f+i$',
      '$j=a+b+c$', '$k=d+e+f$', '$l=g+h+i$', '$N=a+b+c+d+e+f+g+h+i$'
    ),
    nrow = 4,
    ncol = 4,
    byrow = FALSE
  )
rownames(cross.table.kappa) <-
  c("Grave", "Moderado", "Leve", "Total")
colnames(cross.table.kappa) <-
  c("Grave", "Moderado", "Leve", "Total")

# exibe a tabela de dados
kableExtra::kable(
  cross.table.kappa,
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  escape = FALSE,
  caption = "Tabela de confusão 3x3 para análise de concordância de testes e variáveis dicotômicas."
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
