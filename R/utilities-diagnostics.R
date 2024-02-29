#' Get the type code for a SEXP
#'
#' @description
#'
#' Get the type code for a SEXP, as returned by the TYPEOF macro
#'
#' @param sexp an R object
#' @return the type code, an integer, as defined in Rinternals.h
#' @export
getSexpType <- function(sexp) {
  extPtr <- .External("r_get_sexp_type", sexp, PACKAGE = rSharpEnv$nativePkgName)
  return(.mkClrObjRef(extPtr))
}

#' Peek into the structure of R objects 'as seen from C code'
#'
#' Inspect one or more R object to get information on its representation in the engine.
#' This function is mostly useful for R/rSharp developers. It is derived from the 'showArgs'
#' example in the R extension manual
#'
#' @param ... one or more R objects
#' @return NULL. Information is printed, not returned.
#' @export
inspectArgs <- function(...) {
  invisible(.External("r_show_args", ..., PACKAGE = rSharpEnv$nativePkgName))
}

#' Gets the type of a .NET object resulting from converting an R object
#'
#' @description
#' Gets the type of a .NET object resulting from converting an R object. This function is mostly for documentation purposes, but may be of use to end users.
#'
#' @param x An R object
#' @return A list, with columns including mode, type, class, length and the string of the corresponding .NET type.
#' @export
rToDotNetType <- function(x) {
  list(
    # what = str(x),
    mode = mode(x),
    type = typeof(x),
    class = class(x),
    length = length(x),
    clrType = callStatic(rSharpEnv$clrFacadeTypeName, "GetObjectTypeName", x)
  )
}
