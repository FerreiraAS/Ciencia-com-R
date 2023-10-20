pvalue <- function(x, ...) {
    # Construct vectors of data y, and groups (strata) g
    y <- unlist(x)
    g <- factor(rep(1:length(x), times = sapply(x, length)))
    if (is.numeric(y)) {
        if (nlevels(g) > 2) {
            # For numeric variables with 3 or more groups, perform a standard
            # ANOVA test
            p <- summary(aov(y ~ g))[[1]][["Pr(>F)"]][1]
        } else {
            # For numeric variables with 2 groups, perform a standard 2-sample
            # t-test
            p <- t.test(y ~ g)$p.value
        }
    } else {
        # For categorical variables, perform a chi-squared test of independence
        p <- chisq.test(table(y, g))$p.value
    }
    # Format the p-value, using an HTML entity for the less-than sign.  The
    # initial empty string places the output on the line below the variable
    # label.
    c("", sub("&lt;", "<", format.pval(round(p, digits = 3), digits = 3, eps = 0.001)))
}
