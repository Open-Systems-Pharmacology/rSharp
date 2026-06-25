# Get the type code for a SEXP

Get the type code for a SEXP, as returned by the TYPEOF macro

## Usage

``` r
getSexpType(sexp)
```

## Arguments

- sexp:

  an R object

## Value

the type code, an integer, as defined in Rinternals.h

## Examples

``` r
getSexpType(1)
#> [1] 14
getSexpType("a")
#> [1] 16
getSexpType(1:10)
#> [1] 13
```
