#' Render function for htmlwidgets
#' 
#' Stolen from http://stackoverflow.com/questions/31645528/knit-dtdatatable-without-pandoc
#' I don't know why this works, or even the nature of the problem it solves
#' @param input_file input file
#' @param output_file output file
#' @param self_contained Should the output be a self-contained html file?
#' @param deps_path path of deps.

renderWithWidgets <- function(input_file,
            output_file = sub("\\.Rmd$", ".html", input_file, ignore.case = TRUE),
            self_contained = TRUE,
            deps_path = file.path(dirname(output_file), "deps")) {
  
  # Read input and convert to Markdown
  input <- readLines(input_file)
  md <- knitr::knit(text = input)
  # Get dependencies from knitr
  deps <- knitr::knit_meta()
  
  # Convert script dependencies into data URIs, and stylesheet
  # dependencies into inline stylesheets
  
  dep_scripts <-
    lapply(deps, function(x) {
      lapply(x$script, function(script) file.path(x$src$file, script))})
  dep_stylesheets <- 
    lapply(deps, function(x) {
      lapply(x$stylesheet, function(stylesheet) file.path(x$src$file, stylesheet))})
  dep_scripts <- unique(unlist(dep_scripts))
  dep_stylesheets <- unique(unlist(dep_stylesheets))
  if (self_contained) {
    dep_html <- c(
      sapply(dep_scripts, function(script) {
        sprintf('<script type="text/javascript" src="%s"></script>',
              base64enc::dataURI(file = script))
      }),
      sapply(dep_stylesheets, function(sheet) {
        sprintf('<style>%s</style>',
                paste(readLines(sheet), collapse = "\n"))
      })
    )
  } else {
    if (!dir.exists(deps_path)) {
      dir.create(deps_path)
    }
    for (fil in c(dep_scripts, dep_stylesheets)) {
      file.copy(fil, file.path(deps_path, basename(fil)))
    }
    dep_html <- c(
      sprintf('<script type="text/javascript" src="%s"></script>',
              file.path(deps_path, basename(dep_scripts))),
      sprintf('<link href="%s" type="text/css" rel="stylesheet">',
              file.path(deps_path, basename(dep_stylesheets)))
    )
  }
  
  # Extract the <!--html_preserve--> bits
  preserved <- htmltools::extractPreserveChunks(md)
  
  # Render the HTML, and then restore the preserved chunks
  html <- markdown::markdownToHTML(text = preserved$value, header = dep_html)
  html <- htmltools::restorePreserveChunks(html, preserved$chunks)
  
  # Write the output
  writeLines(html, output_file)
}