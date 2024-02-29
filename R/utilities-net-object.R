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
createNetObject <- function(obj) {
  # Return NULL if `obj`is NULL
  if (is.null(obj)) {
    return(NULL)
  }

  # Create a new NetObject instance if obj is a pointer
  if (is(obj, "externalptr")) {
    return(NetObject$new(obj))
  }

  # Return the object unchanged
  return(obj)
}


###########################

#' Check whether an object is of a certain type
#'
#' This function is meant to match the behavior of the 'is' keyword in C#.
#'
#' @param obj an object
#' @param type the object type to check for. It can be a character, of a object of CLR type System.RuntimeType
#' @return TRUE or FALSE
#' @export
#' @examples
#' testClassName <- "ClrFacade.TestObject"
#' testObj <- clrNew(testClassName)
#' clrIs(testObj, testClassName)
#' clrIs(testObj, "System.Object")
clrIs <- function(obj, type) {
  if (is.character(type)) {
    tmpType <- clrGetType(type)
    if (is.null(tmpType)) {
      stop(paste("Unrecognized type name", type))
    } else {
      type <- tmpType
    }
  }
  if (!is(type, "cobjRef")) {
    stop(paste('argument "type" must be a CLR type name or a Type'))
  } else {
    typetypename <- clrGet(clrCall(type, "GetType"), "Name")
    if (!(typetypename %in% c("RuntimeType", "MonoType"))) {
      stop(paste('argument "type" must be a CLR Type. Got a', typetypename))
    }
  }
  objType <- clrGetType(obj)
  return(clrCall(type, "IsAssignableFrom", objType))
}


#' Call a method on an object
#'
#' @param obj an object
#' @param methodName the name of a method of the object
#' @param ... additional method arguments passed to .External
#' @return an object resulting from the call. May be a CLR object, or a native R object for common types. Can be NULL.
#' @export
#' @examples
#' testClassName <- rSharpEnv$testObjectTypeName
#' testObj <- clrNew(testClassName)
#' clrCall(testObj, "GetFieldIntegerOne")
clrCall <- function(obj, methodName, ...) {
  interface <- "r_call_method"
  result <- NULL
  result <- .External(interface, obj@clrobj, methodName, ..., PACKAGE = rSharpEnv$nativePkgName)
  return(.mkClrObjRef(result))
}

#' Gets the value of a field or property of an object or class
#'
#' @param objOrType a CLR object, or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param name the name of a field/property  of the object
#' @return an object resulting from the call. May be a CLR object, or a native R object for common types. Can be NULL.
#' @export
#' @examples
#' testClassName <- rSharpEnv$testObjectTypeName
#' testObj <- clrNew(testClassName)
#' clrReflect(testObj)
#' clrGet(testObj, "FieldIntegerOne")
#' clrGet(testClassName, "StaticPropertyIntegerOne")
clrGet <- function(objOrType, name) {
  return(callStatic(rSharpEnv$clrFacadeTypeName, "GetFieldOrProperty", objOrType, name))
}

#' Sets the value of a field or property of an object or class
#'
#' @param objOrType a CLR object, or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param name the name of a field/property of the object
#' @param value the value to set the field with
#' @export
#' @examples
#' testClassName <- rSharpEnv$testObjectTypeName
#' testObj <- clrNew(testClassName)
#' clrReflect(testObj)
#' clrSet(testObj, "FieldIntegerOne", as.integer(42))
#' clrSet(testClassName, "StaticPropertyIntegerOne", as.integer(42))
clrSet <- function(objOrType, name, value) {
  invisible(callStatic(rSharpEnv$clrFacadeTypeName, "SetFieldOrProperty", objOrType, name, value))
}

#' Gets the type name of an object
#'
#' Gets the CLR type name of an object, given an S4 clrobj object
#'
#' @param clrobj CLR object
#' @return type name
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' testClassName <- "Rclr.TestObject"
#' testObj <- clrNew(testClassName)
#' clrTypename(testObj)
#' }
clrTypename <- function(clrobj) {
  return(.Call("r_get_type_name", clrobj, PACKAGE = rSharpEnv$nativePkgName))
}
