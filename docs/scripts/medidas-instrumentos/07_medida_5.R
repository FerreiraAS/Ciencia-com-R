```

<br>

::: {.infobox .Rlogo data-latex="{images/Rlogo}"}
O pacote *stats*[@stats] fornece a função [*aggregate*](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/aggregate) para agregar medidas repetidas utilizando uma função personalizada.
:::

<br>

### O que são medidas seriadas?

```{r k3, include = FALSE, echo = FALSE, warning = FALSE, message = FALSE, appendix = TRUE, fig.align = 'center', layout='Blank', ph=officer::ph_location_fullsize(), results = "hide"}
# sorteia participante para relatar no texto
set.seed(2)
k2 <- sample(1:10, 1)
