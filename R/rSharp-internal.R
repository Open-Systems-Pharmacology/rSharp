# Full type name of the reflection helper the interop code written in C#
reflectionHelperTypeName <- "ClrFacade.ReflectionHelper"

# Full type name of the main facade to the interop code written in C#
clrFacadeTypeName <- "ClrFacade.ClrFacade"

checkIsExtPtr <- function(extPtr) {
  stopifnot("externalptr" %in% class(extPtr))
}

getLibsPath <- function(pkgName) {
  libLocation <- system.file(package = pkgName)
  file.path(libLocation, "lib")
}
