# Gets the value of a static field or property of a class

Gets the value of a static field or property of a class

## Usage

``` r
getStatic(type, name)
```

## Arguments

- type:

  Type name, possibly namespace and assembly qualified type name, e.g.
  'My.Namespace.MyClass,MyAssemblyName'.

- name:

  the name of a field/property of the object

## Value

An object resulting from the call. May be a \`NetObject\` object, or a
native R object for common types. Can be NULL.

## Examples

``` r
testClassName <- getRSharpSetting("testObjectTypeName")
getStatic(testClassName, "StaticPropertyIntegerOne")
#> [1] 0
```
