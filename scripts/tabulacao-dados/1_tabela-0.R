# atribui rótulos para a tabela de dados
N <- 5
M <- 4

# cria a tabela de exemplos
table.0 <- matrix("dado", nrow = N, ncol = M)

colnames(table.0) <- paste0("V", seq(1:M))
for (i in 1:N) {
  for (j in 1:M) {
    table.0[i, j] <-
      paste0("$x", "_{", as.character(i), ",", as.character(j), "}$")
  }
}

# exibe a tabela
kableExtra::kable(
  table.0,
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  escape = F,
  caption = "Estrutura básica de uma tabela de dados."
) %>%
  kableExtra::kable_styling(
    latex_options = c("striped"),
    bootstrap_options = c("striped", "hover", "condensed", "responsive"),
    full_width = ifelse(knitr::is_html_output(), T, T),
    position = "center"
  ) %>%
  kableExtra::row_spec(0, bold = TRUE, extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  kableExtra::row_spec(dim(table.0)[1], bold = TRUE, extra_css = "border-bottom: 1px solid")
