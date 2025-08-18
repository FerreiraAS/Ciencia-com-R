# ---------- Funções auxiliares ----------
.build_nodes_df <- function(dag, panel_label){
  coords <- dagitty::coordinates(dag)
  nms <- union(names(coords$x), names(coords$y))
  x <- unname(coords$x[nms]); names(x) <- NULL
  y <- unname(coords$y[nms]); names(y) <- NULL
  data.frame(
    name  = nms, x = as.numeric(x), y = as.numeric(y),
    panel = panel_label, stringsAsFactors = FALSE
  )
}

.build_edges_df <- function(dag, nodes_df){
  ed <- dagitty::edges(dag)
  if(nrow(ed) == 0L) return(data.frame())
  x_of <- function(nm) nodes_df$x[match(nm, nodes_df$name)]
  y_of <- function(nm) nodes_df$y[match(nm, nodes_df$name)]
  data.frame(
    x     = x_of(ed$v), y    = y_of(ed$v),
    xend  = x_of(ed$w), yend = y_of(ed$w),
    panel = nodes_df$panel[1], stringsAsFactors = FALSE
  )
}

# Encurtar arestas para não invadir os nós
trim_edges_to_node_border <- function(edges, node_r = 0.085){
  if(nrow(edges) == 0L) return(edges)
  dx  <- edges$xend - edges$x
  dy  <- edges$yend - edges$y
  L   <- sqrt(dx*dx + dy*dy)
  ux  <- dx / L
  uy  <- dy / L
  # recua na origem e no destino
  edges$x    <- edges$x    + ux * node_r
  edges$y    <- edges$y    + uy * node_r
  edges$xend <- edges$xend - ux * node_r
  edges$yend <- edges$yend - uy * node_r
  edges
}

# ---------- DAGs ----------
dag_ind <- dagitty::dagitty("dag { X Y }")
dagitty::coordinates(dag_ind) <- list(x = c(X=0, Y=1), y = c(X=0, Y=0))

dag_chain <- dagitty::dagitty("dag { X -> M -> Y }")
dagitty::coordinates(dag_chain) <- list(x = c(X=0, M=0.5, Y=1), y = c(X=0, M=0, Y=0))

dag_fork <- dagitty::dagitty("dag { X <- Z -> Y }")
dagitty::coordinates(dag_fork) <- list(x = c(X=0, Z=0.5, Y=1), y = c(X=0, Z=0, Y=0))

dag_coll <- dagitty::dagitty("dag { X -> Z <- Y }")
dagitty::coordinates(dag_coll) <- list(x = c(X=0, Z=0.5, Y=1), y = c(X=0, Z=0, Y=0))

# ---------- Data frames ----------
nodes_all <- rbind(
  .build_nodes_df(dag_ind,   "1) Independência"),
  .build_nodes_df(dag_chain, "2) Cadeia (X → M → Y)"),
  .build_nodes_df(dag_fork,  "3) Garfo (X ← Z → Y)"),
  .build_nodes_df(dag_coll,  "4) Colisor (X → Z ← Y)")
)

edges_all <- rbind(
  .build_edges_df(dag_ind,   subset(nodes_all, panel == "1) Independência")),
  .build_edges_df(dag_chain, subset(nodes_all, panel == "2) Cadeia (X → M → Y)")),
  .build_edges_df(dag_fork,  subset(nodes_all, panel == "3) Garfo (X ← Z → Y)")),
  .build_edges_df(dag_coll,  subset(nodes_all, panel == "4) Colisor (X → Z ← Y)"))
)

# *** Ajuste importante: encurtar arestas ***
edges_all <- trim_edges_to_node_border(edges_all, node_r = 0.085)

# ---------- Plot ----------
p <- ggplot2::ggplot() +
  # Arestas com setas visíveis
  ggplot2::geom_segment(
    data = edges_all,
    mapping = ggplot2::aes(x = x, y = y, xend = xend, yend = yend),
    arrow = grid::arrow(length = grid::unit(0.25, "in"), ends = "last", type = "closed"),
    linewidth = 1
  ) +
  # Nós grandes (círculo branco com contorno)
  ggplot2::geom_point(
    data = nodes_all,
    mapping = ggplot2::aes(x = x, y = y),
    shape = 21, fill = "white", color = "black",
    stroke = 1.6, size = 14
  ) +
  # Letras dentro dos círculos
  ggplot2::geom_text(
    data = nodes_all,
    mapping = ggplot2::aes(x = x, y = y, label = name),
    size = 6, fontface = "bold", vjust = 0.35, hjust = 0.5
  ) +
  ggdag::theme_dag() +
  ggplot2::facet_wrap(~ panel, ncol = 2) +
  ggplot2::theme(
    plot.title = ggplot2::element_text(hjust = 0.5, size = 14),
    panel.spacing = grid::unit(5, "lines"),
    plot.margin = grid::unit(c(0.5, 0.5, 0.5, 0.5), "cm")
  ) +
  ggplot2::coord_cartesian(clip = "off")

print(p)
