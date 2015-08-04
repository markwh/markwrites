#' Knit .Rmd files to Octopress blog directory as properly formatted .html
#' 
#' This function knits a file to .html and sends the result to Octopress blog 
#' source directory with proper yaml front matter
#' 
#' @param file The .Rmd file to knit
#' @param title The title of the resulting blog post
#' @param address The name the file will have on the server (and URL)
#' @param layout Jekyll format of resulting file. Defaults to "post."
#' @param comments Include comments? defaults to "true"
#' @param categories Character vector. What categories to associate with the 
#'   result?
#' @param blogdir Character. Where to put the result?
#' @param postdir Character. Post directory with respect to blog directory.
#' @param mate Open resulting html in TextMate?
#' @details Uses yaml front matter as explained in Jekyll documentation:
#'   http://jekyllrb.com/docs/frontmatter/
#' @export

knit2blog = function(file, title, address = title, layout = "post", 
                     comments = TRUE, categories = "", 
                     blogdir = getOption("blogdir"),
                     postdir = getOption("postdir"), mate = FALSE){
  
  curdir = getwd(); on.exit(setwd(curdir))
  
  # knit to temporary html file
  outfile = "temp_outfile.html"
  knit2html(file, output = outfile) # HTML content, temporarily stored in wd
  
  # Make yaml front matter:
  comments = ifelse(comments, "true", "false")
  curtime = format(Sys.time(), "%Y-%m-%d %H:%M:%S %z") 
  
  if(length(categories) > 1) 
    categstr = paste0("[", paste(categories, collapse = ", "), "]") 
  else categstr = categories
  
  
  
  yamlfm = paste0("---\nlayout: ", layout, '\ntitle: "', title, '"\ndate: ', 
                  docdate, "\ncomments: ", comments, "\ncategories: ", 
                  categstr, "\n---")
  
  # make file with only yaml front matter
  curdate = format(Sys.time(), "%Y-%m-%d-") 
  postname = paste0(curdate, gsub(" ", "-", address, fixed = T), ".html")
#   postloc = paste0('"', blogdir, postdir, '"')
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
  
  # Optionally open in TextMate
  if(mate) system(paste0("mate ", postloc, "/", pn.q))
}

