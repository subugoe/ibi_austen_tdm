# rocker/verse already ships tidyverse (dplyr, ggplot2), knitr, rmarkdown,
# remotes and codetools. Only install what is missing, so the build stays fast.
pkgs <- c(
  "janeaustenr", # Jane Austen corpus
  "tidytext",    # text mining
  "quarto",      # quarto::quarto_render() from R
  "markdown"
)

missing <- setdiff(pkgs, rownames(installed.packages()))
if (length(missing) > 0) install.packages(missing)

# Fail the build if anything did not install
stopifnot(all(pkgs %in% rownames(installed.packages())))
