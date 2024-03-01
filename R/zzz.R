# An internal variable that is set ot the name of the native library depending on its use of the Mono or MS.NET CLR
nativePkgName <- ''

# An internal variable to buffer startup messages
startupMsg <- ''

#' rSharp .onLoad
#'
#' Function called when loading the rSharp package with 'library'.
#'
#' The function looks by default for the rSharp native library for the Mono runtime.
#' If the platform is Linux, this is the only option. If the platform is Windows, using the
#' Microsoft .NET runtime is an option. If the rSharp native library for MS.NET is detected,
#' the Microsoft .NET runtime is loaded in preference to Mono.
#'
#' @param libname the path to the library from which the package is loaded
#' @param pkgname the name of the package.
#' @rdname dotOnLoad
#' @name dotOnLoad
.onLoad <- function(libname='~/R', pkgname='rSharp') {
  rSharp_env=Sys.getenv('RSHARP')
  monoexepath <- Sys.which('mono')
  ext <- .Platform$dynlib.ext
  nativeLibsNames <- paste(c('rSharpUX', 'RsharpMs'), ext, sep='')
  monoDll <- nativeLibsNames[1]
  msDll <- nativeLibsNames[2]
  getFnameNoExt <- function(x) {strsplit(x, '\\.')[[1]][1]}
  rSharpPkgDir <- file.path(libname, pkgname)
  archLibPath <- file.path(rSharpPkgDir, 'libs')
  srcPkgLibPath <- NULL
  if(!file.exists(archLibPath)) {
    # It may be because this is loaded through the 'document' and 'load_all' functions from devtools,
    # in which case libname is something like "f:/codeplex"
    # try to cater for load_all behavior.
    if( 'rsharp' %in% tolower(list.files(libname))) {
      libname <- file.path(rSharpPkgDir, 'inst')
      archLibPath <- file.path(rSharpPkgDir, 'inst/libs')
      srcPkgLibPath <- archLibPath
      if(!file.exists(archLibPath)) {
        stop(paste('Looked like rSharp source code directory, but directory not found:', archLibPath))
      }
    } else {
      stop(paste("Trying to work around devtools, but could not find a folder with lowercase name 'rSharp' under ", archLibPath))
    }
  }
  dlls <- list.files(archLibPath, pattern=ext)
  if ( Sys.info()[['sysname']] == 'Windows') {
    if ( rSharp_env!='Mono') {
      msvcrFileName <- 'msvcp140.dll'
      if( Sys.which(msvcrFileName) == '') {
        stop(paste(msvcrFileName, "was not found on this Windows system.",
          "You are probably missing the Visual C++ Redistributable for Visual Studio 2019.",
          "Go to https://visualstudio.microsoft.com/downloads/ and dowload 'Microsoft Visual C++ Redistributable for Visual Studio 2019'",
          sep="\n"))
      }
      if(!(msDll %in% dlls)) {
        stop(paste('rSharp library .NET not found - looked under', archLibPath, 'but not found in', paste(dlls, collapse=',')))
      }
      appendStartupMsg('Loading the dynamic library for Microsoft .NET runtime...')
      chname <- getFnameNoExt(msDll)
      loadAndInit(chname, pkgname, libname, srcPkgLibPath)
    }
  } else { # not on Windows.
    appendStartupMsg('Loading the dynamic library for Mono runtime...')
    chname <- "rSharpUX"
    loadAndInit(chname, pkgname, libname, srcPkgLibPath)
  }
}

loadAndInit <- function(chname, pkgname, libname, srcPkgLibPath=NULL) {
  assign("nativePkgName", chname, inherits=TRUE)
  # cater for devtools 'load_all'; library.dynam fails otherwise.
  if(!is.null(srcPkgLibPath)) {
    ext <- .Platform$dynlib.ext
    # srcPkgLibPath ends with platform separator (e.g. '/')
    f <- file.path(srcPkgLibPath, paste0(chname, ext))

    # save current working directory
    og_wd <- getwd()

    # change working directory to load libs
    message("Temporary working directory:", srcPkgLibPath)
    setwd(srcPkgLibPath)
    dyn.load(f)

  } else {
    library.dynam(chname, pkgname, libname)
  }
  # should the init of the mono runtime try to attach to a Monodevelop debugger?
  debug_flag=Sys.getenv('RSHARP_DEBUG')
  clrInit(debug_flag!="")
  appendStartupMsg(paste('Loaded Common Language Runtime version', getClrVersionString()))
  setRDotNet(TRUE)

  if (exists("og_wd")) {
    # restore the original working directory
    setwd(og_wd)
  }
}

appendStartupMsg <- function(msg) {
  startupMsg <<- paste0(startupMsg, msg, '\n')
}

#' Gets the version of the common language runtime in use
#'
#' Gets the version of the common language runtime in use.
#'
#' @return the version of the common language runtime in use
#' @export
getClrVersionString <- function() {
  v <- clrGet('System.Environment', 'Version')
  retval <- clrCall(v, 'ToString')
}

#' rSharp .onAttach
#'
#' Print startup messages from package onLoad
#'
#' Print startup messages from package onLoad (prevents a 'NOTE' on package check)
#'
#' @rdname dotOnAttach
#' @name dotOnAttach
#' @param libname the path to the library from which the package is loaded
#' @param pkgname the name of the package.
.onAttach <- function(libname='~/R', pkgname='rSharp') {
  if(startupMsg!='') {
    packageStartupMessage(startupMsg)
  }
}
