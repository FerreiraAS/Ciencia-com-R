# restart all variables
rm(list = ls(all = TRUE))

# install and load required packages
packages <- c("mediation", "diagram", "readxl")
# Install packages not yet installed
installed_packages <- packages %in% rownames(installed.packages())
if (any(installed_packages == FALSE)) {
    install.packages(packages[!installed_packages])
}
# Packages loading
invisible(lapply(packages, library, character.only = TRUE))

# number of decimal digits to show
signif <- 2

# set level for evidence of statistical significance
alpha <- 0.05

# LOADING THE DATASET (replace with filename and worksheet)
banco_med <- data.frame(read_excel("Data.xlsx", sheet = 1))

# SELECT GROUPS FOR ANALYSIS Group 1: manipulation Group 2: myofascial Group 3:
# placebo
col.interv <- which(colnames(banco_med) == "Intervention")

attach(banco_med)
datasets <- list(T1 = banco_med)

# BUILDING THE MODELS

# X: TREATMENT (INTERVENTION) VARIABLE (same for all models to be tested)
# Manipulation vs. Myofascial (1 vs. 2)
banco_med <- banco_med[which(banco_med[, col.interv] == 1 | banco_med[, col.interv] ==
    2), ]
Intervention <- factor(Intervention, levels = c(1, 2), labels = c(1, 0))

# Manipulation vs. Placebo (1 vs. 3) banco_med <- banco_med[which(banco_med[,
# col.interv]==1 | banco_med[, col.interv]==3), ] Intervention <-
# factor(Intervention, levels = c(1,3), labels = c(1,0))

# factor 'group', dichotomous, numeric, Intervention (Treatment) group
Intervention <- relevel(Intervention, ref = "0")
treatment <- c("Intervention")


# Y: OUTCOME VARIABLES (same for all models to be tested)
outcome.main <- c("RMSSD_A", "LFms._A", "HFms._A", "LFun_A", "HFun_A", "LFHF_A")
outcome.name <- c("Heart rate variability")


# Z: COVARIATES (one for each outcome variable)
covariates_1 <- c("RMSSD + PAsistólicaprétestepréinterv + PAdiastólicaprétestepréinterv")
covariates_2 <- c("LFms. + PAsistólicaprétestepréinterv + PAdiastólicaprétestepréinterv")
covariates_3 <- c("HFms. + PAsistólicaprétestepréinterv + PAdiastólicaprétestepréinterv")
covariates_4 <- c("LFun + PAsistólicaprétestepréinterv + PAdiastólicaprétestepréinterv")
covariates_5 <- c("HFun + PAsistólicaprétestepréinterv + PAdiastólicaprétestepréinterv")
covariates_6 <- c("LFHF + PAsistólicaprétestepréinterv + PAdiastólicaprétestepréinterv")

# group all covariates for loop (include all covariates above in the data
# structure below)
covs <- c(covariates_1, covariates_2, covariates_3, covariates_4, covariates_5, covariates_6)
covs.all <- list(cbind(RMSSD, PAsistólicaprétestepréinterv, PAdiastólicaprétestepréinterv),
    cbind(LFms., PAsistólicaprétestepréinterv, PAdiastólicaprétestepréinterv),
    cbind(HFms., PAsistólicaprétestepréinterv, PAdiastólicaprétestepréinterv),
    cbind(LFun, PAsistólicaprétestepréinterv, PAdiastólicaprétestepréinterv),
    cbind(HFun, PAsistólicaprétestepréinterv, PAdiastólicaprétestepréinterv),
    cbind(LFHF, PAsistólicaprétestepréinterv, PAdiastólicaprétestepréinterv))


# M: MEDIATORS (one for each model to be tested)
mediators_1 <- c("tempocomdoremmeses")
mediators_2 <- c("intensidade")
mediators_3 <- c("DeltaPASistólicaPréIntervenção")
meds <- c(mediators_1, mediators_2, mediators_3)

# labels for exhibition
name_1 <- c("Pain duration")
name_2 <- c("Pain intensity")
name_3 <- c("Change in SBP")
names <- c(name_1, name_2, name_3)


