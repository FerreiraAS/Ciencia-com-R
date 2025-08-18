# Criar o layout dos dois painéis
grid::grid.newpage()
grid::pushViewport(grid::viewport(layout = grid::grid.layout(2, 1)))

# Função para posicionar gráficos
vplayout <- function(x, y)
  grid::viewport(layout.pos.row = x, layout.pos.col = y)

# Painel 1 - Eventos Independentes
grid::pushViewport(vplayout(1, 1))
VennDiagram::draw.pairwise.venn(
  area1 = 50,
  area2 = 50,
  cross.area = 0,
  category = c("Evento A", "Evento B"),
  fill = c("lightcoral", "lightgreen"),
  alpha = 0.5,
  cat.cex = 1,
  cex = 1.5,
  main = "Eventos Independentes",
  print.mode = "percent"
)
grid::popViewport()

# Painel 2 - Eventos Dependentes
grid::pushViewport(vplayout(2, 1))
VennDiagram::draw.pairwise.venn(
  area1 = 50,
  area2 = 50,
  cross.area = 20,
  category = c("Evento A", "Evento B"),
  fill = c("lightcoral", "lightgreen"),
  alpha = 0.5,
  cat.cex = 1,
  cex = 1.5,
  main = "Eventos Dependentes",
  print.mode = "percent"
)
grid::popViewport()

# sair do viewport principal
grid::popViewport()
