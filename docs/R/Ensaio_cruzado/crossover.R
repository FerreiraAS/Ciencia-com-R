crossover.test <-
  function(sequence,
           # vector
           AB,
           # label
           BA,
           # label
           pre_F1,
           # data
           post_F1,
           # data
           pre_F2,
           # data
           post_F2,
           # data
           mean.imput,
           alpha,
           carryover.alpha) {

    # mean imputation of missing values
    missings <- c()
    banco <- data.frame(pre_F1, post_F1, pre_F2, post_F2)
    for (i in 1:dim(banco)[2]) {
      if (any(is.na(banco[, i]))) {
        missings <-
          c(missings, paste0(colnames(banco)[i], " = ", sum(is.na(banco[, i]))))
        banco[is.na(banco[, i]), i] <-
          mean(na.omit(banco[, i]))
      }
    }
    missings <-
      paste0("Missing data: ", paste0(missings, collapse = ", "))
    
    # Fleiss, 1986 (pages 264-271)
    digits <- 3
    table2 <-
      matrix(NA, ncol = 8, nrow = nlevels(as.factor(sequence)))
    colnames(table2) <-
      c(
        "Sequence",
        "Sample size",
        "Baseline P1, Mean (SD)",
        "Final P1, M (SD)",
        "Baseline P2, Mean (SD)",
        "Final P2, M (SD)",
        "SUM, Mean (SD)",
        "DIFF, Mean (SD)"
      )
    table2[, 1] <-
      unique(as.character(as.factor(sequence)))
    table2[, 2] <- table(as.factor(sequence))
    
    row <- 1
    X1 <-
      pre_F1[sequence == AB]
    table2[row, 3] <-
      paste0(format(round(mean(na.omit(
        X1
      )), digits), nsmall = digits),
      " (",
      format(round(sd(na.omit(
        X1
      )), digits), nsmall = digits),
      ")")
    X2 <-
      post_F1[sequence == AB]
    table2[row, 4] <-
      paste0(format(round(mean(na.omit(
        X2
      )), digits), nsmall = digits),
      " (",
      format(round(sd(na.omit(
        X2
      )), digits), nsmall = digits),
      ")")
    X3 <-
      pre_F2[sequence == BA]
    table2[row, 5] <-
      paste0(format(round(mean(na.omit(
        X3
      )), digits), nsmall = digits),
      " (",
      format(round(sd(na.omit(
        X3
      )), digits), nsmall = digits),
      ")")
    X4 <-
      post_F2[sequence == BA]
    table2[row, 6] <-
      paste0(format(round(mean(na.omit(
        X4
      )), digits), nsmall = digits),
      " (",
      format(round(sd(na.omit(
        X4
      )), digits), nsmall = digits),
      ")")
    T1 <- mean(na.omit(X1 - X2) + na.omit(X3 - X4))
    ST1 <- sd(na.omit(X1 - X2) + na.omit(X3 - X4))
    table2[row, 7] <-
      paste0(format(round(T1, digits), nsmall = digits),
             " (",
             format(round(ST1, digits), nsmall = digits),
             ")")
    D1 <- mean(na.omit(X1 - X2) - na.omit(X3 - X4))
    SD1 <- sd(na.omit(X1 - X2) - na.omit(X3 - X4))
    table2[row, 8] <-
      paste0(format(round(D1, digits), nsmall = digits),
             " (",
             format(round(SD1, digits), nsmall = digits),
             ")")
    
    row <- 2
    X5 <-
      pre_F1[sequence == BA]
    table2[row, 3] <-
      paste0(format(round(mean(na.omit(
        X5
      )), digits), nsmall = digits),
      " (",
      format(round(sd(na.omit(
        X5
      )), digits), nsmall = digits),
      ")")
    X6 <-
      post_F1[sequence == BA]
    table2[row, 4] <-
      paste0(format(round(mean(na.omit(
        X6
      )), digits), nsmall = digits),
      " (",
      format(round(sd(na.omit(
        X6
      )), digits), nsmall = digits),
      ")")
    X7 <-
      pre_F2[sequence == AB]
    table2[row, 5] <-
      paste0(format(round(mean(na.omit(
        X7
      )), digits), nsmall = digits),
      " (",
      format(round(sd(na.omit(
        X7
      )), digits), nsmall = digits),
      ")")
    X8 <-
      post_F2[sequence == AB]
    table2[row, 6] <-
      paste0(format(round(mean(na.omit(
        X8
      )), digits), nsmall = digits),
      " (",
      format(round(sd(na.omit(
        X8
      )), digits), nsmall = digits),
      ")")
    T2 <- mean(na.omit(X5 - X6) + na.omit(X7 - X8))
    ST2 <- sd(na.omit(X5 - X6) + na.omit(X7 - X8))
    table2[row, 7] <-
      paste0(format(round(T2, digits), nsmall = digits),
             " (",
             format(round(ST2, digits), nsmall = digits),
             ")")
    D2 <- mean(na.omit(X5 - X6) - na.omit(X7 - X8))
    SD2 <- sd(na.omit(X5 - X6) - na.omit(X7 - X8))
    table2[row, 8] <-
      paste0(format(round(D2, digits), nsmall = digits),
             " (",
             format(round(SD2, digits), nsmall = digits),
             ")")
    
    n1 <-
      sum(sequence == AB)
    n2 <-
      sum(sequence == BA)
    SD <-
      sqrt(((n1 - 1) * SD1 ^ 2 + (n2 - 1) * SD2 ^ 2) / (n1 + n2 - 2))
    ST <-
      sqrt(((n1 - 1) * ST1 ^ 2 + (n2 - 1) * ST2 ^ 2) / (n1 + n2 - 2))
    
    # test for differences in sum ('carry over' effect)
    lower <-
      ((T1 - T2) / 2) - qt((1 - alpha / 2), df = n1 + n2 - 2) * ST / 2 * sqrt(1 /
                                                                                n1 + 1 / n2)
    sum <- ((T1 - T2) / 2)
    upper <-
      ((T1 - T2) / 2) + qt((1 - alpha / 2), df = n1 + n2 - 2) * ST / 2 * sqrt(1 /
                                                                                n1 + 1 / n2)
    t <- ((T1 - T2) / ST) * sqrt((n1 * n2) / (n1 + n2))
    p.value <-
      2 * pt(q = abs(t),
             df = (n1 + n2 - 2),
             lower.tail = FALSE)
    
    # export results
    result.T <- paste0(
      "Estimated sum [95%CI]: ",
      format(round(sum, digits), nsmall = digits),
      " [",
      format(round(lower, digits), nsmall = digits),
      "; ",
      format(round(upper, digits), nsmall = digits),
      "] ",
      "(t value: ",
      format(round(t, digits), nsmall = digits),
      ", p = ",
      format(round(p.value, digits), nsmall = digits),
      ")"
    )
    
    if (p.value < carryover.alpha) {
      # warn if carry over effect hypothesis was rejected
      carryover <-
        paste0(
          "Null hypothesis of no 'carry-over effect' was rejected (p < ",
          format(round(carryover.alpha, digits), nsmall = digits),
          "). Measurements obtained in the second period were discarded."
        )
      test <-
        t.test(
          na.omit(X1 - X2),
          na.omit(X5 - X6),
          alternative = "two.sided",
          paired = FALSE,
          conf.level = 1 - alpha
        )
      lower <- test$conf.int[1]
      diff <- test$estimate[1] - test$estimate[2]
      upper <- test$conf.int[2]
      t <- test$statistic
      p.value <- test$p.value
    } else {
      carryover <-
        paste0(
          "Null hypothesis of no 'carry-over effect' was not rejected (p > ",
          format(round(carryover.alpha, digits), nsmall = digits),
          "). Measurements obtained in the first and second periods were used for analysis."
        )
      # test for differences in difference ('between-group' effect)
      lower <-
        ((D1 - D2) / 2) - qt((1 - alpha / 2), df = n1 + n2 - 2) * SD / 2 * sqrt(1 /
                                                                                  n1 + 1 / n2)
      diff <- ((D1 - D2) / 2)
      upper <-
        ((D1 - D2) / 2) + qt((1 - alpha / 2), df = n1 + n2 - 2) * SD / 2 * sqrt(1 /
                                                                                  n1 + 1 / n2)
      t <- ((D1 - D2) / SD) * sqrt((n1 * n2) / (n1 + n2))
      p.value <-
        2 * pt(q = abs(t),
               df = (n1 + n2 - 2),
               lower.tail = FALSE)
    }
    
    # export results
    result.D <- paste0(
      "Estimated difference [95%CI]: ",
      format(round(diff, digits), nsmall = digits),
      " [",
      format(round(lower, digits), nsmall = digits),
      "; ",
      format(round(upper, digits), nsmall = digits),
      "] ",
      "(t value: ",
      format(round(t, digits), nsmall = digits),
      ", p = ",
      format(round(p.value, digits), nsmall = digits),
      ")"
    )
    return(list(result.T, carryover, result.D, table2, missings))
  }