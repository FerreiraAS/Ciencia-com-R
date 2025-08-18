# para reprodutibilidade das simulações
set.seed(1)

# tamanho do grupo
n <- 100

# cria o fator unidade de análise, sem reposição
ID <- seq(1:n)

# determina os limites do espaço amostral para sorteio
inferior <- 110
superior <- 120

# sorteia n dados no intervalo min-max, com reposição para cada variável
VAR.1 <- sample(inferior:superior, n, replace = TRUE)

# organiza as informações de unidade de análise e dados
table.1 <- data.frame(ID, VAR.1)

# atribui rótulos para a tabela de dados
colnames(table.1) <-
  c("Unidade de análise", "Pressão arterial, braço esquerdo (mmHg)")

# exibe as 10 linhas iniciais da tabela de dados
kableExtra::kable(
  head(table.1, n = 10L),
  align = "c",
  format = ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  caption = "Tabela de dados brutos com medidas únicas."
) %>%
  kableExtra::kable_styling(
    latex_options = c("striped"),
    bootstrap_options = c("striped", "hover", "condensed", "responsive"),
    full_width = ifelse(knitr::is_html_output(), T, T),
    position = "center"
  ) %>%
  kableExtra::row_spec(0, bold = TRUE, extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  kableExtra::row_spec(10, extra_css = "border-bottom: 1px solid") %>%
  kableExtra::row_spec(k1, background = "#E6E6E6", bold = TRUE)
