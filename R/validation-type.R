#' Validate external pointer
#'
#' @param extPtr external pointer to a .NET
#'
#' @keywords internal
#' @noRd
.validateIsExtPtr <- function(extPtr) {
  if (!any(class(extPtr) == "externalptr")) {
    stop(messages$errorNoExternalPointer)
  }
}
