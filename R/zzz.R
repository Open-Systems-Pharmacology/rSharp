.onLoad <- function(...) { # nocov start
  # Check for C++ distrib availability
  if (.Platform$OS.type == "windows") {
    if (Sys.which(rSharpEnv$msvcrFileName) == "") {
      stop(paste(rSharpEnv$msvcrFileName, "was not found on this Windows system.",
        "You are probably missing the Visual C++ Redistributable.",
        "Go to https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170 and download the latest 'Microsoft Visual C++ Redistributable'",
        sep = "\n"
      ))
    }
  } else {

  }

  # find installed dotnet runtimes for .NET 8 or higher
  runtimes <- system("dotnet --list-runtimes", intern = TRUE)
  if (!as.numeric(gsub("\\D", "", runtimes[grepl("Microsoft.NETCore.App", runtimes)])) >= 800) {
    stop(paste("No suitable dotnet runtime found. Install dotnet 8 or newer.",
               "Go to https://learn.microsoft.com/en-us/dotnet/core/install/ and follow installation instructions.",
               sep = "\n")
    )
  }

  # Load the C++ and .NET libraries
  .loadAndInit()
}

.loadAndInit <- function() {
  # Path to the folder where the libraries are located
  srcPkgLibPath <- system.file("lib", package = rSharpEnv$packageName)

  nativeLibrary <- file.path(srcPkgLibPath, paste0(rSharpEnv$nativePkgName, .Platform$dynlib.ext))

  # Load C++ library
  dyn.load(nativeLibrary, DLLpath = srcPkgLibPath)

  # Load .NET library through C++
  # The method returns 0 if successful. Otherwise, an error is thrown.
  result <- .External("rSharp_create_domain", srcPkgLibPath, PACKAGE = rSharpEnv$nativePkgName)
  # Turn on the the conversion of advanced data types with R.NET.
  invisible(callStatic("ClrFacade.ClrFacade", "SetRDotNet", TRUE))
} # nocov end
