# restart all variables
rm(list = ls(all = TRUE))
options(warn = -1)

# most packages work fine if installed from CRAN
packs <- c("readxl", "gtsummary", "table1", "effectsize", "pwr")
for (i in 1:length(packs)) {
    if (!require(packs[i], character.only = TRUE, quietly = TRUE))
        install.packages(packs[i], character.only = TRUE)
}

# load all libraries
for (i in 1:length(packs)) {
    library(packs[i], character.only = TRUE)
}

# load external scripts
source("extracolumn-p.R")
source("extracolumn-es.R")
source("extracolumn-N.R")

# read data
dataset <- data.frame(read_excel("pilotdata_gopal.xlsx", sheet = 1))

# COMPARATIVE ANALYSIS
table1(~Sex + Age + Height_cm + Weight_kg + BMI_kg.m. + Smoker + FVC + FEV1 + FEV1.FVC +
    MIP + MEP | Group, data = dataset, extra.col = list(`P-value` = pvalue, `Effect size (d, f, V)` = es))

# COMPARATIVE ANALYSIS
table1(~Both.Leg...Eyes.Opened..Overall.balance.index...Two.Leg.. + Both.Leg...Eyes.Opened..Overall.balance.index...SD.. +
    Both.Leg...Eyes.Opened..ANT.POST.balance.index...Two.Leg. + Both.Leg...Eyes.Opened..ANT.POST.balance.index...SD. +
    Both.Leg...Eyes.Opened..MED.LAT..balance.index..Two.Leg. + Both.Leg...Eyes.Opened..MED.LAT..balance.index..SD. |
    Group, data = dataset, extra.col = list(`P-value` = pvalue, `Effect size<br>(d, f, X)` = es,
    `Sample size<br>(per group)` = N))

# COMPARATIVE ANALYSIS
table1(~Both.Leg...Eyes.closed..Overall.balance.index..Two.leg. + Both.Leg...Eyes.closed..Overall.balance.index..SD. +
    Both.Leg...Eyes.Closed..ANT.POST.balance.index..two.leg. + Both.Leg...Eyes.Closed..ANT.POST.balance.index..SD. +
    Both.Leg...Eyes.Closed..MED.LAT..balance.index...two.Leg. + Both.Leg...Eyes.Closed..MED.LAT..balance.index...SD. |
    Group, data = dataset, extra.col = list(`P-value` = pvalue, `Effect size<br>(d, f, X)` = es,
    `Sample size<br>(per group)` = N))

# COMPARATIVE ANALYSIS
table1(~Sagittal.Imbalance.VP.DM.R. + Sagittal.Imbalance.VP.DM.L. + Coronal.Imbalance.VP.DM.mm.R +
    Coronal.Imbalance.VP.DM.mm.L + Pelvic.Obliquity.mm.R + Pelvic.Obliquity.mm.L +
    Pelvic.Obliquity.mm + Pelvic.Torsion.DL.DR..R. + Pelvic.Torsion.DL.DR.L. + Pelvic.Torsion.DL.DR.. +
    Pelvic.Rotation.. + Pelvic.Rotation.R. + Pelvic.Rotation.L. + Kyphotic.Angle.ICT.ITL..MAX.... +
    Lordotic.Angle.ITL.ILS..MAX... + Vertebral.Rotation..rms... + Vertebral.Rotation...max. +
    Vertebral.Rotation...max. + Vertebral.Rotation...max..1 + Vertebral.Rotation..Amplitude... +
    Apical.Devation.VP.DM..rms..mm + Apical.Devation.VP.DM...max..mm + Apical.Devation.VP.DM...max..mm.1 +
    Apical.Devation.VP.DM..Amplitude..mm + trunk.length.VP.DM.mm + dimple.distance.DL.DR.mm +
    kyphotic.apex.KA.mm + lordotic.apex.LA.mm + Fleche.Cervicale.mm + Fleche.Lombaire..mm +
    Inflection.point.ICT.mm + Inflection.point.ITL.mm | Group, data = dataset, extra.col = list(`P-value` = pvalue,
    `Effect size<br>(d, f, X)` = es, `Sample size<br>(per group)` = N))
