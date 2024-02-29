#' Gets the external pointer CLR object.
#'
#' @param clrObject a S4 object of class clrobj
#' @return the external pointer to the CLR object
.clrGetExtPtr <- function(clrObject) {
  clrObject@clrobj
}
