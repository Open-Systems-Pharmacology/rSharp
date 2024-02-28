#' Loads a Common Language assembly.
#'
#' Note that this is loaded in the single application domain that is created by rClr, not a separate application domain.
#'
#' @param name a character vector of length one. It can be the full file name of the assembly to load, or a fully qualified assembly name, or as a last resort a partial name.
#' @seealso \code{\link{.C}} which this function wraps
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' clrGetLoadedAssemblies()
#' f <- file.path("SomeDirectory", "YourDotNetBinaryFile.dll")
#' f <- path.expand(f)
#' stopifnot(file.exists(f))
#' clrLoadAssembly(f)
#' # Load an assembly from the global assembly cache (GAC)
#' clrLoadAssembly("System.Windows.Presentation,
#'   Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
#' # The use of partial assembly names is discouraged; nevertheless it is supported
#' clrLoadAssembly("System.Web.Services")
#' clrGetLoadedAssemblies()
#' }
clrLoadAssembly <- function(name) {
  result <- .C("rSharp_load_assembly", name, PACKAGE = rSharpEnv$nativePkgName)
}

#' List the names of loaded CLR assemblies
#'
#' @param fullname Boolean. Should the full name of the assemblies be returned?
#' Default is `FALSE`
#' @param filenames Boolean. If `TRUE`, return a data frame where the second
#' column is the URI (usually file path) of the loaded assembly. Default is `FALSE`
#' @return The names of loaded CLR assemblies
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' clrGetLoadedAssemblies()
#' }
clrGetLoadedAssemblies <- function(fullname = FALSE, filenames = FALSE) {
  assNames <- callStatic(rSharpEnv$reflectionHelperTypeName, "GetLoadedAssemblyNames", fullname)
  if (filenames) {
    # Workarount until https://github.com/Open-Systems-Pharmacology/rClr/issues/25 is fixed
    assNames <- assNames[which(assNames != "Anonymously Hosted DynamicMethods Assembly" &
      assNames != "Anonymously Hosted DynamicMethods Assembly, Version=0.0.0.0, Culture=neutral, PublicKeyToken=null", useNames = FALSE)]

    return(data.frame(AssemblyName = assNames, URI = callStatic(rSharpEnv$reflectionHelperTypeName, "GetLoadedAssemblyURI", assNames)))
  }
  return(assNames)
}

#' Get a list of CLR type names exported by an assembly
#'
#' @param assemblyName the name of the assembly
#' @return The names of the types exported by the assembly
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' clrGetLoadedAssemblies()
#' clrGetTypesInAssembly("ClrFacade")
#' }
clrGetTypesInAssembly <- function(assemblyName) {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetTypesInAssembly", assemblyName)
}
