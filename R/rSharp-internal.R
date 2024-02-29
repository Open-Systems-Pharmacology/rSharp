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
      clrtype <- .clrTypeNameExtPtr(obj)
    }
    return(new("cobjRef", clrobj = obj, clrtype = clrtype))
  }
  # Otherwise return unchanged
  else {
    return(obj)
  }
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

#' Gets the type name of an object
#'
#' Gets the type name of an object, given the SEXP external pointer to this .NET object.
#'
#' @param extPtr external pointer to a .NET object (not a cobjRef S4 object)
#' @return a character string, the type name
#' @examples
#' testClassName <- "ClrFacade.TestObject"
#' testObj <- clrNew(testClassName)
#' .clrTypeNameExtPtr(testObj@clrobj)
.clrTypeNameExtPtr <- function(extPtr) {
  .validateIsExtPtr(extPtr)
  .External("r_get_typename_externalptr", extPtr, PACKAGE = rSharpEnv$nativePkgName)
}
