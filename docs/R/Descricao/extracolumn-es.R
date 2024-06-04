es <- function(x, ...) {
    # initialize values to NA
    es <- NA
    N <- NA
    # remove previous column as it is for the pooled groups
    x <- x[-length(x)]
    # Construct vectors of data y, and groups (strata) g
    y <- unlist(x)
    g <- factor(rep(1:length(x), times = sapply(x, length)))
    if (is.numeric(y)) {
        if (nlevels(g) > 2) {
            # For numeric variables with 3 or more groups
            model <- aov(as.character(g) ~ y)
            eta2 <- effectsize::eta_squared(model, partial = TRUE)$Eta2
            if (!is.na(eta2)) {
                es <- effectsize::eta2_to_f(eta2)
                N <- ceiling(pwr::pwr.anova.test(k = nlevels(g), f = effectsize::eta2_to_f(es),
                  sig.level = 0.05, power = 0.8)$n)
            }
        } else {
            # For numeric variables with 2 groups
            mu.1 <- mean(y[g == levels(g)[1]])
            mu.2 <- mean(y[g == levels(g)[2]])
            sd.1 <- sd(y[g == levels(g)[1]])
            sd.2 <- sd(y[g == levels(g)[2]])
            pool.sd <- sqrt((sd.1^2 + sd.2^2)/2)
            d <- (mu.1 - mu.2)/pool.sd
            if (!is.na(d)) {
                es <- d
                N <- ceiling(pwr::pwr.t.test(d = es, sig.level = 0.05, power = 1 -
                  0.2, type = "two.sample")$n)
            }
        }
    } else {
        # For categorical variables
        w <- chisq.test(table(y, g), correct = TRUE)
        es <- sqrt(as.numeric(w$statistic)/as.numeric(sum(w$observed)) * as.numeric(w$parameter))
        N <- ceiling(pwr::pwr.chisq.test(w = es, N = NULL, df = w$parameter, sig.level = 0.05,
            power = 0.8)$N)
    }
    # Format the ES value, using an HTML entity.  The initial empty string
    # places the output on the line below the variable label.
    c("", round(es, digits = 3))
}
