# Loads a .NET assembly.

Loads a .NET assembly.

## Usage

``` r
loadAssembly(name)
```

## Arguments

- name:

  a character vector of length one. It can be the full file name of the
  assembly to load, or a fully qualified assembly name, or as a last
  resort a partial name.

## Value

Name of the loaded assembly, if successfull.

## Details

Note that this is loaded in the single application domain that is
created by rSharp, not a separate application domain.

## See also

[`.C`](https://rdrr.io/r/base/Foreign.html) which this function wraps

## Examples

``` r
if (FALSE) { # \dontrun{
f <- file.path("SomeDirectory", "YourDotNetBinaryFile.dll")
f <- path.expand(f)
stopifnot(file.exists(f))
loadAssembly(f)
} # }
```
