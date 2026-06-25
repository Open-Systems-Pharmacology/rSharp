# Create a new NetObject R6 object given the type name.

Create a new NetObject R6 object given the type name.

## Usage

``` r
newObjectFromName(typename, ..., R6objectClass = NetObject)
```

## Arguments

- typename:

  type name, possibly namespace and assembly qualified type name, e.g.
  'My.Namespace.MyClass,MyAssemblyName'.

- ...:

  additional method arguments passed to the object constructor via the
  call to .External

- R6objectClass:

  the R6 class of the object to be created, defaults to \`NetObject\`.
  Can be used to create custom R6 classes that inherit from
  \`NetObject\`.

## Value

a \`NetObject\` R6 object

## Examples

``` r
testClassName <- getRSharpSetting("testObjectTypeName")
testObj <- newObjectFromName(testClassName)
# object with a constructor that has parameters
testObj <- newObjectFromName(testClassName, as.integer(123))
```
