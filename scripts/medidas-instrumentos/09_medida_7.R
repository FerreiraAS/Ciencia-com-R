```

```{r medidas-seriadas-agregadas, include = FALSE, echo = FALSE, results = "hide"}
# para reprodutibilidade das simulações
set.seed(3)

# tamanho do grupo
n <- 100

# cria o fator unidade de análise, sem reposição
ID <- seq(1:n)

# número de medidas seriadas
k <- 3

# determina os limites do espaço amostral para sorteio
inferior <- 110
superior <- 120

# prepara a tabela de resultados
table.5 <-
  data.frame(matrix(
    vector(),
    nrow = 0,
    ncol = 3,
    dimnames = list(
      c(),
      c(
        "Unidade de análise",
        "Tempo (min)",
        "Pressão arterial, braço esquerdo (mmHg)"
      )
    )
  ))

# para cada série
for (i in 1:k) {
  # cria o fator de repetição seriada
  TIME <- rep(i, n)
  
  # sorteia n dados no intervalo min-max, com reposição para cada variável
  VAR <- sample(inferior:superior, n, replace = TRUE)
  
  # organiza as informações de unidade de análise e dados
  serie <- data.frame(ID, TIME, VAR)
  
  # atribui rótulos para a tabela de dados
  colnames(serie) <-
    c("Unidade de análise",
      "Tempo (min)",
      "Pressão arterial, braço esquerdo (mmHg)")
  
  # concatena as informações de unidade de análise e dados para cada série de coleta
  table.5 <- rbind(table.5, serie)
}

# converte dados para variável numérica contínua
table.5[, 3] <- sapply(table.5[, 3], as.numeric)

# agrega os valores seriados em linhas com a amplitude
table.5 <-
  aggregate(
    table.5[, 3] ~ table.5[, 1],
    FUN = function(x) {
      range(x)[2] - range(x)[1]
    }
  )

# formata a visualzação de casas decimais das variáveis numéricas
table.5 <- format(table.5, nsmall = 0)

# atribui rótulos para a tabela de dados
colnames(table.5) <-
  c("Unidade de análise",
    "Pressão arterial, braço esquerdo (mmHg) amplitude")

# exibe as 10 linhas iniciais da tabela de dados
kableExtra::kable(
  head(table.5, n = 10L),
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  caption = "Tabela de dados brutos com medidas seriadas não agregadas."
) %>%
  kableExtra::kable_styling(
    latex_options = c("striped"),
    bootstrap_options = c("striped", "hover", "condensed", "responsive"),
    full_width = ifelse(knitr::is_html_output(), T, T),
    position = "center"
  ) %>%
  kableExtra::row_spec(0, bold = TRUE, extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  kableExtra::row_spec(10, extra_css = "border-bottom: 1px solid") %>%
  kableExtra::row_spec(1, background = "#E6E6E6", bold = TRUE)
