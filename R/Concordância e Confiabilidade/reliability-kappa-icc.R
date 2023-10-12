# RESTART ALL VARIABLES
rm(list = ls(all = TRUE))

# install and load required packages
packages <- c("readxl", "psych")
# Install packages not yet installed
installed_packages <-
  packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(packages[!installed_packages])
}
# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

# SIGNIFICANCE LEVEL
alpha <- 0.05

# CUSTOM-MADE FUNCTION
omega_sq <- function(aovm) {
  sum_stats <- summary(aovm)[[1]]
  SSm <- sum_stats[["Sum Sq"]][1]
  SSr <- sum_stats[["Sum Sq"]][2]
  DFm <- sum_stats[["Df"]][1]
  MSr <- sum_stats[["Mean Sq"]][2]
  W2 <- (SSm - DFm * MSr) / (SSm + SSr + MSr)
  return(W2)
}

# READ FILES
names <- c("maria", "michele")
n.raters <- length(names)
maria <- data.frame(read_excel("rater1.xlsx", sheet = names[1]))
michele <- data.frame(read_excel("rater2.xlsx", sheet = names[2]))
raters.data <- rbind(maria, michele)
balanced.data.1 <- complete.cases(maria)
balanced.data.2 <- complete.cases(michele)
balanced.data <- rep(balanced.data.1 == balanced.data.2, 2)
raters.data <- raters.data[balanced.data, ]
variables <- seq(1:dim(raters.data)[2])[c(4)]
data <- rbind(maria, michele)[balanced.data, variables]
ID <- seq(1:(sum(balanced.data == TRUE) / 2))

# #############################################################################

# separate outputs in multiple calls
pb1 = txtProgressBar(min = 0, max = 1, initial = 0)
for (y in 1:1) {
  setTxtProgressBar(pb1, y)
}
print("", quote = FALSE)
print("", quote = FALSE)
print("COHEN'S KAPPA - SIGNAL QUALITY BY VISUAL INSPECTION", quote = FALSE)
print("", quote = FALSE)

# SELECT DATA FOR EACH RATER
rater1 <- data[which(raters.data$Examinador == names[1])]
rater1 <-
  ordered(rater1,
          levels = c("Alta qualidade", "Moderada qualidade", "Baixa qualidade"))
rater2 <- data[which(raters.data$Examinador == names[2])]
rater2 <-
  ordered(rater2,
          levels = c("Alta qualidade", "Moderada qualidade", "Baixa qualidade"))

baseline <- raters.data[, 5]
baseline1 <- baseline[which(raters.data$Examinador == names[1])]
signal1 <-
  rowMeans(raters.data[which(raters.data$Examinador == names[1]), c(9, 19, 29)])
SNR.1 <- 10 * log(signal1 / baseline1)
m1 <- tapply(SNR.1, rater1, mean)
sd1 <- tapply(SNR.1, rater1, sd)
sum1 <- (paste(round(m1, 1), " (", round(sd1, 1), ")", sep = ""))
baseline2 <- baseline[which(raters.data$Examinador == names[2])]
signal2 <-
  rowMeans(raters.data[which(raters.data$Examinador == names[1]), c(9, 19, 29)])
SNR.2 <- 10 * log(signal2 / baseline2)
m2 <- tapply(SNR.2, rater2, mean)
sd2 <- tapply(SNR.2, rater2, sd)
sum2 <- (paste(round(m2, 1), " (", round(sd2, 1), ")", sep = ""))

print("Table 1: Cross-table of qualitative assessment between raters.",
      quote = FALSE)
print(matrix(
  paste(
    table(rater1, rater2),
    " (",
    round(table(rater1, rater2) / length(ID) * 100, digits = 1),
    "%)",
    sep = ""
  ),
  nrow = 3,
  ncol = 3,
  dimnames = list(levels(rater1), levels(rater1))
), quote = FALSE)
K <- cohen.kappa(cbind(rater1, rater2), alpha = 0.05)
print(
  paste(
    "Cohen Kappa (unweighted) = ",
    round(K[[8]][1, 2], digits = 3),
    ", 95%CI = [",
    round(K[[8]][1, 1], digits = 3),
    "; ",
    round(K[[8]][1, 3], digits = 3),
    "]",
    sep = ""
  ),
  quote = FALSE
)

print(paste("SNR", names[1]), quote = FALSE)
print(rbind(table(rater1), sum1), quote = FALSE)
print("", quote = FALSE)
print(paste("SNR", names[2]), quote = FALSE)
print(rbind(table(rater2), sum2), quote = FALSE)
print("", quote = FALSE)
print("", quote = FALSE)

# #############################################################################

# separate outputs in multiple calls
pb2 = txtProgressBar(min = 0, max = 1, initial = 0)
for (y in 1:1) {
  setTxtProgressBar(pb2, y)
}
print("", quote = FALSE)
print("", quote = FALSE)
print("ICC - INTRA-RATER RELIABILITY", quote = FALSE)
print("", quote = FALSE)

