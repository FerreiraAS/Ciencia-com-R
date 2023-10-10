diag.stats <-
  function(new.test,
           reference.test,
           new.lab,
           ref.lab,
           adjustment,
           conf.level) {
    # install and load required packages
    packages <- c("PropCIs", "pROC")
    # Install packages not yet installed
    installed_packages <-
      packages %in% rownames(installed.packages())
    if (any(installed_packages == FALSE)) {
      install.packages(packages[!installed_packages])
    }
    # Packages loading
    invisible(lapply(packages, library, character.only = TRUE))
    
    # check data structure
    if (dim(new.test)[2] != 1) {
      stop("The 'new.test' data is not a 1D vector.")
    }
    if (dim(reference.test)[2] != 1) {
      stop("The 'reference.test' data is not a 1D vector.")
    }
    if (length(as.vector(new.lab)) != 2) {
      stop("The 'new.lab' input is not a 2-label vector.")
    }
    if (length(as.vector(ref.lab)) != 2) {
      stop("The 'ref.lab' input is not a 2-label vector.")
    }
    if (!identical(adjustment, TRUE) &
        !identical(adjustment, FALSE)) {
      stop("The 'adjustment' parameter is not a Boolean value.")
    }
    if (length(conf.level) != 1) {
      stop("The 'conf.level' data is empty.")
    }
    if (as.numeric(conf.level) < 0 | as.numeric(conf.level) > 1) {
      stop("The 'conf.level' data is outside the interval [0;1].")
    }
    
    # N   Reference-Std
    # e |-------|-------|
    # w |   TP  |   FP  |
    # t |-------|-------|
    # e |   FN  |   TN  |
    # s |-------|-------|
    # t
    
    TP <-
      sum(reference.test == ref.lab[1] &
            new.test == new.lab[1]) + if (adjustment == TRUE) {
              0.5
            }
    FN <-
      sum(reference.test == ref.lab[1] &
            new.test == new.lab[2]) + if (adjustment == TRUE) {
              0.5
            }
    FP <-
      sum(reference.test == ref.lab[2] &
            new.test == new.lab[1]) + if (adjustment == TRUE) {
              0.5
            }
    TN <-
      sum(reference.test == ref.lab[2] &
            new.test == new.lab[2]) + if (adjustment == TRUE) {
              0.5
            }
    N <- TP + FN + FP + TN
    
    # primary indices
    sen <- TP / (TP + FN)
    spe <- TN / (FP + TN)
    ppv <- TP / (TP + FP)
    npv <- TN / (FN + TN)
    acc <- (TP + TN) / (TP + FN + FP + TN)
    
    # secondary indices
    plr <- sen / (1 - spe)
    nlr <- (1 - sen) / spe
    dor <- plr / nlr
    youden <- sen + spe - 1
    
    # Clopper-Pearson exact confidence intervals
    sen.ci <- exactci(TP, (TP + FN), conf.level)
    spe.ci <- exactci(TN, (FP + TN), conf.level)
    ppv.ci <- exactci(TP, (TP + FP), conf.level)
    npv.ci <- exactci(TN, (FN + TN), conf.level)
    acc.ci <- exactci((TP + TN), (TP + FN + FP + TN), conf.level)
    plr.ci <- riskscoreci(TP, (TP + FN), FP, (FP + TN), conf.level)
    nlr.ci <- riskscoreci(FN, (TP + FN), TN, (FP + TN), conf.level)
    dor.ci <- oddsratioci.mp((FP * FN), (TP * TN), conf.level)
    # DeLong confidence interval
    auc.ci <-
      ci.auc(new.test, reference.test, conf.level = conf.level)
    # Wallis confidence interval
    p1 <- sen
    p2 <- spe
    youden.lw <-
      sen + spe - sqrt((sen - sen.ci$conf.int[1]) ^ 2 + (spe - spe.ci$conf.int[1]) ^
                         2) - 1
    youden.up <-
      sen + spe + sqrt((sen - sen.ci$conf.int[1]) ^ 2 + (spe - spe.ci$conf.int[1]) ^
                         2) - 1
    youden.ci <- c(youden.lw, youden.up)
    
    # bundle of results
    bundle <-
      list(
        'Accuracy' = c(acc.ci$conf.int[1], acc, acc.ci$conf.int[2]),
        'Sensitivity' = c(sen.ci$conf.int[1], sen, sen.ci$conf.int[2]),
        'Specificity' = c(spe.ci$conf.int[1], spe, spe.ci$conf.int[2]),
        `Pos.Predict.Value` = c(ppv.ci$conf.int[1], ppv, ppv.ci$conf.int[2]),
        `Neg.Predict.Value` = c(npv.ci$conf.int[1], npv, npv.ci$conf.int[2]),
        `Pos.Likelyhood.Ratio` = c(plr.ci$conf.int[1], plr, plr.ci$conf.int[2]),
        `Neg.Likelyhood.Ratio` = c(nlr.ci$conf.int[1], nlr, nlr.ci$conf.int[2]),
        'Diag.Odds.Ratio' = c(dor.ci$conf.int[1], dor, dor.ci$conf.int[2]),
        'Youden.Index' = c(youden.ci[1], youden, youden.ci[2]),
        'Area.Under.Curve' = c(auc.ci[[1]], auc.ci[[2]], auc.ci[[3]])
      )
    
    values <-
      format(round(data.frame((
        sapply(bundle, matrix)
      )), digits = 3), nsmall = 3)
    rownames(values) <- c("CI lower", "Estimate", "CI upper")
    
    # output values
    return(values)
  }
