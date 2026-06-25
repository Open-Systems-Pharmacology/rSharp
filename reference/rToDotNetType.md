# Gets the type of a .NET object resulting from converting an R object

Gets the type of a .NET object resulting from converting an R object.
This function is mostly for documentation purposes, but may be of use to
end users.

## Usage

``` r
rToDotNetType(x)
```

## Arguments

- x:

  An R object

## Value

A list, with columns including mode, type, class, length and the string
of the corresponding .NET type.

## Examples

``` r
rToDotNetType(1)
#> $mode
#> [1] "numeric"
#> 
#> $type
#> [1] "double"
#> 
#> $class
#> [1] "numeric"
#> 
#> $length
#> [1] 1
#> 
#> $clrType
#> [1] "System.Double"
#> 
```
