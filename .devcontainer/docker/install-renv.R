local({
  version <- commandArgs(trailingOnly = TRUE)[1]

  if (is.na(version) || version == "latest") {
    install.packages("renv")
    return(TRUE)
  }

  db <- as.data.frame(utils::available.packages(),
                      stringsAsFactors = FALSE)
  if (any(db$Package == "renv" & db$Version == version)) {
    install.packages("renv")
    return(TRUE)
  }

  name <- sprintf("renv_%s.tar.gz", version)
  repos <- getOption("repos")
  url <- file.path(repos, "src/contrib/Archive/renv", name)
  destfile <- file.path(tempdir(), name)
  utils::download.file(
    url      = url,
    destfile = destfile,
    mode     = "wb",
    quiet    = TRUE
  )
  install.packages(pkgs = destfile, type = "source", repos = NULL)
  unlink(destfile)
})
