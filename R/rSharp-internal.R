# Full type name of the reflection helper the interop code written in C#
reflectionHelperTypeName <- "ClrFacade.ReflectionHelper"

checkIsExtPtr <- function(extPtr) {
  stopifnot("externalptr" %in% class(extPtr))
}

getLibsPath <- function(pkgName) {
  libLocation <- system.file(package = pkgName)
  file.path(libLocation, "lib")
}
