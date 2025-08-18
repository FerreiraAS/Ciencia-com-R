# Criar um dataframe com exemplos de casas decimais e dígitos significativos
dados <- data.frame(
  Valor = c(0.00789, 0.0456, 45.600, 123.456, 7890)
)

# Calcular casas decimais
dados$'Casas Decimais' <- sapply(dados$Valor, function(x) {
  if (x == 0) return(0)
  else return(nchar(sub(".*\\.", "", as.character(x))))
})

# Calcular dígitos significativos
dados$'Dígitos Significativos' <- sapply(dados$Valor, function(x) {
  gsub("^0+|\\..*", "", as.character(x)) %>%
  nchar()
})

# Remover zeros à direita e formatar os valores
dados$Valor <- sapply(1:nrow(dados), function(i) {
  format(dados$Valor[i], nsmall = dados$`Casas Decimais`[i], 
         scientific = FALSE, 
         trim = TRUE, 
         decimal.mark = ",")
})

# exibe a tabela de dados
kableExtra::kable(
  dados,
  align = c("r", "c", "c"),
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  escape = FALSE,
  caption = "Quantidade de casas decimais e dígitos significativos."
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
  kableExtra::row_spec(dim(dados)[1],
                       extra_css = "border-bottom: 1px solid")