# BATCH ANALYSIS
for (k in 1:length(outcome.main)) {
    # loop through each outcome

    outcome <- outcome.main[k]  # select the current outcome for analysis

    # START TABLE OF RESULTS
    labels <- c("Mediator", "Interv-Med Effect (a)", "Med-Outcome Effect (b)", "Direct effect of X on Y (c')",
        "Total effect of X on Y (c)", "Indirect effect of X on Y (ab)", "Prop. Med. (%)",
        "Mediator?")
    RESULTS <- matrix(NA, ncol = length(labels), nrow = length(meds))
    colnames(RESULTS) <- labels

    # mediation analysis for each model in meds[i] and covs[i]
    for (i in 1:length(meds)) {
        # show which model is running
        print(paste("Running model # ", i, ": ", outcome, " ~ ", treatment, " | ",
            meds[i], " + ", covs[k], sep = ""), quote = FALSE)

        # SELECT MEDIATOR FOR THIS ITERATION
        RESULTS[i, 1] <- meds[i]

        # testing the effect of X in M
        path_A <- lm(datasets$T1[, which(colnames(datasets$T1) == meds[i])] ~ Intervention +
            covs.all[[k]])
        est <- format(round(summary(path_A)[[4]][2], digits = signif), nsmall = signif)
        ci_low <- format(round(confint(path_A)[2, 1], digits = signif), nsmall = signif)
        ci_up <- format(round(confint(path_A)[2, 2], digits = signif), nsmall = signif)
        p.value <- summary(path_A)[[4]][2, 4]
        p.value_A <- format(round(p.value, digits = signif), nsmall = signif)
        RESULTS[i, 2] <- paste(est, " (", ci_low, " to ", ci_up, ")", if (p.value <
            alpha) {
            "*"
        }, if (p.value < 0.01) {
            "*"
        }, if (p.value < 0.001) {
            "*"
        }, sep = "")
        a <- paste("'", est, if (p.value < alpha) {
            "*"
        }, if (p.value < 0.01) {
            "*"
        }, if (p.value < 0.001) {
            "*"
        }, "'", sep = "")

        # testing the effect of M in Y while controled by X and Z
        path_B <- lm(datasets$T1[, which(colnames(datasets$T1) == outcome)] ~ datasets$T1[,
            which(colnames(datasets$T1) == meds[i])] + Intervention + covs.all[[k]])
        est <- format(round(summary(path_B)[[4]][2], digits = signif), nsmall = signif)
        ci_low <- format(round(confint(path_B)[2, 1], digits = signif), nsmall = signif)
        ci_up <- format(round(confint(path_B)[2, 2], digits = signif), nsmall = signif)
        p.value <- format(round(summary(path_B)[[4]][2, 4], digits = signif), nsmall = signif)
        p.value_B <- p.value
        RESULTS[i, 3] <- paste(est, " (", ci_low, " to ", ci_up, ")", if (p.value <
            alpha) {
            "*"
        }, if (p.value < 0.01) {
            "*"
        }, if (p.value < 0.001) {
            "*"
        }, sep = "")
        b <- paste("'", est, if (p.value < alpha) {
            "*"
        }, if (p.value < 0.01) {
            "*"
        }, if (p.value < 0.001) {
            "*"
        }, "'", sep = "")

        # MODEL
        model <- mediations(datasets = datasets, treatment = treatment, mediators = meds[i],
            outcome = outcome, covariates = covs[k], interaction = FALSE, conf.level = 0.95)

        # ATE
        est <- format(round(summary(model)[[1]]$z.avg, digits = signif), nsmall = signif)
        ci_low <- format(round(summary(model)[[1]]$z.avg.ci[1], digits = signif),
            nsmall = signif)
        ci_up <- format(round(summary(model)[[1]]$z.avg.ci[2], digits = signif),
            nsmall = signif)
        p.value <- format(round(summary(model)[[1]]$z.avg.p, digits = signif), nsmall = signif)
        p.value_ATE <- p.value
        RESULTS[i, 4] <- paste(est, " (", ci_low, " to ", ci_up, ")", if (p.value <
            alpha) {
            "*"
        }, if (p.value < 0.01) {
            "*"
        }, if (p.value < 0.001) {
            "*"
        }, sep = "")
        c.prime <- paste("'", est, if (p.value < alpha) {
            "*"
        }, if (p.value < 0.01) {
            "*"
        }, if (p.value < 0.001) {
            "*"
        }, "'", sep = "")

        # ADE
        est <- format(round(summary(model)[[1]]$tau.coef, digits = signif), nsmall = signif)
        ci_low <- format(round(summary(model)[[1]]$tau.ci[1], digits = signif), nsmall = signif)
        ci_up <- format(round(summary(model)[[1]]$tau.ci[2], digits = signif), nsmall = signif)
        p.value <- format(round(summary(model)[[1]]$tau.p, digits = signif), nsmall = signif)
        p.value_ADE <- p.value
        RESULTS[i, 5] <- paste(est, " (", ci_low, " to ", ci_up, ")", if (p.value <
            alpha) {
            "*"
        }, if (p.value < 0.01) {
            "*"
        }, if (p.value < 0.001) {
            "*"
        }, sep = "")
        c <- paste("'", est, if (p.value < alpha) {
            "*"
        }, if (p.value < 0.01) {
            "*"
        }, if (p.value < 0.001) {
            "*"
        }, "'", sep = "")

        # ACME
        est <- format(round(summary(model)[[1]]$d.avg, digits = signif), nsmall = signif)
        ci_low <- format(round(summary(model)[[1]]$d.avg.ci[1], digits = signif),
            nsmall = signif)
        ci_up <- format(round(summary(model)[[1]]$d.avg.ci[2], digits = signif),
            nsmall = signif)
        p.value <- format(round(summary(model)[[1]]$d.avg.p, digits = signif), nsmall = signif)
        p.value_ACME <- p.value
        RESULTS[i, 6] <- paste(est, " (", ci_low, " to ", ci_up, ")", if (p.value <
            alpha) {
            "*"
        }, if (p.value < 0.01) {
            "*"
        }, if (p.value < 0.001) {
            "*"
        }, sep = "")

        # PROP MED
        est <- format(round(summary(model)[[1]]$n.avg, digits = signif), nsmall = signif)
        ci_low <- format(round(summary(model)[[1]]$n.avg.ci[1], digits = signif),
            nsmall = signif)
        ci_up <- format(round(summary(model)[[1]]$n.avg.ci[2], digits = signif),
            nsmall = signif)
        p.value <- format(round(summary(model)[[1]]$n.avg.p, digits = signif), nsmall = signif)
        p.value_PM <- p.value
        RESULTS[i, 7] <- paste(est, " (", ci_low, " to ", ci_up, ")", if (p.value <
            alpha) {
            "*"
        }, if (p.value < 0.01) {
            "*"
        }, if (p.value < 0.001) {
            "*"
        }, sep = "")

        # check if M is a mediator
        if (all(as.numeric(p.value_ADE) < alpha, as.numeric(p.value_A) < alpha, as.numeric(p.value_B) <
            alpha)) {
            RESULTS[i, 8] <- "Yes"
            # show plot if M is a mediator
            dev.new()
            layout(c(1, 2), height = c(1, 2))
            par(mar = c(1, 1, 1, 1), cex = 0.8)
            # apresenta o diagrama direto
            diag.1 <- matrix(nrow = 2, ncol = 2, byrow = TRUE, data = c(0, 0, c,
                0))
            plot <- plotmat(diag.1, pos = c(2), name = c(treatment, outcome.name),
                box.type = "rect", box.size = 0.12, box.prop = 0.5, curve = 0, shadow.size = 0,
                dtext = 0.5)
            title("Model A", line = -1, adj = 0)
            # apresenta o diagrama da mediacao
            diag.2 <- matrix(nrow = 3, ncol = 3, byrow = TRUE, data = c(0, a, 0,
                0, 0, 0, b, c.prime, 0))
            plot <- plotmat(diag.2, pos = c(1, 2), name = c(names[i], treatment,
                outcome.name), box.type = "rect", box.size = 0.12, box.prop = 0.5,
                curve = 0, shadow.size = 0, dtext = 0.5)
            title("Model B", line = -1, adj = 0)
        } else {
            RESULTS[i, 8] <- "No"
        }
    }

    # apresenta a tabela de resultados no console
    print(RESULTS, quote = FALSE)
    print("Unstandardized coefficients with 95% confidence intervals.", quote = FALSE)
    print("Binary model presented as an odds ratio", quote = FALSE)
    print("*P<0.05, **P<0.01, ***P<0.001", quote = FALSE)
    print("", quote = FALSE)
    print("", quote = FALSE)

    # separate outputs in multiple calls
    pb1 = txtProgressBar(min = 0, max = 1, initial = 0)
    for (y in 1:1) {
        setTxtProgressBar(pb1, y)
    }
}

# UNLOADING THE DATASET (replace with filename and worksheet)
detach(banco_med)
