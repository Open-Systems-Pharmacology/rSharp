#' Prints the last .NET exception
#'
#' This is roughly the equivalent of the traceback function of R.
#'
#' @export
#' @examples
#' callStatic(getRSharpSetting("testCasesTypeName"), "ThrowException", 10L) # will be truncated by the Rf_error API
#' printTraceback() # prints the full stack trace
printTraceback <- function() {
  cat(clrGet(rSharpEnv$InternalTypeName, "LastException"))
  invisible(NULL)
}
