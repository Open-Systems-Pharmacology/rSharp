# Declares the S4 class that is used to hold references to .NET objects.
setClass("cobjRef", representation(clrobj = "externalptr", clrtype = "character"), prototype = list(clrobj = NULL, clrtype = "System.Object"))

#' Create if possible an S4 CLR object.
#'
#' Create if possible and adequate the S4 object that wraps the external pointer to a `cobjRef` object.
#'
#' @param obj the presumed external pointer.
#' @param clrtype character; the name of the type for the object. If NULL, rSharp retrieves the type name.
#' @return a cobjRef S4 object if the argument is indeed an external pointer,
#' otherwise returned unchanged.
#' @import methods
.mkClrObjRef <- function(obj, clrtype = NULL) {
  # Create a new `cobjRef` instance if obj is a pointer
  if (inherits(obj, "externalptr")) {
    # If no type is provided, retrieve it from .NET
    if (is.null(clrtype)) {
      clrtype <- clrTypeNameExtPtr(obj)
    }
    return(new("cobjRef", clrobj = obj, clrtype = clrtype))
  }
  # Otherwise return unchanged
  else {
    return(obj)
  }
}
