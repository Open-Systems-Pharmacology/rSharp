#' Gets the static members for a type
#'
#' @param objOrType a CLR object, or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' cTypename <- "Rclr.TestCases"
#' clrGetStaticMembers(cTypename)
#' testClassName <- "Rclr.TestObject"
#' testObj <- clrNew(testClassName)
#' clrGetStaticMembers(testObj)
#' }
clrGetStaticMembers <- function(objOrType) {
  list(Methods = clrGetStaticMethods(objOrType), Fields = clrGetStaticFields(objOrType), Properties = clrGetStaticProperties(objOrType))
}

#' Gets the static fields for a type
#'
#' @param objOrType a CLR object, or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param contains a string that the property names returned must contain
#' @export
clrGetStaticFields <- function(objOrType, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetStaticFields", objOrType, contains)
}

#' Gets the static properties for a type
#'
#' @inheritParams clrGetStaticFields
#' @export
clrGetStaticProperties <- function(objOrType, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetStaticProperties", objOrType, contains)
}

#' Gets the static methods for a type
#'
#' @inheritParams clrGetStaticFields
#' @export
clrGetStaticMethods <- function(objOrType, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetStaticMethods", objOrType, contains)
}

#' Call a static method on a .NET type
#'
#' @param typename type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param methodName the name of a static method of the type
#' @param ... additional method arguments passed to .External (e.g., arguments to the method)
#' @return an object resulting from the call. May be a `NetObject` object, or a native R object for common types. Can be NULL.
#' @export
#' @examples
#' \dontrun{
#' cTypename <- "Rclr.TestCases"
#' callStatic(cTypename, "IsTrue", TRUE)
#' }
callStatic <- function(typename, methodName, ...) {
  extPtr <- .External("r_call_static_method", typename, methodName, ..., PACKAGE = rSharpEnv$nativePkgName)
  return(createNetObject(extPtr))
}

#' Gets the signature of a static member of a type
#'
#' @param typename type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param memberName The exact name of the member (i.e. field, property, method) to search for
#' @export
clrGetStaticMemberSignature <- function(typename, memberName) {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetSignature", typename, memberName)
}
