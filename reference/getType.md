# Gets the pointer to the \`System.RuntimeType\` of a \`NetObject\` object or a .NET type name.

Returns a \`NetObject\` object with external pointer to the object of
type \`System.RuntimeType\` that represents the type of the .NET object.
To get a string representation of the type, call \`toStringNET\` on the
returned object.

## Usage

``` r
getType(objOrTypename)
```

## Arguments

- objOrTypename:

  An object of class \`NEtObject\` or a character vector of length one.
  It can be the full file name of the assembly to load, or a fully
  qualified assembly name, or as a last resort a partial name.

## Value

A \`NetObject\` to the pointer of \`System.RuntimeType\` of
\`objOrTypename\`.

## Examples

``` r
testClassName <- "ClrFacade.TestObject"
type <- getType(testClassName)
toStringNET(type)
#> [1] "ClrFacade.TestObject"

testObj <- newObjectFromName(testClassName)
type <- getType(testObj)
toStringNET(type)
#> [1] "ClrFacade.TestObject"
```
