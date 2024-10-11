library(dplyr)
library(kableExtra)

# Criar um data frame com exemplos de casas decimais e dígitos significativos
dados <- data.frame(
  Valor = c(123.456, 0.00456, 78900, 0.000789, 45.600)
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
         trim = TRUE)
})

# Função para calcular arredondamento e faixa de erro
calcular_erro <- function(valor, casas) {
  original_value <- as.numeric(gsub(",", ".", valor))
  rounded_value <- round(as.numeric(gsub(",", ".", original_value)), casas)

  # Calcular a faixa de erro
  if (casas == 2) {
    lower_bound <- rounded_value - 0.005
    upper_bound <- rounded_value + 0.005
  } else if (casas == 1) {
    lower_bound <- rounded_value - 0.05
    upper_bound <- rounded_value + 0.05
  } else {
    lower_bound <- rounded_value - 0.5
    upper_bound <- rounded_value + 0.5
  }
  
  return(paste0(format(rounded_value, nsmall = casas), " [", round(lower_bound, casas + 1), ", ", round(upper_bound, casas + 1), "]"))
}

dados$'Casas decimais = 2 [Margem de erro]' <- sapply(dados$Valor, function(x) {
  calcular_erro(x, 2)
})

dados$'Casas decimais = 1 [Margem de erro]' <- sapply(dados$Valor, function(x) {
  calcular_erro(x, 1)
})

dados$'Casas decimais = 0 [Margem de erro]' <- sapply(dados$Valor, function(x) {
  calcular_erro(x, 0)
})

# format numbers with commas
dados <- dados %>%
  mutate(across(everything(), ~format(.x, big.mark = ",", scientific = FALSE)))

# Exibir a tabela de dados
tabela <- dados %>%
  kable("html", align = "r",
        format = ifelse(knitr::is_html_output(), "html", "latex"),
        booktabs = TRUE,
        linesep = "",
        escape = FALSE,
        caption = "Valores originais, arredondamentos e erros de arredondamento por casas decimais.") %>%
  kable_styling(
    latex_options = c("basic"),
    bootstrap_options = c("basic", "hover", "condensed", "responsive"),
    full_width = TRUE,
    position = "center"
  ) %>%
  row_spec(0, bold = TRUE, extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  column_spec(1, bold = TRUE) %>%
  row_spec(dim(dados)[1], extra_css = "border-bottom: 1px solid")

# Imprimir a tabela
print(tabela)
