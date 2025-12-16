# Create a new external pointer to a .NET object given the type name.

Create a new external pointer to a .NET object given the type name.

## Usage

``` r
newPointerFromName(typename, ...)
```

## Arguments

- typename:

  type name, possibly namespace and assembly qualified type name, e.g.
  'My.Namespace.MyClass,MyAssemblyName'.

- ...:

  additional method arguments passed to the object constructor via the
  call to .External

## Value

an external pointer to a .NET object

## Examples

``` r
testClassName <- getRSharpSetting("testObjectTypeName")
testPtr <- newPointerFromName(testClassName)
# Now we can create a NetObject from the pointer
testObj <- NetObject$new(testPtr)
```
