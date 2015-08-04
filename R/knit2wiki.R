#' Knit .Rmd files to personal wiki directory as properly formatted .html
#' 
#' This function knits a .Rmd file to .html and sends the result to a personal
#' wiki source directory with proper yaml front matter
#' 
#' @param file The .Rmd file to knit
#' @param format How to render the document. See ?rmarkdown::render for options
#' @param wikidir Location of wiki library (assuming Wikitten structure) 
#' @param subdir Location to put file relative to wikidir. Defaults to "inbox"
#' @param ... passed to rmarkdown::render
#' @export

knit2wiki = function(file, generate = TRUE, format = "html_document",
                     subdir = "inbox", 
                     wikidir = getOption("wikidir"), ...){
  outputdir = paste0(wikidir, "/", subdir)
  rmarkdown::render(file, output_format = format, output_dir = outputdir, ...)
  if(generate) system("cd $WEBSITE && rake generate")
}
