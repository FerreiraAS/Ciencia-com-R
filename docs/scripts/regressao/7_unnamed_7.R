# Definir semente
set.seed(123)

# Simular dados
n <- 100
x1 <- stats::rnorm(n, mean = 50, sd = 10)
x2 <- stats::rnorm(n, mean = 30, sd = 5)
erro <- stats::rnorm(n, mean = 0, sd = 5)
y <- 10 + 0.5 * x1 - 0.3 * x2 + erro

# Data frame
dados <- data.frame(y = y, x1 = x1, x2 = x2)

# Modelo
modelo <- stats::lm(y ~ x1 + x2, data = dados)

# Dados auxiliares para gráficos
dados_diag <- dados %>%
  dplyr::mutate(
    Ajustado = stats::fitted(modelo),
    Resíduo = stats::resid(modelo),
    Resíduo_pad = stats::rstandard(modelo),
    Raiz_Resíduo_pad = sqrt(abs(Resíduo_pad)),
    Cook = stats::cooks.distance(modelo),
    Alavancagem = stats::hatvalues(modelo)
  )

# Gráfico 1: Resíduos vs Ajustados
g1 <- ggplot2::ggplot(dados_diag, ggplot2::aes(x = Ajustado, y = Resíduo)) +
  ggplot2::geom_point(color = "blue") +
  ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  ggplot2::labs(title = "Resíduos vs Ajustados", subtitle = "--- Resíduo = 0",
                x = "Valores Ajustados", y = "Resíduos") +
  ggplot2::theme_minimal()

# Gráfico 2: QQ Plot
g2 <- ggplot2::ggplot(dados_diag, ggplot2::aes(sample = Resíduo)) +
  ggplot2::stat_qq(color = "darkgreen") +
  ggplot2::stat_qq_line(color = "black", linetype = "dashed") +
  ggplot2::labs(title = "Normal Q-Q", subtitle = "--- Distribuição Normal Teórica",
                x = "Quantis Teóricos", y = "Resíduos") +
  ggplot2::theme_minimal()

# Gráfico 3: Scale-Location
g3 <- ggplot2::ggplot(dados_diag, ggplot2::aes(x = Ajustado, y = Raiz_Resíduo_pad)) +
  ggplot2::geom_point(color = "orange") +
  ggplot2::geom_hline(yintercept = 0, linetype = "dashed", color = "black") +
  ggplot2::labs(title = "Scale-Location", subtitle = "--- Referência visual",
                x = "Valores Ajustados", y = "√|Resíduos Padronizados|") +
  ggplot2::theme_minimal()

# Gráfico 4: Distância de Cook
g4 <- ggplot2::ggplot(dados_diag, ggplot2::aes(x = seq_along(Cook), y = Cook)) +
  ggplot2::geom_segment(ggplot2::aes(xend = seq_along(Cook), yend = 0), color = "purple") +
  ggplot2::geom_hline(yintercept = 4/n, linetype = "dashed", color = "black") +
  ggplot2::labs(title = "Distância de Cook", subtitle = "--- Limite sugerido (4/n)",
                x = "Observação", y = "Distância") +
  ggplot2::theme_minimal()

# Gráfico 5: Observado vs Ajustado
lim <- range(c(dados_diag$y, dados_diag$Ajustado))
g5 <- ggplot2::ggplot(dados_diag, ggplot2::aes(x = y, y = Ajustado)) +
  ggplot2::geom_point(color = "darkblue") +
  ggplot2::geom_abline(intercept = 0, slope = 1, linetype = "dashed", color = "black") +
  ggplot2::coord_cartesian(xlim = lim, ylim = lim) +
  ggplot2::labs(title = "Observado vs Ajustado", subtitle = "--- y = x",
                x = "Valores Observados", y = "Valores Ajustados") +
  ggplot2::theme_minimal()

# Gráfico 6: Alavancagem
g6 <- ggplot2::ggplot(dados_diag, ggplot2::aes(x = seq_along(Alavancagem), y = Alavancagem)) +
  ggplot2::geom_point(color = "darkred") +
  ggplot2::geom_hline(yintercept = 2 * mean(dados_diag$Alavancagem), linetype = "dashed", color = "black") +
  ggplot2::labs(title = "Alavancagem", subtitle = "--- 2 × média",
                x = "Observação", y = "Valores de Alavancagem") +
  ggplot2::theme_minimal()

# Organizar os 6 gráficos em 2x3
gridExtra::grid.arrange(g1, g2, g3, g4, g5, g6, nrow = 2)
