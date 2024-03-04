#' Create if possible an object of the R6 class `NetObject`
#'
#' @details
#'
#' Create if possible and adequate the R6 object of the class `NetObject`
#' that wraps the external pointer to a .NET object.
#' If `obj` is not a pointer, returns `obj` unchanged.
#'
#' @param obj the presumed external pointer.
#'
#' @return A `NetObject` R6 object if the argument is indeed an external pointer,
#' otherwise returned unchanged.
castToRObject <- function(obj) {
  # Create a new NetObject instance if obj is a pointer
  if (is(obj, "externalptr")) {
    return(NetObject$new(obj))
  }

  # If obj is the S4 object of type cobjRef, return create a new NetObject
  if (inherits(obj, "cobjRef")) {
    return(NetObject$new(obj@clrobj))
  }

  # Otherwise return the object unchanged
  return(obj)
}

#' Create a new NetObject R6 object given the type name.
#'
#' @param typename type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param ... additional method arguments passed to the object constructor via the call to .External
#' @return a `NetObject` R6 object
#' @export
#' @examples
#' testClassName <- getRSharpSetting("testObjectTypeName")
#' testObj <- newObjectFromName(testClassName)
#' # object with a constructor that has parameters
#' testObj <- newObjectFromName(testClassName, as.integer(123))
newObjectFromName <- function(typename, ...) {
  o <- .External("r_create_clr_object", typename, ..., PACKAGE = rSharpEnv$nativePkgName)
  if (is.null(o)) {
    stop("Failed to create instance of type '", typename, "'")
  }
  NetObject$new(o)
}


###########################


#' Gets the value of a static field or property of a class
#'
#' @param type Type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param name the name of a field/property  of the object
#' @return An object resulting from the call. May be a `NetObject` object, or a native R object for common types. Can be NULL.
#' @export
#' @examples
#' testClassName <- rSharpEnv$testObjectTypeName
#' getStatic(testClassName, "StaticPropertyIntegerOne")
getStatic <- function(type, name) {
  return(callStatic(rSharpEnv$clrFacadeTypeName, "GetFieldOrProperty", type, name))
}

#' Sets the value of a field or property of an object or class
#'
#' @param objOrType a CLR object, or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param name the name of a field/property of the object
#' @param value the value to set the field with
#' @export
#' @examples
#' testClassName <- rSharpEnv$testObjectTypeName
#' testObj <- newObjectFromName(testClassName)
#' clrSet(testObj, "FieldIntegerOne", as.integer(42))
#' clrSet(testClassName, "StaticPropertyIntegerOne", as.integer(42))
clrSet <- function(objOrType, name, value) {
  invisible(callStatic(rSharpEnv$clrFacadeTypeName, "SetFieldOrProperty", objOrType, name, value))
}
