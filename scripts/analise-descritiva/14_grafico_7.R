# Instalar se necessário: install.packages("GGally")
library(GGally)

# Simular dados multivariados
dados <- data.frame(
  var1 = stats::rnorm(100),
  var2 = stats::rnorm(100, mean = 50, sd = 10),
  var3 = stats::rnorm(100, mean = 100, sd = 25)
)

# Matriz de dispersão
GGally::ggpairs(dados, title = "Matriz de Dispersão")
