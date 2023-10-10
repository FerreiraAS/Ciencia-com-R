# REINICIA TODAS AS VARIÁVEIS
rm(list = ls(all = TRUE))

# INSTALA E ABRE OS PACOTES UTILIZADOS
# most packages work fine if installed from CRAN
packs.cran <-
  c(
    "dplyr",
    "readxl",
    "table1",
    "flextable"
  )
for (i in 1:length(packs.cran)) {
  if (!require(packs.cran[i], character.only = TRUE, quietly = TRUE))
    install.packages(packs.cran[i], character.only = TRUE)
}

source("crossover.R")

# CARREGA O BANCO
banco_RSTR <-
  data.frame(read_excel("dados_msc_RSTR.xlsx", sheet = 1))

# compute secondary variables
banco_RSTR$IMC <- banco_RSTR$Peso / (banco_RSTR$Altura ^ 2)

# calibrate load cell
# coefficients
a <- 0.704
b <- 2.401
# equations
X <- banco_RSTR$Celula_VM_Antes_F1
banco_RSTR$Celula_VM_Antes_F1 <- a * X + b
X <- banco_RSTR$Celula_BF_Antes_F1
banco_RSTR$Celula_BF_Antes_F1 <- a * X + b
X <- banco_RSTR$Celula_VM_Depois_F1
banco_RSTR$Celula_VM_Depois_F1 <- a * X + b
X <- banco_RSTR$Celula_BF_Depois_F1
banco_RSTR$Celula_BF_Depois_F1 <- a * X + b

X <- banco_RSTR$Celula_VM_Antes_F2
banco_RSTR$Celula_VM_Antes_F2 <- a * X + b
X <- banco_RSTR$Celula_BF_Antes_F2
banco_RSTR$Celula_BF_Antes_F2 <- a * X + b
X <- banco_RSTR$Celula_VM_Antes_F2
banco_RSTR$Celula_VM_Depois_F2 <- a * X + b
X <- banco_RSTR$Celula_VM_Depois_F2
banco_RSTR$Celula_VM_Depois_F2 <- a * X + b

# REMOVE LINES with no participants included
banco_RSTR <- banco_RSTR[complete.cases(banco_RSTR[, 1:14]),]

# #################################################

# LABEL FACTORS
banco_RSTR$sequence <-
  factor(
    banco_RSTR$sequence,
    levels = c("AB", "BA"),
    labels = c(
      "Stretching - Myofascial release",
      "Myofascial release - Stretching"
    )
  )
label(banco_RSTR$sequence) <- "Sequence"

label(banco_RSTR$Idade) <- "Age"
units(banco_RSTR$Idade) <- "years"

label(banco_RSTR$Peso) <- "Body mass"
units(banco_RSTR$Peso) <- "kg"

label(banco_RSTR$Altura) <- "Body height"
units(banco_RSTR$Altura) <- "m"

label(banco_RSTR$IMC) <- "Body mass index"
units(banco_RSTR$IMC) <- "kg/m2"

banco_RSTR$Sexo <-
  factor(banco_RSTR$Sexo,
         levels = c("F", "M"),
         labels = c("Female", "Male"))
label(banco_RSTR$Sexo) <- "Sex"

banco_RSTR$Raça <-
  factor(
    banco_RSTR$Raça,
    levels = c("Branca", "Parda", "Preta"),
    labels = c("White", "Brown", "Black")
  )
label(banco_RSTR$Raça) <- "Race"

attach(banco_RSTR)

# #################################################

# GENERATE TABLE 1 (part 1)
tbl1 <- table1(~  Idade + Peso + Altura + IMC + Sexo + Raça,
               data = banco_RSTR)
# Convert to flextable
t1flex(tbl1) %>%
  save_as_docx(path = "Table 1.docx")

# #################################################

test <- crossover.test(
  sequence = sequence,
  AB = "Stretching - Myofascial release",
  BA = "Myofascial release - Stretching",
  pre_F1 = Wells.A_F1,
  post_F1 = Wells.D_F1,
  pre_F2 = Wells.A_F2,
  post_F2 = Wells.D_F2,
  mean.imput = TRUE,
  alpha = 0.05,
  carryover.alpha = 0.10
)
result.T <- test[[1]]
carryover <- test[[2]]
result.D <- test[[3]]
table2 <- test[[4]]
missings <- test[[5]]

# Convert to flextable
flextable(as.data.frame(table2, row.names = rownames(table2))) %>%
  footnote(
    i = 1,
    j = c(8, 8, 8),
    value = as_paragraph(c(
      paste(result.T, carryover, sep = ". "), result.D, missings
    )),
    part = "header",
    ref_symbols = c("a", "b", "c"),
    inline = TRUE,
    sep = "\n"
  ) %>%
  save_as_docx(path = "Table 2 - ROM.docx")

