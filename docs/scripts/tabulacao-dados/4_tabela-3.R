# cria a tabela de exemplos
table.3 <- matrix(NA, nrow = 10, ncol = 3)

# preenche a tabela com identificação da unidade de análise
table.3[, 1] <- seq(1:10)

# atribui rótulos para a tabela de dados
colnames(table.3) <- c("ID", "Filhos", "Filhos")

# preenche a tabela com maus exemplos
table.3[, 2] <-
  c("NA", 1, "NaN", "N/A", "N.A.", 0, "", "na", "n.a.", "999")

# preenche a tabela com código único
table.3[, 3] <-
  gsub("NA|NaN|N/A|N.A.|na|n.a.|\t\r\n|^$|\\d{3}", NA, table.3[, 2])
