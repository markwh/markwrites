# main.r


library(roxygen2)
library(devtools)

# To make Roxygen documentation:
devtools::document()

# To load the package:
load_all("../markwrites")

# Checks?
check_doc()

# To install the package:
devtools::install("../markwrites")
library(markwrites)
?knit2blog
knit2blog
