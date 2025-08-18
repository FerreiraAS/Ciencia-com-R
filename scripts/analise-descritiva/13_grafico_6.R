# Simular dados para 3 perfis com 5 variáveis
dados <- data.frame(
  Max = c(10, 10, 10, 10, 10),
  Min = c(0, 0, 0, 0, 0),
  Perfil_A = c(6, 7, 8, 5, 9),
  Perfil_B = c(8, 6, 7, 6, 7),
  Perfil_C = c(5, 9, 6, 8, 6)
)
rownames(dados) <- c("Max", "Min", "A", "B", "C")

# Gráfico radar
fmsb::radarchart(dados,
                 axistype = 1,
                 pcol = c("red", "blue", "green"),
                 plty = 1,
                 title = "Gráfico de Radar - Perfis Simulados")
