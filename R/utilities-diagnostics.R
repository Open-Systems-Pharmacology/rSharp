#' Peek into the types of CLR objects arguments are converted to by rClr
#'
#' Advanced use only, to diagnose unexpected conditions in CLR method calls. Most users would not ever need it.
#'
#' @param ... method arguments passed to .External
#' @return a character message with type information about each argument.
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' peekClrArgs("a", numeric(0))
#' }
peekClrArgs <- function(...) {
  extPtr <- .External("r_diagnose_parameters", ..., PACKAGE = rSharpEnv$nativePkgName)
  return(createNetObject(extPtr))
}

#' Get the type code for a SEXP
#'
#' Get the type code for a SEXP, as returned by the TYPEOF macro
#'
#' @param sexp an R object
#' @return the type code, an integer, as defined in Rinternals.h
#' @export
getSexpType <- function(sexp) {
  extPtr <- .External("r_get_sexp_type", sexp, PACKAGE = rSharpEnv$nativePkgName)
  return(createNetObject(extPtr))
}

#' Peek into the structure of R objects 'as seen from C code'
#'
#' Inspect one or more R object to get information on its representation in the engine.
#' This function is mostly useful for R/rClr developers. It is derived from the 'showArgs'
#' example in the R extension manual
#'
#' @param ... one or more R objects
#' @return NULL. Information is printed, not returned.
#' @export
inspectArgs <- function(...) {
  extPtr <- .External("r_show_args", ..., PACKAGE = rSharpEnv$nativePkgName)
  # return(createNetObject(extPtr))
}

#' Get the COM variant type of a CLR object
#'
#' Get the COM variant type of a CLR object, e.g. "VT_ARRAY | VT_I8". This function only works when run on the Microsoft implementation of the CLR.
#' This function is useful for advanced diagnosis; most users should never have to use it.
#'
#' @param objOrType a CLR object, or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param methodName the name of the method called on the object or class specified with objOrType
#' @param ... one or more arguments to pass to the function call
#' @examples
#' \dontrun{
#' library(rClr)
#' cTypename <- "Rclr.TestCases"
#' #         public static bool IsTrue(bool arg)
#' clrVT(cTypename, "IsTrue", TRUE)
#' clrVT("System.Convert", "ToInt64", 123L)
#' clrVT("System.Convert", "ToUInt64", 123L)
#' }
#' @return A string
#' @export
clrVT <- function(objOrType, methodName, ...) {
  return(callStatic("Rclr.DataConversionHelper", "GetReturnedVariantTypename", objOrType, methodName, ...))
  # return(createNetObject(extPtr))
}

#' Gets the type of a CLR object resulting from converting an R object
#'
#' Gets the type of a CLR object resulting from converting an R object. This function is mostly for documentation purposes, but may be of use to end users.
#'
#' @param x An R objects
#' @return A list, with columns including mode, type,class,length and the string of the corresponding CLR type.
#' @export
rToClrType <- function(x) {
  list(
    # what = str(x),
    mode = mode(x),
    type = typeof(x),
    class = class(x),
    length = length(x),
    clrType = callStatic("Rclr.ClrFacade", "GetObjectTypeName", x)
  )
}
