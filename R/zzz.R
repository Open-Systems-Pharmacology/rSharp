.onLoad <- function(...) {
  # nocov start
  # Check for C++ distrib availability
  if (.Platform$OS.type == "windows") {
    if (Sys.which(rSharpEnv$msvcrFileName) == "") {
      stop(paste(
        rSharpEnv$msvcrFileName,
        "was not found on this Windows system.",
        "You are probably missing the Visual C++ Redistributable.",
        "Go to https://learn.microsoft.com/en-US/cpp/windows/latest-supported-vc-redist?view=msvc-170 and download the latest 'Microsoft Visual C++ Redistributable'",
        sep = "\n"
      ))
    }
  } else {}

  # find installed dotnet runtimes for .NET 10 or higher
  if (
    length(grep(
      "Microsoft.NETCore.App 10",
      system("dotnet --list-runtimes", intern = TRUE)
    )) ==
      0
  ) {
    stop(paste(
      "No suitable dotnet 10 runtime found. ",
      "Please install dotnet 10: go to  https://learn.microsoft.com/en-us/dotnet/core/install/ and follow installation instructions.",
      sep = "\n"
    ))
  }

  # Load the C++ and .NET libraries
  .loadAndInit()
}

.loadAndInit <- function() {
  # Path to the folder where the libraries are located
  srcPkgLibPath <- system.file("lib", package = rSharpEnv$packageName)
  nativeLibraryPath <- file.path(
    srcPkgLibPath,
    paste0(rSharpEnv$nativePkgName, .Platform$dynlib.ext)
  )

  # Load C++ library
  dyn.load(nativeLibraryPath, DLLpath = srcPkgLibPath)

  # Load .NET library through C++
  # The method returns 0 if successful. Otherwise, an error is thrown.
  result <- .External(
    "rSharp_create_domain",
    enc2native(srcPkgLibPath),
    PACKAGE = rSharpEnv$nativePkgName
  )

  # Turn on the the conversion of advanced data types with R.NET.
  invisible(callStatic("ClrFacade.ClrFacade", "SetRDotNet", TRUE))
} # nocov end
