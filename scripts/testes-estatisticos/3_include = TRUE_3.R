# carrega os pacotes
library("dplyr")
library("gtsummary")

# tabela 2x2
tbl_cross <-
    # banco de dados
    trial %>%
    # cria a tabela de contingência
    gtsummary::tbl_cross(
        row = trt,
        col = response,
        statistic = "{n}",
        digits = 0,
        percent = "cell",
        margin = c("row", "column"),
        missing = "no",
        missing_text = "Dados perdidos",
        margin_text = "Total"
        ) %>%
    # calcula o p-valor do teste
    gtsummary::add_p(
        test = "fisher.test",
        pvalue_fun = function(x) style_pvalue(x, digits = 3)
        ) %>%
    gtsummary::modify_header(
        p.value = "**P-valor**"
        ) %>%
    # calcula o tamanho do efeito
    gtsummary::modify_table_styling(
        rows = NULL,
        footnote = as.character(rstatix::cramer_v(trt, response))
        ) %>%
    # formata o título em negrito
    gtsummary::bold_labels() %>%
    # cria título da tabela
    gtsummary::modify_caption(
        "Teste exato de Fisher"
        )

# exibe a tabela
require(huxtable)
tbl_cross %>%
  gtsummary::as_hux_table()
