checkIsExtPtr <- function(extPtr) {
  stopifnot("externalptr" %in% class(extPtr))
}

getLibsPath <- function(pkgName) {
  libLocation <- system.file(package = pkgName)
  file.path(libLocation, "lib")
}
