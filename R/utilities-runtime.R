#' Prints the last CLR exception
#'
#' This is roughly the equivalent of the traceback function of R.
#'
#' @export
#' @examples
#' \dontrun{
#' callStatic("Rclr.TestCases", "ThrowException", 10L) # will be truncated by the Rf_error API
#' clrTraceback() # prints the full stack trace
#' }
clrTraceback <- function() {
  cat(clrGet(rSharpEnv$clrFacadeTypeName, "LastException"))
  invisible(NULL)
}

#' Shuts down the current runtime.
#'
#' @return nothing is returned by this function
#' @export
clrShutdown <- function() { # TODO: is this even possible given runtime's constraints?
  result <- .C("rclr_shutdown_clr", PACKAGE = rSharpEnv$nativePkgName)
}
