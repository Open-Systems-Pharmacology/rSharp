#' Turn on/off the conversion of advanced data types with R.NET
#'
#' Turn on/off the conversion of advanced data types with R.NET. This will turn off the conversion of classes such as dictionaries into R lists,
#' as these are not bidirectional and you may want to see and manipulate external pointers to dictionaries in some circumstances.
#'
#' @param enable if true enable, otherwise disable
#' @export
#' @examples
#' library(rSharp)
#' cTypename <- getRSharpSetting("testCasesTypeName")
#' callStatic(cTypename, "CreateStringDictionary")
#' setConvertAdvancedTypes(FALSE)
#' callStatic(cTypename, "CreateStringDictionary")
setConvertAdvancedTypes <- function(enable = TRUE) {
  invisible(callStatic("ClrFacade.RDotNetDataConverter", "SetConvertAdvancedTypes", enable))
}

#' Calls the ToString method of an object
#'
#' @description
#'
#' Calls the ToString method of an object as represented in the .NET.
#' This function is here to help quickly test object equivalence from the R interpreter,
#'  for instance on the tricky topic of date-time conversions
#'
#' @param x any R object, which is converted to a .NET object on which to call ToString
#' @return The string representation of the object in .NET
#' @export
#' @examples
#' library(rSharp)
#' dt <- as.POSIXct("2001-01-01 02:03:04", tz = "UTC")
#' toStringNET(dt)
toStringNET <- function(x) {
  return(callStatic(rSharpEnv$InternalTypeName, "ToString", x))
}

#' List the instance fields of a .NET object
#'
#' @param clrobj CLR object
#' @param contains a string that the field names returned must contain
#' @return a list of names of the fields of the .NET object
#' @export
#' @examples
#' testClassName <- rSharpEnv$testObjectTypeName
#' testObj <- newObjectFromName(testClassName)
#' getFields(testObj)
#' getFields(testObj, "ieldInt")
getFields <- function(clrobj, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetInstanceFields", clrobj, contains)
}

#' List the instance properties of a CLR object
#'
#' @param clrobj CLR object
#' @param contains a string that the property names returned must contain
#' @return a list of names of the properties of the CLR object
#' @export
#' @examples
#' testClassName <- "ClrFacade.TestObject"
#' testObj <- newObjectFromName(testClassName)
#' clrGetProperties(testObj)
#' clrGetProperties(testObj, "One")
clrGetProperties <- function(clrobj, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetInstanceProperties", clrobj, contains)
}

#' List the instance methods of a .NET object
#'
#' @param clrobj CLR object
#' @param contains a string that the methods names returned must contain
#' @return a list of names of the methods of the .NET object
#' @export
#' @examples
#' testClassName <- "ClrFacade.TestObject"
#' testObj <- newObjectFromName(testClassName)
#' clrGetMethods(testObj)
#' clrGetMethods(testObj, "Get")
clrGetMethods <- function(clrobj, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetInstanceMethods", clrobj, contains)
}

#' Gets the signature of a .NET object member
#'
#' Gets a string representation of the signature of a member (i.e. field, property, method).
#' Mostly used to interactively search for what arguments to pass to a method.
#'
#' @param clrobj CLR object
#' @param memberName The exact name of the member (i.e. field, property, method) to search for
#' @return a character vector with summary information on the method/member signatures
#' @export
#' @examples
#' testClassName <- "ClrFacade.TestObject"
#' testObj <- newObjectFromName(testClassName)
#' testObj$reflect()
#' clrGetMemberSignature(testObj, "set_PropertyIntegerOne")
#' clrGetMemberSignature(testObj, "FieldIntegerOne")
#' clrGetMemberSignature(testObj, "PropertyIntegerTwo")
clrGetMemberSignature <- function(clrobj, memberName) {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetSignature", clrobj, memberName)
}

#' Create a new CLR object
#'
#' @param typename type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param ... additional method arguments passed to the object constructor via the call to .External
#' @return a CLR object
#' @export
#' @import methods
#' @examples
#' testClassName <- getRSharpSetting("testObjectTypeName")
#' testObj <- newObjectFromName(testClassName)
#' # object with a constructor that has parameters
#' testObj <- clrNew(testClassName, as.integer(123))
clrNew <- function(typename, ...) {
  o <- .External("r_create_clr_object", typename, ..., PACKAGE = rSharpEnv$nativePkgName)
  if (is.null(o)) {
    stop("Failed to create instance of type '", typename, "'")
  }
  .mkClrObjRef(o, clrtype = typename)
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
