#' Gets the names of a .NET Enum value type
#'
#' @param enumType a .NET object, System.Type or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @return a character vector of the names for the enum
#' @export
#' @examples
#' getEnumNames("Rclr.TestEnum")
getEnumNames <- function(enumType) {
  return(callStatic(rSharpEnv$reflectionHelperTypeName, "GetEnumNames", enumType))
}
