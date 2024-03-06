#' List the public constructors of a CLR Type
#'
#'
#' @param type .NET Type, or a (character) type name that can be successfully parsed
#' @return a list of constructor signatures
#' @export
#' @examples
#' testClassName <- "ClrFacade.TestObject"
#' getConstructors(testClassName)
getConstructors <- function(type) {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetConstructors", type)
}
