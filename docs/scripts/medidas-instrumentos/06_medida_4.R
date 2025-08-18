```

```{r medidas-repetidas-agregadas, include = FALSE, echo = FALSE, results = "hide"}
# para reprodutibilidade das simulações
set.seed(2)

# tamanho do grupo
n <- 100

# cria o fator unidade de análise, sem reposição
ID <- seq(1:n)

# determina os limites do espaço amostral para sorteio
inferior <- 110
superior <- 120

# sorteia n dados no intervalo min-max, com reposição para cada variável
VAR.1 <- sample(inferior:superior, n, replace = TRUE)
VAR.2 <- sample(inferior:superior, n, replace = TRUE)
VAR.3 <- sample(inferior:superior, n, replace = TRUE)

# organiza as informações de unidade de análise e dados
VAR <- data.frame(VAR.1, VAR.2, VAR.3)

# converte dados para variável numérica contínua
VAR <- sapply(VAR, as.numeric)

# agrega os valores repetidos em linhas com a média
VAR.aggr <- round(apply(VAR, 1, FUN = mean), 0)

# organiza as informações de unidade de análise e dados
table.3 <- data.frame(ID, VAR.aggr)

# formata a visualzação de casas decimais das variáveis numéricas
table.3 <- format(table.3, nsmall = 0)

# atribui rótulos para a tabela de dados
colnames(table.3) <-
  c("Unidade de análise",
    "Pressão arterial, braço esquerdo (mmHg) média")

# exibe as 10 linhas iniciais da tabela de dados
kableExtra::kable(
  head(table.3, n = 10L),
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  caption = "Tabela de dados brutos com medidas repetidas agregadas."
) %>%
  kableExtra::kable_styling(
    latex_options = c("striped"),
    bootstrap_options = c("striped", "hover", "condensed", "responsive"),
    full_width = ifelse(knitr::is_html_output(), T, T),
    position = "center"
  ) %>%
  kableExtra::row_spec(0, bold = TRUE, extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  kableExtra::row_spec(10, extra_css = "border-bottom: 1px solid") %>%
  kableExtra::row_spec(k2, background = "#E6E6E6", bold = TRUE)
