# Gets the type name of an object

Gets the type name of an object, given the SEXP external pointer to this
.NET object.

## Usage

``` r
.clrTypeNameExtPtr(extPtr)
```

## Arguments

- extPtr:

  external pointer to a .NET object (not a \`cobjRef\` S4 or a
  \`NetObject\` object)

## Value

a character string, the type name

## Examples

``` r
if (FALSE) { # \dontrun{
testClassName <- getRSharpSetting("testObjectTypeName")
testObj <- newObjectFromName(testClassName)
.clrTypeNameExtPtr(testObj$pointer)
} # }
```
