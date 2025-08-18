# insert image from html page
myurl <- "https://docs.posit.co/ide/user/ide/guide/ui/images/rstudio-panes-labeled.jpeg"
utils::download.file(url = myurl, destfile = 'images/RStudioConsole.jpeg', mode = 'wb')
knitr::include_graphics('images/RStudioConsole.jpeg')
