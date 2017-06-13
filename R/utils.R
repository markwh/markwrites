# utitlit functions for writing

#' Render inline code as it appears in the unrendered document.
#' 
#' Copied from http://stackoverflow.com/a/20413197
#' @export

rinline <- function(code){
  html <- '<code  class="r">``` `r CODE` ```</code>'
  sub("CODE", code, html)
}



#' Get list of images in document
#' 
#' returns lines--does not write them.
#' Side effects: copies images to folder specified by options("imagedir")
#' 
#' @export

fixImagesForOcto <- function(filename) {
  
  imgpat <- "!\\[.*\\]\\(.+\\)"
  lines <- grep(imgpat, readLines(filename), value = TRUE)
  imglist <- as.data.frame(stringr::str_match(lines, "!\\[(.*)\\]\\((.+)\\)"),
                           stringsAsFactors = FALSE)
  
  if (nrow(imglist) == 0)
    return(readLines(filename))
  
  names(imglist) <- c("full", "alt", "path")
  imglist$base <- basename(imglist$path)
  
  # Check for internet files
  # local
  isLocal <- file.exists(imglist$path)
  # internet
  isURL <- !isLocal
  isURL[!isLocal] <- vapply(imglist$path[!isLocal], 
                            FUN = RCurl::url.exists, logical(1))
  # error - skip
  toSkip <- !isLocal & !isURL
  
  # Move 
  copyFrom <- as.character(imglist$path[isLocal])
  copyTo <- paste0(getOption("blogdir"), getOption("imagedir"))
  file.copy(from = copyFrom, to = copyTo)
  
  
  # Replace syntax
  imglist$octo <- with(imglist, sprintf("{%% img /%s%s '%s' %%}", 
                                        getOption("imagedir"),
                                        imglist$base,
                                        imglist$alt))
  imglist$octo[isURL] <- with(imglist, sprintf("{%% img %s '%s' %%}",
                                imglist$path[isURL],
                                imglist$alt[isURL])) # for URLs

  newlines <- readLines(filename)
  
  imglist <- imglist[isLocal,] # This makes it work, but non-local images don't use liquid
  
  for (i in 1:nrow(imglist)) {
    newlines <- with(imglist, gsub(full[i], octo[i], newlines, fixed = TRUE))
  }
  
  return(newlines)
}



