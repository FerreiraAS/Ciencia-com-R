# Carregar pacotes
library(dplyr)

# Criar a tibble com 3 categorias equilibradas
praticas_questionaveis <- tibble::tibble(
  Prática = c(
    "Data fabrication",
    "Data falsification",
    "Fake authorship",
    "Fake peer review",
    "Honorary authorship",
    "Gold authorship",
    "Ghost authorship",
    "Duplicate publication",
    "Spin (doloso)",
    "Data distortion",
    "SPARKing",
    
    "HARKing",
    "Storytelling",
    "Selective reporting",
    "P-hacking",
    "Data peeking",
    "Cherry picking",
    "Salami slicing",
    "Beautification",
    
    "P-hacking reverso",
    "Fishing expedition",
    "Data dredging",
    "File drawer problem",
    "Publication bias"
  ),
  Intencionalidade = c(
    # 11 intencionais (inclui SPARKing)
    rep("Má conduta", 11),
    
    # 8 zona cinzenta
    rep("Zona cinzenta", 8),
    
    # 5 não intencionais
    rep("Não intencional", 5)
  ),
  Definição = c(
    "Inventar dados inexistentes",
    "Alterar ou manipular dados reais",
    "Inserir autores fictícios ou inexistentes",
    "Criar revisões falsas para facilitar publicação",
    "Incluir autores sem contribuição real",
    "Atribuir autoria como forma de prestígio ou recompensa",
    "Omitir autores que participaram do estudo",
    "Publicar o mesmo estudo em mais de uma revista",
    "Apresentar os resultados de forma a exagerar efeitos positivos",
    "Modificar dados ou gráficos para torná-los mais convincentes",
    "Ajustar o tamanho da amostra após a coleta dos dados para obter significância estatística",
    
    "Criar hipóteses após ver os dados (sem pré-registro)",
    "Construir uma narrativa forçada para justificar os achados",
    "Relatar apenas os resultados favoráveis ou positivos",
    "Testar múltiplas análises até encontrar p<0.05",
    "Analisar dados antes do término da coleta, parando quando um efeito aparece",
    "Selecionar apenas os resultados que apoiam a hipótese",
    "Dividir artificialmente um estudo em vários artigos para inflar publicações",
    "Embelezar tabelas, gráficos ou resultados para torná-los mais atraentes",
    
    "Forçar análises para que não haja significância estatística",
    "Procurar achados sem plano prévio",
    "Explorar excessivamente os dados para encontrar associações irrelevantes",
    "Não publicar estudos com resultados negativos ou nulos",
    "Tendência geral das revistas em favorecer publicações com resultados positivos"
  )
)

# Ordenar por categoria
praticas_questionaveis <- praticas_questionaveis %>%
  arrange(factor(
    Intencionalidade,
    levels = c("Má conduta", "Zona cinzenta", "Não intencional")
  ))

bg_color <- function(hex, latex) {
  if (knitr::is_html_output()) hex else latex
}

# Criar tabela com kableExtra
kableExtra::kable(
  praticas_questionaveis,
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  escape = FALSE,
  caption = "Classificação das práticas questionáveis em pesquisa segundo sua intencionalidade."
) %>%
  kableExtra::kable_styling(
    latex_options = c("striped"),
    bootstrap_options = c("striped", "hover", "condensed", "responsive"),
    full_width = TRUE,
    position = "center"
  ) %>%
  kableExtra::row_spec(0, bold = TRUE, extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  kableExtra::row_spec(
    which(praticas_questionaveis$Intencionalidade == "Má conduta"),
    background = bg_color("#FFCDD2", "lightred")
  ) %>%
  kableExtra::row_spec(
    which(praticas_questionaveis$Intencionalidade == "Zona cinzenta"),
    background = bg_color("#FFF9C4", "lightyellow")
  ) %>%
  kableExtra::row_spec(
    which(praticas_questionaveis$Intencionalidade == "Não intencional"),
    background = bg_color("#E8F5E9", "lightgreen")
  ) %>%
  kableExtra::row_spec(nrow(praticas_questionaveis), extra_css = "border-bottom: 1px solid")
