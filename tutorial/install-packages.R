# Run once in RStudio's R Console after installing the system build tools.
install.packages(c("remotes", "knitr", "rmarkdown"))
remotes::install_github("lapo-santi/RBBayes", upgrade = "never")

# Recommended for the diagnostic and partition-search sections:
install.packages(c("coda", "bayesplot", "salso"))
