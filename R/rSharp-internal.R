#' Gets the external pointer CLR object.
#'
#' @param clrObject a S4 object of class clrobj
#' @return the external pointer to the CLR object
.clrGetExtPtr <- function(clrObject) {
  clrObject@clrobj
}

#' System function to get a direct access to an object
#'
#' This function is highly unlikely to be of any use to an end user, even an advanced one.
#' This is indirectly needed to unlock the benefits of using R.NET convert data structures between R and .NET.
#'
#' @return a CLR object
.getCurrentConvertedObject <- function() {
  o <- .External("r_get_object_direct", PACKAGE = rSharpEnv$nativePkgName)
  .mkClrObjRef(o)
}
