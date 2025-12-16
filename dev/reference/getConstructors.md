# List the public constructors of a CLR Type

List the public constructors of a CLR Type

## Usage

``` r
getConstructors(type)
```

## Arguments

- type:

  .NET Type, or a (character) type name that can be successfully parsed

## Value

a list of constructor signatures

## Examples

``` r
testClassName <- "ClrFacade.TestObject"
getConstructors(testClassName)
#> [1] "Constructor: .ctor"                              
#> [2] "Constructor: .ctor, Double"                      
#> [3] "Constructor: .ctor, Double, Double"              
#> [4] "Constructor: .ctor, Int32"                       
#> [5] "Constructor: .ctor, Int32, Int32"                
#> [6] "Constructor: .ctor, Int32, Int32, Double, Double"
```
