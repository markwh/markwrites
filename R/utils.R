# utitlit functions for writing

#' Render inline code as it appears in the unrendered document.
#' 
#' Copied from http://stackoverflow.com/a/20413197
#' @export

rinline <- function(code){
  html <- '<code  class="r">``` `r CODE` ```</code>'
  sub("CODE", code, html)
}