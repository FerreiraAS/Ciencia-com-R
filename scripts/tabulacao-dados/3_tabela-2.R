# cria a tabela de exemplos
table.2 <- matrix(NA, nrow = 10, ncol = 4)

# atribui rótulos para a tabela de dados
colnames(table.2) <-
  c("ID", "Estado Civil", "Estado.Civil", "Estado.Civil.Cod")

# preenche a tabela com identificação da unidade de análise
table.2[, 1] <- seq(1:10)

# preenche a tabela com maus exemplos (&nbsp; representa o caracter " " em HTML)
table.2[, 2] <-
  c(
    "casado",
    "Casado",
    " casado",
    "Solteiro",
    " Casado",
    " solteiro",
    "solteiro",
    "Solteiro ",
    " casado",
    " Solteiro "
  )

# preenche a tabela com melhores exemplos
# altera para caixa baixa
table.2[, 3] <- tolower(table.2[, 2])
# remove espaços em branco
table.2[, 3] <-
  trimws(table.2[, 3], which = "both", whitespace = "[\t\r\n]")
# remove espaço em branco de HTML
table.2[, 3] <- gsub("&nbsp;", "", table.2[, 3])
# converte em fator codificado
table.2[, 4] <- factor(table.2[, 3])
