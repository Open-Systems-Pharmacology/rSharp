# Call a static method on a .NET type

Call a static method on a .NET type

## Usage

``` r
callStatic(typename, methodName, ...)
```

## Arguments

- typename:

  type name, possibly namespace and assembly qualified type name, e.g.
  'My.Namespace.MyClass,MyAssemblyName'.

- methodName:

  the name of a static method of the type

- ...:

  additional method arguments passed to .External (e.g., arguments to
  the method)

## Value

an object resulting from the call. May be a \`NetObject\` object, or a
native R object for common types. Can be NULL.

## Examples

``` r
cTypename <- getRSharpSetting("testCasesTypeName")
callStatic(cTypename, "IsTrue", TRUE)
#> [1] TRUE
```
