# ‘dtROC.R’ with the function for generating the double-threshold receiver-operating characteristic plot and related statistics

dtROC <-
  function(continuous.test = NULL,
           dichotomous.test = NULL,
           precision = NULL,
           method = NULL,
           region = NULL,
           ties = NULL,
           n.samples = 1,
           alpha = 0.05,
           print = TRUE) {
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
    if ((method != "Youden" & method != "Yarnold") == TRUE) {
      stop("The method for selecting the threshold is invalid. Please use Youden or Yarnold.")
    }
    if ((region != "within" & region != "between") == TRUE) {
      stop(
        "The direction of the threshold that is associated with the presence of the outcome is invalid. Please use 'within' or 'between'."
      )
    }
    if ((ties != "max.width" & ties != "min.width") == TRUE) {
      stop(
        "The cost function for breaking ties is invalid. Please use 'max.width' or 'min.width'."
      )
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
        c(max(T1) + 1,
          max(T1) + 0.5,
          T1[-length(T1)] + diff(T1) / 2,
          min(T1) - 0.5,
          min(T1) - 1) # create a vector of midpoint thresholds with prepended/postprended Inf values
      
      # DOUBLE-THRESHOLD (all combinations)
      dt <-
        combn(T1, 2, simplify = TRUE) # create all combinations of 2 unique elements taken 2 at a time
      
      # scan all thresholds
      SEN <- rep(0, ncol(dt)) # empty sensitivity vector
      SPE <- rep(0, ncol(dt)) # empty specificity vector
      for (i in 1:ncol(dt)) {
        if (region == "within") {
          SEN[i] <-
            (sum(
              dichotomous.test[samples] == 1 &
                continuous.test[samples] > min(dt[, i]) &
                continuous.test[samples] < max(dt[,
                                                  i])
            )) / sum(dichotomous.test[samples] == 1) # calculate sensitivity
          SPE[i] <-
            (
              sum(dichotomous.test[samples] == 0 &
                    continuous.test[samples] < min(dt[, i])) + sum(dichotomous.test[samples] == 0 &
                                                                     continuous.test[samples] > max(dt[, i]))
            ) / sum(dichotomous.test[samples] == 0) # calculate specificity
        }
        if (region == "between") {
          SEN[i] <-
            (
              sum(dichotomous.test[samples] == 1 &
                    continuous.test[samples] < min(dt[, i])) + sum(dichotomous.test[samples] == 1 &
                                                                     continuous.test[samples] > max(dt[, i]))
            ) / sum(dichotomous.test[samples] == 1) # calculate sensitivity
          SPE[i] <-
            (sum(
              dichotomous.test[samples] == 0 &
                continuous.test[samples] > min(dt[, i]) &
                continuous.test[samples] < max(dt[,
                                                  i])
            )) / sum(dichotomous.test[samples] == 0) # calculate specificity
        }
      }
      
      # DOUBLE-THRESHOLD (unique combinations)
      ranks <-
        order(1 - SPE, SEN, t(dt[1,]) - t(dt[2,]), decreasing = FALSE) # sort vectors simultaneously by 1-SPE, then SEN, then threshold width
      SPE <- SPE[ranks] # reorder vectors
      SEN <- SEN[ranks] # reorder vectors
      dt <- dt[, ranks] # reorder matrix
      SPEu <- c() # empty unique specificity vector
      SENu <- c() # empty unique sensitivity vector
      dtu <- c() # empty unique threshold vector
      C <- 0 # initialize cumulative sum
      for (i in 1:length(SPE)) {
        # loop across all values
        if ((1 - SPE[i]) + SEN[i] >= C) {
          # (1-SPE, SEN) is non-decreasing
          SPEu <-
            c(SPEu, SPE[i]) # retain maximal specificity for a given unique specificity
          if (SEN[i] >= max(SENu)) {
            # SEN is non-decreasing
            SENu <- c(SENu, SEN[i]) # retain sensitivity
            dtu <-
              cbind(dtu, c(dt[1, i], dt[2, i])) # retain double threshold
          } else {
            SENu <-
              c(SENu, SENu[length(SENu)]) # retain last sensitivity to adjust for a monotonic (nondecreasing) curve
            dtu <-
              cbind(dtu, dtu[, dim(dtu)[2]]) # retain last double threshold
          }
          C <- (1 - SPE[i]) + SEN[i] # update cumulative sum
        }
      }
      
      # delete thresholds with Inf
      SPEu <- SPEu[is.finite(colSums(dtu))]
      SENu <- SENu[is.finite(colSums(dtu))]
      dtu <- dtu[, is.finite(colSums(dtu))]
      
      # calculate criterion
      Youden <- SPEu + SENu - 1 # calculate Youden's index
      Yarnold <-
        sqrt((1 - SENu) ^ 2 + (1 - SPEu) ^ 2) # calculate Yarnold distance to top-left corner
      if (method == "Yarnold") {
        indexes <- which(Yarnold == min(Yarnold))
      } # locate optimal threshold
      if (method == "Youden") {
        indexes <- which(Youden == max(Youden))
      } # locate optimal threshold
      
      # check and resolve for ties
      if (length(indexes) == 1) {
        # no ties
        T_lower <- min(dtu[, indexes]) # retain lower threshold
        T_upper <- max(dtu[, indexes]) # retain higher threshold
        cutoff <-
          paste(format(round(T_lower, digits = precision), nsmall = precision),
                format(round(T_upper, digits = precision), nsmall = precision),
                sep = "-") # retain thresholds
        sen <-
          as.numeric(SENu[indexes]) # retain sensitivity at threshold
        spe <-
          as.numeric(SPEu[indexes]) # retain specificity at threshold
        ties.values <- "NA"
      }
      if (length(indexes) > 1) {
        # there are ties
        ties.values <-
          cbind(dtu[2, indexes], dtu[1, indexes], SENu[indexes], SPEu[indexes])
        colnames(ties.values) <-
          c("CUTOFF lower", "CUTOFF upper", "SEN", "SPE")
        ifelse(ties == "max.width",
               index <-
                 which.max(ties.values[, 2] - ties.values[, 1]),
               "") # resume ties and locate optimal threshold
        ifelse(ties == "min.width",
               index <-
                 which.min(ties.values[, 2] - ties.values[, 1]),
               "") # resume ties and locate optimal threshold
        T_lower <- ties.values[index, 1] # retain lower threshold
        T_upper <- ties.values[index, 2] # retain higher threshold
        cutoff <-
          paste(format(round(T_lower, digits = precision), nsmall = precision),
                format(round(T_upper, digits = precision), nsmall = precision),
                sep = "-") # retain thresholds
        sen <-
          as.numeric(ties.values[index, 3]) # retain sensitivity at threshold
        spe <-
          as.numeric(ties.values[index, 4]) # retain specificity at threshold
      }
      
      H <- (SENu[-1] + SENu[-length(SENu)]) / 2
      W <- diff(1 - SPEu)
      AUC <- abs(sum(H * W)) # calculate AUROC
      
      if (s == 1) {
        original <-
          list(
            SEN.all = SEN,
            SPE.all = SPE,
            SEN.unique = SENu,
            SPE.unique = SPEu,
            T.all = dt,
            TIES = ties.values,
            T.upper = T_upper,
            T.lower = T_lower,
            SEN.Td = sen,
            SPE.Td = spe,
            CUT.off = cutoff,
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
