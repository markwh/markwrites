# main.r


library(roxygen2)
library(devtools)

# To make Roxygen documentation:
devtools::document()

# To load the package:
load_all("../markwrites")

# Checks?
check_doc()

# Package dependencies
use_package("knitr")
use_package("htmltools")
use_package("base64enc")
use_package("markdown")
use_package("stringr")

# To install the package:
devtools::install("../markwrites")
library(markwrites)
?knit2blog
knit2blog
