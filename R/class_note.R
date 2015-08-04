class_note <- function(course, toc = TRUE) {
  # get the locations of resource files located within the package
  css <- system.file("resources/styles.css", package = "mypackage")
  header <- system.file("resources/classnote/header.html", package = "mypackage")
  
  # call the base html_document function
  rmarkdown::html_document(toc = toc,
                           fig_width = 6.5,
                           fig_height = 4,
                           theme = NULL,
                           css = css,
                           includes = includes(before_body = header))
}

