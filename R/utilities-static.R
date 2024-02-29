#' Gets the static members for a type
#'
#' @param objOrType a .NET object, or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @export
#' @examples
#' cTypename <- getRSharpSetting("testCasesTypeName")
#' getStaticMembers(cTypename)
getStaticMembers <- function(objOrType) {
  list(Methods = getStaticMethods(objOrType), Fields = getStaticFields(objOrType), Properties = getStaticProperties(objOrType))
}

#' Gets the static fields for a type
#'
#' @param objOrType a .NET object, or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param contains a string that the property names returned must contain
#' @export
getStaticFields <- function(objOrType, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetStaticFields", objOrType, contains)
}

#' Gets the static properties for a type
#'
#' @inheritParams getStaticFields
#' @export
getStaticProperties <- function(objOrType, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetStaticProperties", objOrType, contains)
}

#' Gets the static methods for a type
#'
#' @inheritParams getStaticFields
#' @export
getStaticMethods <- function(objOrType, contains = "") {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetStaticMethods", objOrType, contains)
}

#' Call a static method on a .NET type
#'
#' @param typename type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param methodName the name of a static method of the type
#' @param ... additional method arguments passed to .External (e.g., arguments to the method)
#' @return an object resulting from the call. May be a `cobjRef` object, or a native R object for common types. Can be NULL.
#' @export
#' @examples
#' cTypename <- getRSharpSetting("testCasesTypeName")
#' callStatic(cTypename, "IsTrue", TRUE)
callStatic <- function(typename, methodName, ...) {
  extPtr <- .External("r_call_static_method", typename, methodName, ..., PACKAGE = rSharpEnv$nativePkgName)
  return(createNetObject(extPtr))
}

#' Gets the signature of a static member of a type
#'
#' @param typename type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @param memberName The exact name of the member (i.e. field, property, method) to search for
#' @export
getStaticMemberSignature <- function(typename, memberName) {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetSignature", typename, memberName)
}
