fixURLs = function(mdfile){
  f1 = file(mdfile)
  lines = readLines(f1, n = -1)
  modlines = gsub("(www.", "(http://www.", lines, fixed = TRUE)
  writeLines(modlines, f1)
  close(f1)
}