# Gets the names of a .NET Enum value type

Gets the names of a .NET Enum value type

## Usage

``` r
getEnumNames(enumType)
```

## Arguments

- enumType:

  a .NET object, System.Type or type name, possibly namespace and
  assembly qualified type name, e.g.
  'My.Namespace.MyClass,MyAssemblyName'.

## Value

a character vector of the names for the enum

## Examples

``` r
enumName <- "ClrFacade.TestEnum"
getEnumNames(enumName)
#> [1] "A" "B" "C"
# Get enum names from object
enumObj <- newObjectFromName(enumName)
getEnumNames(enumObj)
#> [1] "A" "B" "C"
```
