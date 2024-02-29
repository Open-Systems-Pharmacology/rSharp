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
#' getLoadedAssemblies()
#' f <- file.path("SomeDirectory", "YourDotNetBinaryFile.dll")
#' f <- path.expand(f)
#' stopifnot(file.exists(f))
#' clrLoadAssembly(f)
#' # Load an assembly from the global assembly cache (GAC)
#' clrLoadAssembly("System.Windows.Presentation,
#'   Version=3.5.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
#' # The use of partial assembly names is discouraged; nevertheless it is supported
#' clrLoadAssembly("System.Web.Services")
#' getLoadedAssemblies()
#' }
clrLoadAssembly <- function(name) {
  result <- .C("rSharp_load_assembly", name, PACKAGE = rSharpEnv$nativePkgName)
}

#' List the names of loaded assemblies
#'
#' @param fullname should the full name of the assemblies be returned. `FALSE` by default.
#' @param filenames if TRUE, return a data frame where the second column is the URI (usually file path) of the loaded assembly. `FALSE` by default.
#' @return the names of loaded assemblies
#' @export
#' @examples
#' getLoadedAssemblies()
getLoadedAssemblies <- function(fullname = FALSE, filenames = FALSE) {
  assNames <- clrCallStatic(rSharpEnv$reflectionHelperTypeName, "GetLoadedAssemblyNames", fullname)
  if (filenames) {
    data.frame(AssemblyName = assNames, URI = clrCallStatic(rSharpEnv$reflectionHelperTypeName, "GetLoadedAssemblyURI", assNames))
  } else {
    assNames
  }
}

#' Get a list of CLR type names exported by an assembly
#'
#' @param assemblyName the name of the assembly
#' @return The names of the types exported by the assembly
#' @export
#' @examples
#' \dontrun{
#' library(rClr)
#' getLoadedAssemblies()
#' clrGetTypesInAssembly("ClrFacade")
#' }
clrGetTypesInAssembly <- function(assemblyName) {
  callStatic(rSharpEnv$reflectionHelperTypeName, "GetTypesInAssembly", assemblyName)
}