# #################################################

test <- crossover.test(
  sequence = sequence,
  AB = "Stretching - Myofascial release",
  BA = "Myofascial release - Stretching",
  pre_F1 = EMG_BF_Antes_F1,
  post_F1 = EMG_BF_Depois_F1,
  pre_F2 = EMG_BF_Antes_F2,
  post_F2 = EMG_BF_Depois_F2,
  mean.imput = TRUE,
  alpha = 0.05,
  carryover.alpha = 0.10
)
result.T <- test[[1]]
carryover <- test[[2]]
result.D <- test[[3]]
table2 <- test[[4]]
missings <- test[[5]]

# Convert to flextable
flextable(as.data.frame(table2, row.names = rownames(table2))) %>%
  footnote(
    i = 1,
    j = c(8, 8, 8),
    value = as_paragraph(c(
      paste(result.T, carryover, sep = ". "), result.D, missings
    )),
    part = "header",
    ref_symbols = c("a", "b", "c"),
    inline = TRUE,
    sep = "\n"
  ) %>%
  save_as_docx(path = "Table 2 - EMG BF.docx")

# #################################################

test <- crossover.test(
  sequence = sequence,
  AB = "Stretching - Myofascial release",
  BA = "Myofascial release - Stretching",
  pre_F1 = EMG_VM_Antes_F1,
  post_F1 = EMG_VM_Depois_F1,
  pre_F2 = EMG_VM_Antes_F2,
  post_F2 = EMG_VM_Depois_F2,
  mean.imput = TRUE,
  alpha = 0.05,
  carryover.alpha = 0.10
)
result.T <- test[[1]]
carryover <- test[[2]]
result.D <- test[[3]]
table2 <- test[[4]]
missings <- test[[5]]

# Convert to flextable
flextable(as.data.frame(table2, row.names = rownames(table2))) %>%
  footnote(
    i = 1,
    j = c(8, 8, 8),
    value = as_paragraph(c(
      paste(result.T, carryover, sep = ". "), result.D, missings
    )),
    part = "header",
    ref_symbols = c("a", "b", "c"),
    inline = TRUE,
    sep = "\n"
  ) %>%
  save_as_docx(path = "Table 2 - EMG VM.docx")

# #################################################

test <- crossover.test(
  sequence = sequence,
  AB = "Stretching - Myofascial release",
  BA = "Myofascial release - Stretching",
  pre_F1 = Celula_BF_Antes_F1,
  post_F1 = Celula_BF_Depois_F1,
  pre_F2 = Celula_BF_Antes_F2,
  post_F2 = Celula_BF_Depois_F2,
  mean.imput = TRUE,
  alpha = 0.05,
  carryover.alpha = 0.10
)
result.T <- test[[1]]
carryover <- test[[2]]
result.D <- test[[3]]
table2 <- test[[4]]
missings <- test[[5]]

# Convert to flextable
flextable(as.data.frame(table2, row.names = rownames(table2))) %>%
  footnote(
    i = 1,
    j = c(8, 8, 8),
    value = as_paragraph(c(
      paste(result.T, carryover, sep = ". "), result.D, missings
    )),
    part = "header",
    ref_symbols = c("a", "b", "c"),
    inline = TRUE,
    sep = "\n"
  ) %>%
  save_as_docx(path = "Table 2 - Dinamometria BF.docx")

# #################################################

test <- crossover.test(
  sequence = sequence,
  AB = "Stretching - Myofascial release",
  BA = "Myofascial release - Stretching",
  pre_F1 = Celula_VM_Antes_F1,
  post_F1 = Celula_VM_Depois_F1,
  pre_F2 = Celula_VM_Antes_F2,
  post_F2 = Celula_VM_Depois_F2,
  mean.imput = TRUE,
  alpha = 0.05,
  carryover.alpha = 0.10
)
result.T <- test[[1]]
carryover <- test[[2]]
result.D <- test[[3]]
table2 <- test[[4]]
missings <- test[[5]]

# Convert to flextable
flextable(as.data.frame(table2, row.names = rownames(table2))) %>%
  footnote(
    i = 1,
    j = c(8, 8, 8),
    value = as_paragraph(c(
      paste(result.T, carryover, sep = ". "), result.D, missings
    )),
    part = "header",
    ref_symbols = c("a", "b", "c"),
    inline = TRUE,
    sep = "\n"
  ) %>%
  save_as_docx(path = "Table 2 - Dinamometria VM.docx")

# #################################################

detach(banco_RSTR)