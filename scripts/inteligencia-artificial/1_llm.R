# -----------------------------------------------
# Demo visual: "Como funciona (simplificadamente) um LLM"
# - Tokenização
# - Atenção (toy): último token "olha" para os anteriores
# - Predição do próximo token (toy) com embeddings + softmax
# - Gera uma figura com 3 painéis
# -----------------------------------------------

# Pacotes (instala se faltar)
pkgs <- c("ggplot2","dplyr","stringr","tidyr","scales","gridExtra")
to_install <- pkgs[!pkgs %in% rownames(installed.packages())]
if (length(to_install) > 0) install.packages(to_install, quiet = TRUE)
lapply(pkgs, library, character.only = TRUE)

set.seed(42)  # reprodutibilidade

# --------------------------
# 1) Texto e tokenização
# --------------------------
texto <- "Os modelos de linguagem grandes (LLMs) aprendem padrões e sugerem o próximo token."

# Tokenizador simples: palavras, números, abreviações e pontuação
tokens <- stringr::str_extract_all(texto, "[\\p{L}\\p{N}]+(?:['’][\\p{L}\\p{N}]+)?|[[:punct:]]", simplify = FALSE)[[1]]
tokens <- tokens[tokens != ""]
tokens_df <- tibble::tibble(idx = seq_along(tokens), token = tokens)

# --------------------------
# 2) "Mini-LLM" ilustrativo
#    Embeddings aleatórios + atenção toy + softmax
# --------------------------
# Vocabulário = tokens do texto + alguns candidatos de próxima palavra
candidatos <- c("e","então","porque","mas","gato","cachorro","token","modelo",".",",")
vocab <- unique(c(tokens, candidatos))

d <- 32  # dimensão do embedding (toy)
E <- matrix(rnorm(length(vocab) * d), nrow = length(vocab), ncol = d)
rownames(E) <- vocab

# Mapeia cada token ao seu embedding
emb_for <- function(tok) E[as.character(tok), , drop = FALSE]

# Contexto = média dos embeddings dos tokens já vistos
contexto <- apply(do.call(rbind, lapply(tokens, emb_for)), 2, mean)

# Logits ~ similaridade (produto interno) com o contexto
logits <- as.numeric(E %*% contexto)
names(logits) <- vocab

# Softmax com temperatura
softmax <- function(x, temp = 0.8) {
  z <- x / temp
  z <- z - max(z)
  exp_z <- exp(z)
  exp_z / sum(exp_z)
}
probs <- softmax(logits, temp = 0.8)
pred_df <- tibble::tibble(token = names(probs), prob = probs) |>
  dplyr::arrange(dplyr::desc(prob))

top_k <- 10
pred_top <- pred_df |> dplyr::slice(1:top_k) |>
  dplyr::mutate(token = factor(token, levels = rev(token)))

# --------------------------
# 3) Atenção "toy"
#    Último token (query) atendendo aos anteriores (keys)
# --------------------------
# Para a atenção, criamos Q e K a partir de E (projeções lineares aleatórias)
Wq <- matrix(rnorm(d * d), nrow = d, ncol = d)
Wk <- matrix(rnorm(d * d), nrow = d, ncol = d)

# Keys: um por token da sequência
K_mat <- do.call(rbind, lapply(tokens, function(tk) emb_for(tk) %*% Wk))
# Query: do último token
q_vec <- as.numeric((emb_for(tail(tokens, 1)) %*% Wq)[1, ])

# Pesos de atenção do último token para todos os anteriores
att_logits <- as.numeric(K_mat %*% q_vec) / sqrt(d)
att_w <- softmax(att_logits, temp = 1.0)

att_df <- tibble::tibble(idx = seq_along(tokens), token = tokens, att = att_w)

# --------------------------
# 4) Figuras (3 painéis)
# --------------------------

# Painel A: sequência de tokens
pal <- scales::hue_pal()(length(unique(tokens)))
tokens_df <- tokens_df |>
  dplyr::mutate(tok_id = as.integer(factor(token)),
                y = 1)

# Painel A: sequência de tokens (sem cores, apenas moldura preta)
g_seq <- ggplot2::ggplot(tokens_df, ggplot2::aes(xmin = idx - 0.5, xmax = idx + 0.5,
                               ymin = 0.5, ymax = 1.5)) +
  ggplot2::geom_rect(fill = "white", color = "black") +
  ggplot2::geom_text(ggplot2::aes(x = idx, y = 1, label = token), size = 3) +
  ggplot2::scale_x_continuous(breaks = tokens_df$idx) +
  ggplot2::scale_y_continuous(NULL, breaks = NULL, limits = c(0.4, 1.6)) +
  ggplot2::labs(title = "A) Sequência de tokens (após tokenização)") +
  ggplot2::theme_minimal(base_size = 12) +
  ggplot2::theme(panel.grid = ggplot2::element_blank(),
        axis.title.x = ggplot2::element_blank(),
        axis.text.x = ggplot2::element_text(size = 8, vjust = 0.5))

# Painel B: atenção do último token para os anteriores
g_att <- ggplot2::ggplot(att_df, ggplot2::aes(x = idx, y = att)) +
  ggplot2::geom_col() +
  ggplot2::geom_text(ggplot2::aes(label = token), nudge_y = 0.02, size = 3, angle = 0) +
  ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
  ggplot2::scale_x_continuous(breaks = att_df$idx) +
  ggplot2::labs(title = paste0("B) Atenção do último token: \"", tail(tokens,1), "\""),
       x = "posição na sequência", y = "peso de atenção") +
  ggplot2::theme_minimal(base_size = 12)

# Painel C: top-k predições de próximo token (toy)
g_pred <- ggplot2::ggplot(pred_top, aes(x = token, y = prob)) +
  ggplot2::geom_col() +
  ggplot2::coord_flip() +
  ggplot2::scale_y_continuous(labels = scales::percent_format(accuracy = 0.1)) +
  ggplot2::labs(title = "C) Próximo token (top-10) – distribuição toy",
       x = NULL, y = "probabilidade") +
  ggplot2::theme_minimal(base_size = 12)

# Compor figura
gridExtra::grid.arrange(g_seq, g_att, g_pred, ncol = 1, heights = c(1.2, 1.2, 1.4))
