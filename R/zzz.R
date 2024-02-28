nativePkgName <- "RsharpMs"

# nocov start
.onLoad <- function(...) {
  # Check for C++ distrib availability
  if (.Platform$OS.type == "windows") {
    if (Sys.which(rSharpEnv$msvcrFileName) == "") {
      stop(paste(rSharpEnv$msvcrFileName, "was not found on this Windows system.",
        "You are probably missing the Visual C++ Redistributable.",
        "Go to https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170 and download the latest 'Microsoft Visual C++ Redistributable'",
        sep = "\n"
      ))
    }
  }
  # Load the C++ and .NET libraries
  .loadAndInit()
}

.loadAndInit <- function() {
  # Path to the folder where the libraries are located
  srcPkgLibPath <- system.file("lib", package = rSharpEnv$packageName)

  nativeLibrary <- file.path(srcPkgLibPath, paste0(rSharpEnv$nativePkgName, .Platform$dynlib.ext))

  # Load C++ library
  # save current working directory
  og_wd <- getwd()

  # change working directory to load libs
  message("Temporary working directory:", srcPkgLibPath)
  setwd(srcPkgLibPath)

  dyn.load(nativeLibrary, DLLpath = srcPkgLibPath)
  # Load .NET library through C++
  # The call to `.C` always returns the list of arguments that were passed.
  # They are of no use for us, so enclose the call in `invisible()`.
  invisible(.C("rSharp_create_domain", srcPkgLibPath, PACKAGE = rSharpEnv$nativePkgName))

  # Turn on the the conversion of advanced data types with R.NET.
  invisible(clrCallStatic("ClrFacade.RDotNetDataConverter", "SetRDotNet", TRUE))

  setwd(og_wd)
}
