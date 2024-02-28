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

#' Create if possible an S4 CLR object.
#'
#' Create if possible and adequate the S4 object that wraps the external pointer to a CLR object.
#' Currently not exported, as this is unlikely to be recommended for use outside of unit tests and internal to rSharp.
#'
#' @param obj the presumed external pointer.
#' @param clrtype character; the name of the CLR type for the object. If NULL, rSharp retrieves the type name.
#' @return a cobjRef S4 object if the argument is indeed an external pointer,
#' otherwise returned unchanged if null or not an external pointer.
#' @import methods
mkClrObjRef <- function(obj, clrtype = NULL) {
  if (is(obj, "cobjRef")) {
    return(obj)
  }

  if (is.null(obj) == TRUE) {
    return(NULL)
  } else if ("externalptr" %in% class(obj)) {
    if (is.null(clrtype)) {
      clrtype <- clrTypeNameExtPtr(obj)
    }

    return(new("cobjRef", clrobj = obj, clrtype = clrtype))
  } else {
    return(obj)
  }
}
