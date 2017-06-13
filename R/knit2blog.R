#' Knit .Rmd files to Octopress blog directory as properly formatted .html or .md
#' 
#' This function knits a file to .html/markdown and sends the result to Octopress blog 
#' source directory with proper yaml front matter
#' 
#' @param file The .Rmd file to knit
#' @param title The title of the resulting blog post
#' @param format Output format for rendering. Either "html" or "markdown"
#' @param address The name the file will have on the server (and URL)
#' @param layout Jekyll format of resulting file. Defaults to "post."
#' @param comments Include comments? defaults to "true"
#' @param categories Character vector. What categories to associate with the 
#'   result?
#' @param blogdir Character. Where to put the result?
#' @param postdir Character. Post directory with respect to blog directory.
#' @param hasWidgets Does the document use htmlwidgets? (needed for render function choice)
#' @param ... passed to rmarkdown::render()
#' @details Uses yaml front matter as explained in Jekyll documentation:
#'   http://jekyllrb.com/docs/frontmatter/
#' @export

knit2blog = function(file, title, address = title, 
                     format = c("html", "markdown"),
                     layout = "post", 
                     comments = TRUE, categories = "", 
                     blogdir = getOption("blogdir"),
                     postdir = getOption("postdir"), 
                     hasWidgets = FALSE,
                     ...){
  
  curdir = getwd(); on.exit(setwd(curdir))
  format = match.arg(format)
  # knit to temporary html file
  outfile = "temp_outfile"
  
  fixedims <- fixImagesForOcto(file)
  newfile <- tempfile(fileext = ".Rmd")
  con <- file(newfile)
  writeLines(fixedims, con = con)
  close(con)
  
  if(format == "html") {
    
    if (hasWidgets) {
      renderWithWidgets(newfile, output_file = outfile, ...)
    } else {
      rmarkdown::render(newfile, "html_document", output_file = outfile, ...)
    }
  }
  else {
    knitr::knit(newfile, output = outfile)
    x <- readLines(outfile)
    ymlends = grep("^---$", x)
    y <- x[(ymlends[2] + 1):length(x)]
    cat(y, file = outfile, sep = "\n")
  }
  postext = ifelse(format == "html", ".html", ".md")
  
  # Make yaml front matter:
  comments = ifelse(comments, "true", "false")
  curtime = format(Sys.time(), "%Y-%m-%d %H:%M:%S %z") 
  
  if(length(categories) > 1) 
    categstr = paste0("[", paste(categories, collapse = ", "), "]") 
  else categstr = categories

  docdate = format(Sys.time(), "%Y-%m-%d")
  
  yamlfm = paste0("---\nlayout: ", layout, '\ntitle: "', title, '"\ndate: ', 
                  docdate, "\ncomments: ", comments, "\ncategories: ", 
                  categstr, "\n---")
  
  # make file with only yaml front matter
  curdate = format(Sys.time(), "%Y-%m-%d-") 
  postname = paste0(curdate, gsub(" ", "-", address, fixed = T), postext)
  postloc = paste0(blogdir, postdir)
  write.table(yamlfm, postname, quote = F, row.names = F, col.names = F)
  
  # Add html content to yaml front matter html file
  file.append(postname, outfile)
  file.remove(outfile)
  
#   pn.q = paste0('"', postname, '"') # NEED EXTRA QUOTES FOR CALLING mv
  pn.q = postname

  calstr = paste("mv -f", pn.q, postloc, sep = " ")
  print(calstr)
  system(calstr)
}

