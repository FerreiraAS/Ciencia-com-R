```

<br>

::: {.infobox .Rlogo data-latex="{images/Rlogo}"}
O pacote *stats*[@stats] fornece a função [*aggregate*](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/aggregate) para agregar medidas repetidas utilizando uma função personalizada.
:::

<br>

## Erros de medida

<br>

### O que são erros de medida?

-   .[@REF]

-   A natureza dos erros de medida são em geral atribuídos aos (1) instrumentos utilizados e variações no protocolo, na medida em que o seu tamanho médio pode ser reduzido por modificações e melhorias nesses instrumentos; e (2) variações genuínas medida em de curto prazo.[@healy1978]

<br>

### Quais fontes de variabilidade são comumente investigadas?

-   Intra/Entre participantes (isto é, unidades de análise).[@altman1983]

-   Intra/Entre repetições.[@altman1983]

-   Intra/Entre observadores.[@altman1983]

<br>

## Instrumentos

<br>

### O que são instrumentos?

-   .[@REF]

<br>

## Acurácia e precisão

<br>

### O que é acurácia?

-   Acurácia expressa a proximidade de concordância entre uma mensuração e o valor real.[@menditto2006]

-   Acurária está para medidas como validade está para instrumentos de medida.[@REF]

<br>

### O que é precisão?

-   Precisão se refere à proximidade de concordância entre resultados de testes independentes obtidos nas mesmas condições de teste.[@menditto2006]

-   Precisão é um índice de quão próximo os resultados podem ser repetidos entre mensurações repetidas.[@Streiner2006]

-   Precisão está para medidas como confiabilidade está para instrumentos de medida.[@REF]

<br>

```{r acuracia-precisao, echo = FALSE, warning = FALSE, message = FALSE, appendix = TRUE, fig.align = 'center', layout='Blank', ph=officer::ph_location_fullsize(), results = "asis", fig.cap = "Acurácia e precisão como propriedades de uma medida."}
# função para criar o alvo
make_target_plot <- function(title, m_shift = 0, sd_spread = 0.1) {
  tibble::tibble(
    x = runif(10, min = m_shift - sd_spread, max = m_shift + sd_spread),
    y = runif(10, min = m_shift - sd_spread, max = m_shift + sd_spread)
  ) %>%
    ggplot2::ggplot(ggplot2::aes(x = x, y = y)) +
    # círculos concêntricos maiores
    ggplot2::geom_point(ggplot2::aes(x = 0, y = 0), shape = 21, size = 40, fill = "gray80", color = "black") +
    ggplot2::geom_point(ggplot2::aes(x = 0, y = 0), shape = 21, size = 36, fill = "white", color = "white") +
    ggplot2::geom_point(ggplot2::aes(x = 0, y = 0), shape = 21, size = 32, fill = "gray70", color = "gray70") +
    ggplot2::geom_point(ggplot2::aes(x = 0, y = 0), shape = 21, size = 28, fill = "white", color = "white") +
    ggplot2::geom_point(ggplot2::aes(x = 0, y = 0), shape = 21, size = 24, fill = "gray60", color = "gray60") +
    ggplot2::geom_point(ggplot2::aes(x = 0, y = 0), shape = 21, size = 20, fill = "white", color = "white") +
    ggplot2::geom_point(ggplot2::aes(x = 0, y = 0), shape = 21, size = 16,  fill = "gray50", color = "gray50") +
    ggplot2::geom_point(ggplot2::aes(x = 0, y = 0), shape = 21, size = 12,  fill = "white", color = "white") +
    # pontos aleatórios
    ggplot2::geom_point(shape = 4, size = 4, stroke = 1.2, color = "black") +
    ggplot2::coord_fixed(xlim = c(-1.0, 1.0), ylim = c(-1.0, 1.0)) +
    ggplot2::theme_void() +
    ggplot2::ggtitle(title)
}

# reprodutibilidade
set.seed(1234)

# quatro plots
p1 <- make_target_plot("Acurácia alta, Precisão alta", m_shift = 0,   sd_spread = 0.1)
p2 <- make_target_plot("Acurácia baixa, Precisão alta", m_shift = 0.3, sd_spread = 0.1)
p3 <- make_target_plot("Acurácia alta, Precisão baixa", m_shift = 0,   sd_spread = 0.3)
p4 <- make_target_plot("Acurácia baixa, Precisão baixa", m_shift = 0.3, sd_spread = 0.3)

# grid 2x2
gridExtra::grid.arrange(p1, p2, p3, p4, ncol = 2)
