# NetObject

Base wrapper class for the pointers to .NET objects. Offers basic
methods to interact with the .NET objects.

## Active bindings

- `type`:

  String representation of the type of the .NET object. Read-only

- `pointer`:

  The external pointer to the .NET object. Read-only

## Methods

### Public methods

- [`NetObject$new()`](#method-NetObject-new)

- [`NetObject$getFields()`](#method-NetObject-getFields)

- [`NetObject$getStaticFields()`](#method-NetObject-getStaticFields)

- [`NetObject$getProperties()`](#method-NetObject-getProperties)

- [`NetObject$getStaticProperties()`](#method-NetObject-getStaticProperties)

- [`NetObject$getMethods()`](#method-NetObject-getMethods)

- [`NetObject$getStaticMethods()`](#method-NetObject-getStaticMethods)

- [`NetObject$getMemberSignature()`](#method-NetObject-getMemberSignature)

- [`NetObject$call()`](#method-NetObject-call)

- [`NetObject$get()`](#method-NetObject-get)

- [`NetObject$set()`](#method-NetObject-set)

- [`NetObject$.printLine()`](#method-NetObject-.printLine)

- [`NetObject$.printClass()`](#method-NetObject-.printClass)

- [`NetObject$print()`](#method-NetObject-print)

------------------------------------------------------------------------

### Method `new()`

Initializes the object.

#### Usage

    NetObject$new(pointer)

#### Arguments

- `pointer`:

  The external pointer to the .NET object

#### Returns

The initialized object

#### Examples

    testClassName <- "ClrFacade.Tests.RefClasses.LevelOneClass"
    o <- .External("r_create_clr_object", testClassName, PACKAGE = getRSharpSetting("nativePkgName"))
    x <- newObjectFromName(testClassName)
    print(x)

------------------------------------------------------------------------

### Method `getFields()`

List the fields of the object

#### Usage

    NetObject$getFields(contains = "")

#### Arguments

- `contains`:

  a string that the field names returned must contain

#### Returns

a list of names of the fields of the object

#### Examples

    testClassName <- getRSharpSetting("testObjectTypeName")
    testObj <- newObjectFromName(testClassName)
    testObj$getFields()
    testObj$getFields("ieldInt")

------------------------------------------------------------------------

### Method [`getStaticFields()`](http://www.open-systems-pharmacology.org/rSharp/dev/reference/getStaticFields.md)

List the static fields of the object

#### Usage

    NetObject$getStaticFields(contains = "")

#### Arguments

- `contains`:

  a string that the field names returned must contain

#### Returns

a list of names of the static fields of the object

#### Examples

    testClassName <- getRSharpSetting("testObjectTypeName")
    testObj <- newObjectFromName(testClassName)
    testObj$getStaticFields()
    testObj$getStaticFields("ieldInt")

------------------------------------------------------------------------

### Method `getProperties()`

List the properties of the object

#### Usage

    NetObject$getProperties(contains = "")

#### Arguments

- `contains`:

  a string that the property names returned must contain

#### Returns

a list of names of the properties of the object

#### Examples

    testClassName <- getRSharpSetting("testObjectTypeName")
    testObj <- newObjectFromName(testClassName)
    testObj$getProperties()
    testObj$getProperties("One")

------------------------------------------------------------------------

### Method [`getStaticProperties()`](http://www.open-systems-pharmacology.org/rSharp/dev/reference/getStaticProperties.md)

List the static properties of the object

#### Usage

    NetObject$getStaticProperties(contains = "")

#### Arguments

- `contains`:

  a string that the property names returned must contain

#### Returns

a list of names of the static properties of the object

#### Examples

    testClassName <- getRSharpSetting("testObjectTypeName")
    testObj <- newObjectFromName(testClassName)
    testObj$getStaticProperties()
    testObj$getStaticProperties("One")

------------------------------------------------------------------------

### Method `getMethods()`

List the methods the object

#### Usage

    NetObject$getMethods(contains = "")

#### Arguments

- `contains`:

  a string that the methods names returned must contain

#### Returns

a list of names of the methods of the object

#### Examples

    testClassName <- getRSharpSetting("testObjectTypeName")
    testObj <- newObjectFromName(testClassName)
    testObj$getMethods()
    testObj$getMethods("Get")

------------------------------------------------------------------------

### Method [`getStaticMethods()`](http://www.open-systems-pharmacology.org/rSharp/dev/reference/getStaticMethods.md)

List the static methods the object

#### Usage

    NetObject$getStaticMethods(contains = "")

#### Arguments

- `contains`:

  a string that the methods names returned must contain

#### Returns

a list of names of the static methods of the object

#### Examples

    testClassName <- getRSharpSetting("testObjectTypeName")
    testObj <- newObjectFromName(testClassName)
    testObj$getStaticMethods()
    testObj$getStaticMethods("Get")

------------------------------------------------------------------------

### Method `getMemberSignature()`

Gets a string representation of the signature of a member (i.e. field,
property, method). Mostly used to interactively search for what
arguments to pass to a method.

#### Usage

    NetObject$getMemberSignature(memberName)

#### Arguments

- `memberName`:

  The exact name of the member (i.e. field, property, method) to search
  for

#### Returns

a character vector with summary information on the method/member
signatures

#### Examples

    testClassName <- getRSharpSetting("testObjectTypeName")
    testObj <- newObjectFromName(testClassName)
    testObj$getMemberSignature("set_PropertyIntegerOne")
    testObj$getMemberSignature("FieldIntegerOne")
    testObj$getMemberSignature("PropertyIntegerTwo")

------------------------------------------------------------------------

### Method [`call()`](https://rdrr.io/r/base/call.html)

Call a method of the object

#### Usage

    NetObject$call(methodName, ...)

#### Arguments

- `methodName`:

  the name of a method of the object

- `...`:

  additional method arguments

#### Returns

An object resulting from the call. May be a \`NetObject\` object, or a
native R object for common types. Can be NULL.

#### Examples

    testClassName <- getRSharpSetting("testObjectTypeName")
    testObj <- newObjectFromName(testClassName)
    testObj$call("GetFieldIntegerOne")

------------------------------------------------------------------------

### Method [`get()`](https://rdrr.io/r/base/get.html)

Gets the value of a field or property of the object

#### Usage

    NetObject$get(name)

#### Arguments

- `name`:

  the name of a field/property of the object

#### Returns

An object resulting from the call. May be a \`NetObject\` object, or a
native R object for common types. Can be NULL.

#### Examples

    testClassName <- getRSharpSetting("testObjectTypeName")
    testObj <- newObjectFromName(testClassName)
    testObj$get("FieldIntegerOne")

------------------------------------------------------------------------

### Method `set()`

Sets the value of a field or property of the object.

#### Usage

    NetObject$set(name, value, asInteger = FALSE)

#### Arguments

- `name`:

  the name of a field/property of the object

- `value`:

  the value to set the field with

- `asInteger`:

  Boolean whether to convert the value to an integer. Used for cases
  where .NET signature requires an integer. Ignored if \`value\` is not
  numeric.

#### Examples

    testClassName <- getRSharpSetting("testObjectTypeName")
    testObj <- newObjectFromName(testClassName)
    testObj$set("FieldIntegerOne", as.integer(42))

------------------------------------------------------------------------

### Method `.printLine()`

DEPRECATED: Internal method for printing a line

#### Usage

    NetObject$.printLine(entry, value = NULL, addTab = TRUE)

#### Arguments

- `entry`:

  The entry text

- `value`:

  The value to print

- `addTab`:

  Whether to add a tab before the entry

------------------------------------------------------------------------

### Method `.printClass()`

DEPRECATED: Internal method for printing class name

#### Usage

    NetObject$.printClass()

------------------------------------------------------------------------

### Method [`print()`](https://rdrr.io/r/base/print.html)

Prints a summary of the object.

#### Usage

    NetObject$print()

## Examples

``` r
## ------------------------------------------------
## Method `NetObject$new`
## ------------------------------------------------

testClassName <- "ClrFacade.Tests.RefClasses.LevelOneClass"
o <- .External("r_create_clr_object", testClassName, PACKAGE = getRSharpSetting("nativePkgName"))
x <- newObjectFromName(testClassName)
print(x)
#> 
#> ── <NetObject> ──
#> 
#> Type: ClrFacade.Tests.RefClasses.LevelOneClass
#> 
#> ── Available Methods 
#>   • `AbstractMethod()`
#>   • `AbstractMethod()`
#>   • `Equals()`
#>   • `get_SomeInt()`
#>   • `GetHashCode()`
#>   • `GetType()`
#>   • `ToString()`
#>   • `VirtualMethod()`
#> 
#> ── Available Properties 
#>   • SomeInt

## ------------------------------------------------
## Method `NetObject$getFields`
## ------------------------------------------------

testClassName <- getRSharpSetting("testObjectTypeName")
testObj <- newObjectFromName(testClassName)
testObj$getFields()
#> [1] "FieldDoubleOne"  "FieldDoubleTwo"  "FieldIntegerOne" "FieldIntegerTwo"
#> [5] "PublicInt"      
testObj$getFields("ieldInt")
#> [1] "FieldIntegerOne" "FieldIntegerTwo"

## ------------------------------------------------
## Method `NetObject$getStaticFields`
## ------------------------------------------------

testClassName <- getRSharpSetting("testObjectTypeName")
testObj <- newObjectFromName(testClassName)
testObj$getStaticFields()
#> [1] "StaticFieldIntegerOne" "StaticFieldIntegerTwo" "StaticPublicInt"      
testObj$getStaticFields("ieldInt")
#> [1] "StaticFieldIntegerOne" "StaticFieldIntegerTwo"

## ------------------------------------------------
## Method `NetObject$getProperties`
## ------------------------------------------------

testClassName <- getRSharpSetting("testObjectTypeName")
testObj <- newObjectFromName(testClassName)
testObj$getProperties()
#> [1] "PropertyIntegerOne" "PropertyIntegerTwo"
testObj$getProperties("One")
#> [1] "PropertyIntegerOne"

## ------------------------------------------------
## Method `NetObject$getStaticProperties`
## ------------------------------------------------

testClassName <- getRSharpSetting("testObjectTypeName")
testObj <- newObjectFromName(testClassName)
testObj$getStaticProperties()
#> [1] "StaticPropertyIntegerOne" "StaticPropertyIntegerTwo"
testObj$getStaticProperties("One")
#> [1] "StaticPropertyIntegerOne"

## ------------------------------------------------
## Method `NetObject$getMethods`
## ------------------------------------------------

testClassName <- getRSharpSetting("testObjectTypeName")
testObj <- newObjectFromName(testClassName)
testObj$getMethods()
#>  [1] "Equals"                  "get_PropertyIntegerOne" 
#>  [3] "get_PropertyIntegerTwo"  "GetFieldIntegerOne"     
#>  [5] "GetFieldIntegerTwo"      "GetHashCode"            
#>  [7] "GetMethodWithParameters" "GetPublicInt"           
#>  [9] "GetType"                 "set_PropertyIntegerOne" 
#> [11] "set_PropertyIntegerTwo"  "TestDefaultValues"      
#> [13] "TestParams"              "ToString"               
testObj$getMethods("Get")
#> [1] "GetFieldIntegerOne"      "GetFieldIntegerTwo"     
#> [3] "GetHashCode"             "GetMethodWithParameters"
#> [5] "GetPublicInt"            "GetType"                

## ------------------------------------------------
## Method `NetObject$getStaticMethods`
## ------------------------------------------------

testClassName <- getRSharpSetting("testObjectTypeName")
testObj <- newObjectFromName(testClassName)
testObj$getStaticMethods()
#> [1] "get_StaticPropertyIntegerOne"  "get_StaticPropertyIntegerTwo" 
#> [3] "set_StaticPropertyIntegerOne"  "set_StaticPropertyIntegerTwo" 
#> [5] "StaticGetFieldIntegerOne"      "StaticGetFieldIntegerTwo"     
#> [7] "StaticGetMethodWithParameters" "StaticGetPublicInt"           
testObj$getStaticMethods("Get")
#> [1] "StaticGetFieldIntegerOne"      "StaticGetFieldIntegerTwo"     
#> [3] "StaticGetMethodWithParameters" "StaticGetPublicInt"           

## ------------------------------------------------
## Method `NetObject$getMemberSignature`
## ------------------------------------------------

testClassName <- getRSharpSetting("testObjectTypeName")
testObj <- newObjectFromName(testClassName)
testObj$getMemberSignature("set_PropertyIntegerOne")
#> [1] "Method: Void set_PropertyIntegerOne, Int32"
testObj$getMemberSignature("FieldIntegerOne")
#> [1] "Field FieldIntegerOne, Int32"
testObj$getMemberSignature("PropertyIntegerTwo")
#> [1] "Property PropertyIntegerTwo, Int32, can write: True"

## ------------------------------------------------
## Method `NetObject$call`
## ------------------------------------------------

testClassName <- getRSharpSetting("testObjectTypeName")
testObj <- newObjectFromName(testClassName)
testObj$call("GetFieldIntegerOne")
#> [1] 0

## ------------------------------------------------
## Method `NetObject$get`
## ------------------------------------------------

testClassName <- getRSharpSetting("testObjectTypeName")
testObj <- newObjectFromName(testClassName)
testObj$get("FieldIntegerOne")
#> [1] 0

## ------------------------------------------------
## Method `NetObject$set`
## ------------------------------------------------

testClassName <- getRSharpSetting("testObjectTypeName")
testObj <- newObjectFromName(testClassName)
testObj$set("FieldIntegerOne", as.integer(42))
```
