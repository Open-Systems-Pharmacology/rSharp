#' Gets the names of a CLR Enum value type
#'
#' @param enumType a CLR object, System.Type or type name, possibly namespace and assembly qualified type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.
#' @return a character vector of the names for the enum
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' clrGetEnumNames("Rclr.TestEnum")
#' }
clrGetEnumNames <- function(enumType) {
  return(callStatic(rSharpEnv$reflectionHelperTypeName, "GetEnumNames", enumType))
}
