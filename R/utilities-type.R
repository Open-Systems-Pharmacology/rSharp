#' List the public constructors of a CLR Type
#'
#' @param type CLR Type, or a (character) type name that can be successfully parsed
#' @return a list of constructor signatures
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' testClassName <- "Rclr.TestObject"
#' clrGetConstructors(testClassName)
#' }
clrGetConstructors <- function(type) {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetConstructors", type)
}
