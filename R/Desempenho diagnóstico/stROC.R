# ‘stROC.R’ with the function for generating the single-threshold receiver-operating characteristic plot and related statistics

stROC <-
  function(continuous.test = NULL,
           dichotomous.test = NULL,
           precision = NULL,
           method = NULL,
           region = NULL,
           ties = NULL,
           n.samples = 1,
           alpha = 0.05,
           print = NULL) {
    # check the function input values
    if (length(continuous.test) == 0) {
      stop("The continuous test variable is empty.")
    }
    if (length(dichotomous.test) == 0) {
      stop("The dichotomous test variable is empty.")
    }
    if (nlevels(factor(dichotomous.test)) != 2) {
      stop("The dichotomous test variable does not have 2 levels.")
    }
    if (length(precision) == 0) {
      stop("The precision of the continuous test is absent.")
    }
    if ((method != "Youden" & method != "Yarnold")) {
      stop("The method for selecting the threshold is invalid. Please use Youden or Yarnold.")
    }
    if ((region != "upper" & region != "lower")) {
      stop(
        "The direction of the threshold that is associated with the presence of the outcome is invalid. Please use '<' or '>'."
      )
    }
    if ((ties != "max.sen" & ties != "max.spe")) {
      stop("The cost function for breaking ties is invalid. Please use 'max.sen' or 'max spe'.")
    }
    if (n.samples < 1) {
      stop("The number of samples must be =1 for original sample or >1 for bootstrap analysis.")
    }
    if ((alpha < 0 | alpha > 1) == TRUE) {
      stop("The alpha level is invalid.")
    }
    if (is.logical(print) == FALSE) {
      stop("The print command is invalid.")
    }
    
    results <-
      matrix("-", nrow = 1, ncol = 7) # create empty table of results
    colnames(results) <-
      c(
        "Cut-off",
        "AUC",
        paste(round((1 - alpha) * 100, 0), "%CI (lr, ur)", sep = ""),
        "SEN",
        paste(round((1 - alpha) *
                      100, 0), "%CI (lr, ur)", sep = ""),
        "SPE",
        paste(round((1 - alpha) * 100, 0), "%CI (lr, ur)", sep = "")
      )
    
    N <- length(dichotomous.test) # sample size
    B.sen <- rep(0, n.samples)
    B.spe <- rep(0, n.samples)
    B.auroc <- rep(0, n.samples)
    
    # loop for bootstrap analysis
    for (s in 1:n.samples) {
      ifelse(s == 1,
             samples <-
               seq(1:N),
             samples <-
               sample(seq(1:N), N, replace = TRUE)) # check whether resamplings are required
      
      # SINGLE-THRESHOLD
      T1 <-
        sort(unique(round(continuous.test[samples], digits = precision)), decreasing = TRUE) # create an ordered vector of test values without repetition
      T1 <-
        c(Inf, T1[-length(T1)] + diff(T1) / 2, -Inf) # create a vector of midpoint thresholds with prepended/postprended Inf values
      
      # scan all thresholds
      SEN <- rep(0, length(T1)) # empty sensitivity vector
      SPE <- rep(0, length(T1)) # empty specificity vector
      for (i in 1:length(T1)) {
        if (region == "upper") {
          SEN[i] <-
            sum(dichotomous.test[samples] == 1 &
                  continuous.test[samples] > T1[i]) / sum(dichotomous.test[samples] == 1) # calculate sensitivity
          SPE[i] <-
            sum(dichotomous.test[samples] == 0 &
                  continuous.test[samples] < T1[i]) / sum(dichotomous.test[samples] == 0) # calculate specificity
        }
        if (region == "lower") {
          SEN[i] <-
            sum(dichotomous.test[samples] == 1 &
                  continuous.test[samples] < T1[i]) / sum(dichotomous.test[samples] == 1) # calculate sensitivity
          SPE[i] <-
            sum(dichotomous.test[samples] == 0 &
                  continuous.test[samples] > T1[i]) / sum(dichotomous.test[samples] == 0) # calculate specificity
        }
      }
      
      Youden <- SPE + SEN - 1 # calculate Youden's index
      Yarnold <-
        sqrt((1 - SEN) ^ 2 + (1 - SPE) ^ 2) # calculate Yarnold distance to top-left corner
      if (method == "Yarnold") {
        indexes <- which(Yarnold == min(Yarnold))
      } # locate optimal threshold
      if (method == "Youden") {
        indexes <- which(Youden == max(Youden))
      } # locate optimal threshold
      
      # check and resolve for ties
      if (length(indexes) == 1) {
        # no ties
        cutoff <-
          round(as.numeric(T1[indexes]), digits = 3) # retain threshold
        sen <-
          as.numeric(SEN[indexes]) # retain sensitivity at threshold
        spe <-
          as.numeric(SPE[indexes]) # retain specificity at threshold
        ties.values <- "NA"
      }
      if (length(indexes) > 1) {
        # there are ties
        ties.values <-
          cbind(T1[indexes], SEN[indexes], SPE[indexes])
        colnames(ties.values) <- c("CUTOFF", "SEN", "SPE")
        ifelse(ties == "max.sen", index <-
                 which.max(ties.values[, 2]), "") # resume ties and locate optimal threshold
        ifelse(ties == "max.spe", index <-
                 which.max(ties.values[, 3]), "") # resume ties and locate optimal threshold
        cutoff <-
          round(as.numeric(ties.values[index, 1]), digits = 3) # retain threshold
        sen <-
          as.numeric(ties.values[index, 2]) # retain sensitivity at threshold
        spe <-
          as.numeric(ties.values[index, 3]) # retain specificity at threshold
      }
      
      # AUC from trapezoidal rule
      H <- (SEN[-1] + SEN[-length(SEN)]) / 2
      W <- diff(1 - SPE)
      AUC <- abs(sum(H * W))
      
      if (s == 1) {
        original <-
          list(
            SEN.all = SEN,
            SPE.all = SPE,
            T.all = T1,
            SEN.T = sen,
            SPE.T = spe,
            CUT.off = cutoff,
            TIES = ties.values,
            AUROC = AUC,
            Yarnold.D = Yarnold,
            Youden.J = Youden
          )
        results[1, 1] <- cutoff
        results[1, 2] <-
          format(round(AUC, digits = 3), nsmall = 3) # AUC
        results[1, 4] <-
          format(round(sen, digits = 3), nsmall = 3) # sensitivity
        results[1, 6] <-
          format(round(spe, digits = 3), nsmall = 3) # specificity
      } else {
        B.sen[s] <- sen
        B.spe[s] <- spe
        B.auroc[s] <- AUC
      }
    }
    
    if (n.samples > 1) {
      # CI
      results[1, 3] <-
        paste("(", toString(format(round(
          quantile(B.auroc, c(alpha / 2, 1 - alpha / 2)), digits = 3
        ), nsmall = 3)), ")", sep = "")
      results[1, 5] <-
        paste("(", toString(format(round(
          quantile(B.sen, c(alpha / 2, 1 - alpha / 2)), digits = 3
        ), nsmall = 3)), ")", sep = "")
      results[1, 7] <-
        paste("(", toString(format(round(
          quantile(B.spe, c(alpha / 2, 1 - alpha / 2)), digits = 3
        ), nsmall = 3)), ")", sep = "")
    }
    
    if (print == TRUE) {
      print(results, quote = FALSE)
    }
    
    return(original)
  }
