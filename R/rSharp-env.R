# Environment that holds various global variables and settings for the package.
# It is not exported and should not be directly manipulated by other packages.
rSharpEnv <- new.env(parent = emptyenv())

# name of the package. This will be used to retrieve information on the package at run time
rSharpEnv$packageName <- "rSharp"
# Name of the C++ redistributable library
rSharpEnv$msvcrFileName <- "msvcp140.dll"
# The name of the native (C++) library file depends on operating system
if (.Platform$OS.type == "windows") {
  rSharpEnv$nativePkgName <- "RsharpMs"
} else {
  # Assuming that everything non-windows is Linux (or will simply not work at all)
  rSharpEnv$nativePkgName <- "RsharpUX"
}
# Name of the .NET library
rSharpEnv$dotnetPkgName <- "ClrFacade"

# Full type name of the reflection helper the interop code written in C#
rSharpEnv$reflectionHelperTypeName <- "ClrFacade.ReflectionHelper"
# Full type name of the main facade to the interop code written in C#
rSharpEnv$clrFacadeTypeName <- "ClrFacade.ClrFacade"
# Full type name of the Internal code written in C#
rSharpEnv$InternalTypeName <- "ClrFacade.Internal"
# Full type name of the test cases
rSharpEnv$testCasesTypeName <- "ClrFacade.TestCases"
# Full name of test object class
rSharpEnv$testObjectTypeName <- "ClrFacade.TestObject"


#' Names of the settings stored in rSharpEnv Can be used with `getRSharpSetting()`
#' @export
rSharpSettingNames <- names(rSharpEnv)

#' Get the value of a global `{rShapr}` setting.
#'
#' @param settingName String name of the setting
#'
#' @return Value of the setting stored in rSharpEnv. If the setting does not exist, an error is thrown.
#' @export
#'
#' @examples
#' getRSharpSetting("nativePkgName")
getRSharpSetting <- function(settingName) {
  if (!(any(names(rSharpEnv) == settingName))) {
    stop(messages$errorPackageSettingNotFound(settingName, rSharpEnv))
  }

  obj <- rSharpEnv[[settingName]]
  # Evaluate if the object is a function. This is required since some properties are defined as function reference
  if (is.function(obj)) {
    return(obj())
  }

  return(obj)
}
