#' R function to generate octopress website
#' 
#' Generates blog and optionally previews the result. 
#' Assumes server_port is set to 5000 in rakefile.
#' 
#' @param siteloc The directory containing the octopress structure
#' @param message git commit message (leaving this blank will result in no commit)
#' @param wikidir Location of wiki library (assuming Wikitten structure) 
#' @param subdir Location to put file relative to wikidir. Defaults to "inbox"

generateOctoSite = function(siteloc = getOption("blogdir"), 
                            message = "", 
                            push = FALSE, ) {
  system("cd $WEBSITE && rake generate")
  if(push) {
    system("cd $WEBSITE && rake preview &")
    utils::browseURL("http://localhost:5000")  
    
    cat ("Press [enter] to continue")
    line <- readline()
    
    system("pkill -INT -f localhost")
  }
}
