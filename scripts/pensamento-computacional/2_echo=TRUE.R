# Exemplo de R script

# Este é um comentário

# Esta é uma variável
variavel <- 3.14 # Atribui o valor 3.14 à variável

# Esta é uma função
f <- function(x) {
  return(x^2) # Retorna o quadrado do valor de x
}

# Esta é uma chamada de função
resultado <- f(variavel) # Chama a função f com a variável como argumento

# Exibe o resultado da função
print(resultado) # Exibe o resultado na saída padrão

# Este é um vetor
vetor <- c(1, 2, 3, 4, 5) # Cria um vetor com os valores de 1 a 5
# Exibe o vetor
print(vetor) # Exibe o vetor na saída padrão

# Esta é uma matrix
matriz <- matrix(1:9, nrow=3, ncol=3) # Cria uma matriz 3x3 com os valores de 1 a 9
# Exibe a matriz
print(matriz) # Exibe a matriz na saída padrão

# Esta é uma lista
lista <- list(nome="João", idade=30, altura=1.75) # Cria uma lista com nome, idade e altura
# Exibe a lista
print(lista) # Exibe a lista na saída padrão

# Este é um dataframe
dataframe <- data.frame(nome=c("João", "Maria", "José"), idade=c(30, 25, 40), altura=c(1.75, 1.60, 1.80)) # Cria um dataframe com nome, idade e altura
# Exibe o dataframe
print(dataframe) # Exibe o dataframe na saída padrão

# Fim do exemplo de R script
