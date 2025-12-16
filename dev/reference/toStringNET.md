# Calls the ToString method of an object

Calls the ToString method of an object as represented in the .NET. This
function is here to help quickly test object equivalence from the R
interpreter, for instance on the tricky topic of date-time conversions

## Usage

``` r
toStringNET(x)
```

## Arguments

- x:

  any R object, which is converted to a .NET object on which to call
  ToString

## Value

The string representation of the object in .NET

## Examples

``` r
library(rSharp)
dt <- as.POSIXct("2001-01-01 02:03:04", tz = "UTC")
toStringNET(dt)
#> [1] "1/1/2001 2:03:04 AM"
```
