# Sets the value of a field or property of an object or class

Sets the value of a field or property of an object or class

## Usage

``` r
setStatic(type, name, value, asInteger = FALSE)
```

## Arguments

- type:

  Type name, possibly namespace and assembly qualified type name, e.g.
  'My.Namespace.MyClass,MyAssemblyName'.

- name:

  the name of a field/property of the object

- value:

  The value to set the field with

- asInteger:

  Boolean whether to convert the value to an integer. Used for cases
  where .NET signature requires an integer. Ignored if \`value\` is not
  numeric.

## Examples

``` r
testClassName <- getRSharpSetting("testObjectTypeName")
setStatic(testClassName, "StaticPropertyIntegerOne", as.integer(42))
```
