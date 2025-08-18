# generate data
gold.std <- rbinom(n = 100, size = 1, prob = 0.5)
new.test <- rbinom(n = 100, size = 1, prob = 0.5)
dataset <- data.frame("Padrão-ouro" = gold.std, "Novo teste" = new.test)

# change labels
my_txt <-
  riskyr::init_txt(
    cond_lbl = "Padrão-ouro",
    cond_true_lbl = "Presente",
    cond_false_lbl = "Ausente",
    hi_lbl = "VP",
    mi_lbl = "FN",
    fa_lbl = "FP",
    cr_lbl = "VN"
  )

# plot the frequency tree
riskyr::plot_prism(
  dataset,
  by = "cd",
  show_accu = TRUE,
  main = NULL,
  sub = NULL,
  col_pal = riskyr::pal_bw,
  f_lbl = "nam",
  p_lbl = "no",
  lbl_txt = my_txt,
  f_lwd = .5
)
