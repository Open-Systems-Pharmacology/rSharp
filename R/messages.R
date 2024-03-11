messages <- list()

messages$errorPackageSettingNotFound <- function(settingName, globalEnv) {
  paste0(
    "No global setting with the name '",
    settingName,
    "' exists. Available global settings are:\n",
    paste0(names(globalEnv), collapse = ", ")
  )
}

messages$errorNoExternalPointer <- function() {
  "Trying to create an object, but external pointer to .NET is invalid!"
}

messages$errorPropertyReadOnly <- function(propertyName, optionalMessage = NULL) {
  paste0(
    "Property '",
    propertyName,
    "' is read-only and cannot be modified.",
    if (!is.null(optionalMessage)) {
      paste0(" ", optionalMessage)
    }
  )
}

messages$errorMethodNotFound <- function(methodName, typeName) {
  paste0(
    "Method '",
    methodName,
    "' does not exist in the type '",
    typeName,
    "'."
  )
}

messages$errorNotANetObjectClass <- function() {
  "Trying to create an object, but the class is not a subclass of `NetObject`!"
}
