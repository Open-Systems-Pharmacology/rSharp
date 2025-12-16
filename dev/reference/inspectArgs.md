# Peek into the structure of R objects 'as seen from C code'

Inspect one or more R object to get information on its representation in
the engine. This function is mostly useful for R/rSharp developers. It
is derived from the 'showArgs' example in the R extension manual

## Usage

``` r
inspectArgs(...)
```

## Arguments

- ...:

  one or more R objects

## Value

NULL. Information is printed, not returned.

## Examples

``` r
inspectArgs(1, "a", 1:10)
#> [1] '<unnamed>' R type double, SEXPTYPE=14
#> [1] '<unnamed>' length 1
#> [1] names of length 0
#> [2] '<unnamed>' R type character, SEXPTYPE=16
#> [2] '<unnamed>' length 1
#> [2] names of length 0
#> [3] '<unnamed>' R type integer, SEXPTYPE=13
#> [3] '<unnamed>' length 10
#> [3] names of length 0
```
