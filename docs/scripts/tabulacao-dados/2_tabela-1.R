# cria a tabela de exemplos
table.1 <- matrix(NA, nrow = 10, ncol = 2)

# atribui rótulos para a tabela de dados
colnames(table.1) <- c("ID", "Data.Coleta")

# preenche a tabela com identificação da unidade de análise
table.1[, 1] <- seq(1:10)

# preenche a tabela com maus exemplos
table.1[, 2] <- as.character(Sys.Date() + seq(1:10))

# preenche a tabela com melhores exemplos
table.1[, 2] <-
  format(as.Date(table.1[, 2], origin = "1950-01-01"), "%d-%m-%Y")