# DROP IRRELEVANT DATA
variables <- seq(1:dim(raters.data)[2])[c(-2:-8)]
data <- rbind(maria, michele)[balanced.data, variables]

# STORE DATA FOR INTERRATER RELIABILITY
inter.df <- data.frame(NA)

# SELECT DATA FOR EACH RATER
rater1 <- data[which(data$Examinador == names[1]), ]
rater2 <- data[which(data$Examinador == names[2]), ]

for (i in 1:n.raters) {
  print(paste("Rater: ", toupper(names[i]), sep = ""), quote = FALSE)
  for (k in 2:9) {
    # separate data for analysis
    temp <-
      cbind(data[which(data$Examinador == names[i]), k], data[which(data$Examinador == names[i]), k + 10], data[which(data$Examinador == names[i]), k + 20])
    colnames(temp) <-
      c(colnames(data)[k], colnames(data)[k + 10], colnames(data)[k + 20])
    
    # calculate ICC model and print outputs
    print("Table 2: Intrarater (test-retest) assessment.", quote = FALSE)
    print(
      describe(
        temp,
        interp = FALSE,
        skew = FALSE,
        ranges = FALSE,
        trim = 0.1,
        type = 3,
        check = TRUE,
        IQR = FALSE,
        omit = FALSE
      ),
      quote = FALSE
    )
    model <- ICC(temp, alpha)
    print(rbind(model[[1]][2, ], model[[1]][5, ]), quote = FALSE)
    
    # store data for interrater reliability (AVERAGE OF TRIALS)
    avg.trials <- rowMeans(temp)
    inter.df <- cbind.data.frame(inter.df, avg.trials)
    print("", quote = FALSE)
    print("", quote = FALSE)
  }
  print("", quote = FALSE)
  print("", quote = FALSE)
}

# drop empty column
inter.df <- inter.df[, -1]
variables <-
  sapply(strsplit(colnames(data)[2:9], split = "_AP", fixed = TRUE), function(x)
    (x[1]))
colnames(inter.df) <-
  paste(rep(variables, 2), c(rep(1, length(variables)), rep(2, length(variables))))

# #############################################################################

# separate outputs in multiple calls
pb3 = txtProgressBar(min = 0, max = 1, initial = 0)
for (y in 1:1) {
  setTxtProgressBar(pb3, y)
}
print("", quote = FALSE)
print("", quote = FALSE)
print("ICC - INTER-RATER RELIABILITY", quote = FALSE)
print("", quote = FALSE)

# CALCULATE DESCRIPTIVE SUMMARIES (ANOVA model) AND ICC
labels <-
  c("Rater #1, Mean (SD)",
    "Rater #2, Mean (SD)",
    "P-value",
    "Omega-sqr")
results.summ <-
  matrix(NA, nrow = length(variables), ncol = length(labels))
colnames(results.summ) <- labels
rownames(results.summ) <- variables
for (i in 1:length(variables)) {
  # summary statistics
  results.summ[i, 1] <-
    paste(format(round(mean(inter.df[, i]), digits = 1), nsmall = 1),
          " (",
          format(round(sd(inter.df[, i]), digits = 1), nsmall = 1),
          ")",
          sep = "")
  results.summ[i, 2] <-
    paste(format(round(mean(inter.df[, i + length(variables)]), digits = 1), nsmall = 1),
          " (",
          format(round(sd(inter.df[, i + length(variables)]), digits = 1),
                 nsmall = 1),
          ")",
          sep = "")
  
  # anova model
  Y <- c(inter.df[, i], inter.df[, i + length(variables)])
  X <- data$Examinador
  results.summ[i, 3] <-
    format(round(anova(lm(Y ~ X))[[5]][1], digits = 3), nsmall = 3)
  results.summ[i, 4] <-
    format(round(omega_sq(aov(lm(
      Y ~ X
    ))), digits = 3), nsmall = 3)
  
  # icc
  # separate data for analysis
  temp <- cbind(inter.df[, i], inter.df[, i + length(variables)])
  colnames(temp) <- paste(variables[i], seq(1:n.raters))
  print(paste("Variables: ", paste(colnames(temp), collapse = ", "), sep = ""), quote = FALSE)
  
  # calculate ICC model and print outputs
  print("Table 3: Interrater (k = 2) reliability assessment.", quote = FALSE)
  print(
    describe(
      temp,
      interp = FALSE,
      skew = FALSE,
      ranges = FALSE,
      trim = 0.1,
      type = 3,
      check = TRUE,
      IQR = FALSE,
      omit = FALSE
    ),
    quote = FALSE
  )
  model <- ICC(temp, alpha)
  print(rbind(model[[1]][2, ], model[[1]][5, ]), quote = FALSE)
  print("", quote = FALSE)
  print("", quote = FALSE)
}
print("Table 3: Descriptive summary of repeated trials.", quote = FALSE)
print(results.summ, quote = FALSE)
print("", quote = FALSE)

# END
# #############################################################################
