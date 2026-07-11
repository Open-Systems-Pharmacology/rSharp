# Changelog

## rSharp 1.2.3

- [`dotnetAvailable()`](http://www.open-systems-pharmacology.org/rSharp/reference/dotnetAvailable.md)
  is a new exported function that reports whether the .NET runtime is
  available, so code, examples, and vignettes can run .NET only when a
  runtime is present.
- rSharp now also loads gracefully when a `dotnet` command is present
  but the native runtime host cannot be loaded (for example some build
  machines that ship the .NET SDK), extending the graceful handling of a
  missing runtime introduced in 1.2.2. The reason is reported when the
  package is attached and raised with an actionable message on the first
  call into .NET.
- The user guide vignette now renders on machines without a .NET
  runtime, showing its .NET examples without executing them, so the
  package builds where no runtime is available.

## rSharp 1.2.2

- rSharp now installs and loads even when a suitable .NET runtime is
  absent, instead of failing at load time. A missing runtime is reported
  when the package is attached and raised with an actionable message on
  the first call into .NET, which allows the package (and packages
  depending on it) to be built and checked in environments without .NET.

## rSharp 1.2.1

### Minor improvements and bug fixes

- Fixed a crash and hang in parallel test suites caused by
  `R_ReleaseObject` being called from the .NET finalizer thread
  ([\#212](https://github.com/Open-Systems-Pharmacology/rsharp/issues/212)).
- Fixed a `GCHandle` leak in the R to .NET argument-marshalling path
  that caused both the R and .NET heaps to grow with each call
  ([\#206](https://github.com/Open-Systems-Pharmacology/rsharp/issues/206)).

## rSharp 1.2.0

### Minor improvements and bug fixes

- Declared `dotnet8` in the `SystemRequirements` field of `DESCRIPTION`
  ([\#177](https://github.com/Open-Systems-Pharmacology/rsharp/issues/177)).
- Fixed package failing to load on R 4.6 with
  `undefined symbol: EXTPTR_PTR` by switching the C++ shim to the stable
  `R_ExternalPtrAddr()` API.
- Fixed macOS install-time segfault for users with multiple R versions
  installed in parallel by removing the versioned `R.framework` path
  baked into the shipped `.so`. The macOS link line now uses
  `-undefined dynamic_lookup` instead of `-lR`, matching the convention
  used by other R packages with C++ code.
- Arrays of .NET objects are now supported as arguments to methods.
  However, the signature of the .NET method must accept `Object[]` as
  parameter type.
- Fixed `object '.slotNames' not found` error when constructing S4
  objects on runners where the `methods` package is not attached to the
  search path, by qualifying the lookup as
  [`methods::.slotNames`](https://rdrr.io/r/methods/slot.html).

## rSharp 1.1.2

### Minor improvements and bug fixes

- Enhanced object printing with the {cli} package for more readable
  output.
- Added {cli} package as a dependency for improved formatting
  capabilities.

## rSharp 1.1.1

### Minor improvements and bug fixes

- Solved a bug that prevented the package from being installed on
  Windows when the user had a R library path containing special
  characters.
  ([\#165](https://github.com/Open-Systems-Pharmacology/rsharp/issues/165))

## rSharp 1.1.0

### Major changes

- rSharp is now compatible with macOS (tested on ARM)

## rSharp 1.0.1

### Minor improvements and bug fixes

- Fixed a bug that prevented rSharp installation when the user had a R
  library path containing special characters.

## rSharp 1.0.0

- First release of the
  [rSharp](https://github.com/Open-Systems-Pharmacology/rsharp/)
  package.

### Minor improvements and bug fixes

- github actions implementation for windows and Ubuntu R package builds.
- github actions for C# binary builds for windows and Ubuntu.
