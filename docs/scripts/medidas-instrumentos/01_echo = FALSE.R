# reprodutibilidade
set.seed(1234)

# pacotes necessários
library(dplyr)

niveis <- c(
  "Discordo\ntotalmente",
  "Discordo\nparcialmente",
  "Nem concordo\nnem discordo",
  "Concordo\nparcialmente",
  "Concordo\ntotalmente"
)

# Simulação de dados tipo Likert
dados_prom <- base::data.frame(
  Item1 = base::factor(
    base::sample(
      c(
        "Discordo\ntotalmente",
        "Discordo\nparcialmente",
        "Nem concordo\nnem discordo",
        "Concordo\nparcialmente",
        "Concordo\ntotalmente"
      ),
      50,
      replace = TRUE
    ),
    levels = niveis
  ),
  Item2 = base::factor(
    base::sample(
      c(
        "Discordo\ntotalmente",
        "Discordo\nparcialmente",
        "Nem concordo\nnem discordo",
        "Concordo\nparcialmente",
        "Concordo\ntotalmente"
      ),
      50,
      replace = TRUE
    ),
    levels = niveis
  ),
  Item3 = base::factor(
    base::sample(
      c(
        "Discordo\ntotalmente",
        "Discordo\nparcialmente",
        "Nem concordo\nnem discordo",
        "Concordo\nparcialmente",
        "Concordo\ntotalmente"
      ),
      50,
      replace = TRUE
    ),
    levels = niveis
  )
)

# as factor
dados_prom <- dados_prom %>%
  dplyr::mutate(across(everything(), ~ factor(.x, levels = niveis)))

# Gráfico com rótulos solicitados
ggstats::gglikert(dados_prom, symmetric = TRUE)

# quebra de linha
cat("\n\n")

# Cria o objeto likert
likert_obj <- likert::likert(dados_prom)

# Converte o summary para data.frame
dados <- base::as.data.frame(summary(likert_obj))
# ordenar pela ordem alfabética da 1a coluna
dados <- dados[order(dados[, 1]), ]

# formata a visualzação de casas decimais das variáveis numéricas
dados[, 2:4] <- base::round(dados[, 2:4], digits = 0)
dados[, 5:6] <- base::round(dados[, 5:6], digits = 2)

# Ajuste de alinhamento: 1ª coluna à esquerda, demais centralizadas
alinhamento <- base::rep("c", base::ncol(dados))
alinhamento[1] <- "l"

# Ajuste de rótulos
names(dados) <- c(
  "Itens",
  "Discordância",
  "Neutro",
  "Concordância",
  "Média",
  "DP"
)

# Render da tabela
kableExtra::kable(
  dados,
  align = alinhamento,
  format = base::ifelse(knitr::is_html_output(), "html", "latex"),
  booktabs = TRUE,
  linesep = "",
  escape = FALSE,
  caption = "Descrição dos itens tipo Likert do instrumento."
) %>%
  kableExtra::kable_styling(
    latex_options = c("basic"),
    bootstrap_options = c("basic", "hover", "condensed", "responsive"),
    full_width = base::ifelse(knitr::is_html_output(), TRUE, TRUE),
    position = "center"
  ) %>%
  kableExtra::row_spec(0, bold = TRUE, extra_css = "border-top: 1px solid; border-bottom: 1px solid") %>%
  kableExtra::column_spec(1, bold = TRUE) %>%
  kableExtra::row_spec(base::dim(dados)[1], extra_css = "border-bottom: 1px solid")
