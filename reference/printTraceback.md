# Prints the last .NET exception

This is roughly the equivalent of the traceback function of R.

## Usage

``` r
printTraceback()
```

## Examples

``` r
if (FALSE) { # \dontrun{
callStatic(
  getRSharpSetting("testCasesTypeName"), "
           ThrowException",
  10L
) # will be truncated by the Rf_error API
printTraceback() # prints the full stack trace
} # }
```
