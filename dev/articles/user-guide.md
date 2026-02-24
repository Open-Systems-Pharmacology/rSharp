# User guide

The [rSharp](https://github.com/Open-Systems-Pharmacology/rsharp/)
package is a low-level interoperability bridge between R and the .NET
runtime. It offers access to .NET libraries from R, allowing to create
.NET objects, access their fields, and call their methods.

[rSharp](https://github.com/Open-Systems-Pharmacology/rsharp/) uses R’s
native interface to C++ which then calls the .NET runtime. To make
working with .NET objects intuitive,
[rSharp](https://github.com/Open-Systems-Pharmacology/rsharp/) utilizes
the R6 object-oriented approach. This article will guide you through the
basic usage of the package, starting from loading an assembly to calling
methods and accessing fields.

## Data type conversion

### Basic data types

[rSharp](https://github.com/Open-Systems-Pharmacology/rsharp/) allows to
call public and static methods implemented in .NET assemblies and to
pass data to these methods. In return, calls will often result in some
data being returned.

Where there is an obvious and natural conversion between R and .NET data
types, R values can be easily passed as is, and the return value can be
interpreted as a native R type. Most of the basic modes in R
(`character`,`numeric`,`integer`, `logical`, and their vectors) have
equivalents in .NET.

### Object pointers and the `NetObject` class

It is common that .NET method returns another object that can not be
directly converted to a native R type. In such cases, the method returns
an external pointer to the .NET object. The `NetObject` class is used to
represent such pointers in R. The `NetObject` class is an R6 object that
wraps the external pointer and provides methods to interact with the
.NET object with semantics familiar for the object-oriented programming.
In most cases, the user would prefer to interact with these objects
through the `NetObject`. If, for any reason, the user needs to access
the raw pointer, it can be done by accessing the field `$pointer` of the
R6 object.

`NetObject` instances can be passed to .NET methods as arguments. If a
method expects an array of .NET objects, all objects within the R list
must be instances of `NetObject`. Mixed lists of native R types and
`NetObject` instances are not supported. Furthermore, the type of the
array will be interpreted as `Object[]`.

## Loading an assembly

To start working with a .NET assembly, you need to load it into the R
session. This is done using the
[`rSharp::loadAssembly`](http://www.open-systems-pharmacology.org/rSharp/dev/reference/loadAssembly.md)
function. In this example, we will use the library `rSharp.Examples.dll`
provided with this package.

``` r
library(rSharp)
assembly <- loadAssembly(system.file("extdata", "rSharp.Examples.dll", package = "rSharp"))
```

We can get the list of all loaded assemblies using the
`getLoadedAssemblies` function:

``` r
getLoadedAssemblies()
#>  [1] "System.Private.CoreLib"                    
#>  [2] "ClrFacade"                                 
#>  [3] "System.Runtime"                            
#>  [4] "System.Runtime.InteropServices"            
#>  [5] "System.Console"                            
#>  [6] "System.Linq"                               
#>  [7] "System.Collections"                        
#>  [8] "RDotNet"                                   
#>  [9] "netstandard"                               
#> [10] "System.Linq.Expressions"                   
#> [11] "DynamicInterop"                            
#> [12] "Microsoft.Win32.Primitives"                
#> [13] "System.Diagnostics.Process"                
#> [14] "System.ComponentModel.Primitives"          
#> [15] "System.Threading"                          
#> [16] "System.IO.Pipes"                           
#> [17] "System.Net.Primitives"                     
#> [18] "System.Net.Sockets"                        
#> [19] "System.Threading.ThreadPool"               
#> [20] "System.Threading.Thread"                   
#> [21] "System.Collections.Concurrent"             
#> [22] "System.Diagnostics.Tracing"                
#> [23] "System.Memory"                             
#> [24] "System.Runtime.Numerics"                   
#> [25] "rSharp.Examples"                           
#> [26] "Microsoft.CSharp"                          
#> [27] "System.Reflection.Emit.ILGeneration"       
#> [28] "System.Reflection.Emit.Lightweight"        
#> [29] "System.Reflection.Primitives"              
#> [30] "Anonymously Hosted DynamicMethods Assembly"
# Check if a specific assembly is loaded
isAssemblyLoaded("rSharp.Examples")
#> [1] TRUE
```

## Working with static members

Static members of a .NET class can be accessed without creating an
instance of the class.

The `rSharp.Examples` library implements a class `SampleStaticClass`
with different static members. To get an overview of the available
static members of a class, you can use the `getStaticMembers` function:

``` r
getStaticMembers("rSharp.Examples.SampleStaticClass")
#> $Methods
#> [1] "Add"               "GetAString"        "GetInstanceObject"
#> 
#> $Fields
#> [1] "StaticString"
#> 
#> $Properties
#> character(0)
```

To explore the methods, fields, and properties of a class separately,
you can use the `getStaticMethods`, `getStaticFields`, and
`getStaticProperties` functions, respectively.

To call static methods of a .NET class, you can use the
[`rSharp::callStatic`](http://www.open-systems-pharmacology.org/rSharp/dev/reference/callStatic.md)
function. If you are not sure which arguments are expected by a certain
method, you can use the `getStaticMemberSignature` function to get the
method’s signature:

``` r
# Get the signature of the GetAString method
getStaticMemberSignature("rSharp.Examples.SampleStaticClass", "GetAString")
#> [1] "Static, Method: String GetAString"
# Get the signature of the Add method
getStaticMemberSignature("rSharp.Examples.SampleStaticClass", "Add")
#> [1] "Static, Method: Int32 Add, Int32, Int32"
```

The method `GetAString` returns a string and does not have any
arguments, so we can call it using the `callStatic` function:

``` r
rSharp::callStatic("rSharp.Examples.SampleStaticClass", "GetAString")
#> [1] "A string from static class"
```

If the method has arguments, they can be passed as additional arguments
to the `callStatic` function, as in this case of calling the static
function `Add()` that requires two integers as arguments:

``` r
rSharp::callStatic("rSharp.Examples.SampleStaticClass", "Add", as.integer(1), as.integer(2))
#> [1] 3
```

Mind that we had to explicitly cast the arguments to integer, as all
numeric values in R are double by default.

We can also access static fields of a class using the `getStatic` and
`setStatic` functions:

``` r
# Get the value of the static field
getStatic("rSharp.Examples.SampleStaticClass", "StaticString")
#> [1] "A string from static class"
```

This static string is returned by the method `GetAString` we called
earlier. We can set the value of the static field and would expect it to
be returned by the `GetAString` method:

``` r
# Set the value of the static field
setStatic("rSharp.Examples.SampleStaticClass", "StaticString", "New value")
# Get the value of the static field
getStatic("rSharp.Examples.SampleStaticClass", "StaticString")
#> [1] "New value"
# Call the GetAString method
callStatic("rSharp.Examples.SampleStaticClass", "GetAString")
#> [1] "New value"
```

## Working with objects

So far, we were passing basic data types as arguments and receiving
basic data types as return values. However, in many cases, we would need
to work with .NET objects. For example, the method `GetInstanceObject`
returns an instance of the `SampleInstanceClass` class. `rSharp` wraps
such objects in the `NetObject` class:

``` r
# Call the SampleInstanceClass method
instance <- callStatic("rSharp.Examples.SampleStaticClass", "GetInstanceObject")

# Check the class of the returned object
class(instance)
#> [1] "NetObject" "R6"

# Get the type of the object
instance$type
#> [1] "rSharp.Examples.SampleInstanceClass"
```

The R6 class `NetObject` holds the pointer to the .NET object and
provides methods to interact with it. Thus, the constructor of
`NetObject` requires an external pointer to a .NET object. The pointer
can be created by calling the `newPointerFromName` function. Is the
constructor of the .NET class requires arguments, they can be passed as
additional arguments to the `newPointerFromName` function. We can
examine the constructors of a class with the `getConstructors` function:

``` r
getConstructors("rSharp.Examples.SampleInstanceClass")
#> [1] "Constructor: .ctor"                              
#> [2] "Constructor: .ctor, Double"                      
#> [3] "Constructor: .ctor, Double, Double"              
#> [4] "Constructor: .ctor, Int32"                       
#> [5] "Constructor: .ctor, Int32, Int32"                
#> [6] "Constructor: .ctor, Int32, Int32, Double, Double"
```

The `SampleInstanceClass` has six different constructor signature. We
can create a new pointer to an instance of the class by calling the
constructor with two double arguments and create a `NetObject` using the
pointer:

``` r
# Create a pointer to a .NET object
pointer <- newPointerFromName("rSharp.Examples.SampleInstanceClass", as.double(1), as.double(2))
# Wrap the pointer in a new NetObject
newInstance <- NetObject$new(pointer)
```

The more conventient way of creating a `NetObject` for a new object is
by calling the `newObjectFromName` function:

``` r
# Create a new instance of the SampleInstanceClass
newInstance2 <- newObjectFromName("rSharp.Examples.SampleInstanceClass", as.integer(1))
```

As with static classes, we can examine the methods, fields, and
properties of an object using the `getMethods`, `getFields`, and
`getProperties` methods called on the object, respectively.

``` r
# Get the methods of the object
newInstance$getMethods()
#> [1] "Equals"      "GetAString"  "GetHashCode" "GetType"     "ToString"
# Get the fields of the object
newInstance$getFields()
#> [1] "FieldDoubleOne"  "FieldDoubleTwo"  "FieldIntegerOne" "FieldIntegerTwo"
# Get the properties of the object
newInstance$getProperties()
#> character(0)
```

A non-static class can also have static members, which can be listed
using the `getStatic...` functions:

``` r
newInstance$getStaticFields()
#> [1] "StaticString"
```

Setting and getting non-static fields and properties of an object is
done using the `set` and `get` methods, respectively:

``` r
# Get the value of the static field:
newInstance$get("FieldDoubleOne")
#> [1] 1
# Change the value of the static field:
newInstance$set("FieldDoubleOne", 23)
# Get the value of the static field:
newInstance$get("FieldDoubleOne")
#> [1] 23
```

To get or set static fields, use the functions `getStatic` and
`setStatic`.

Finally, we can call the methods of the object using the `call` method:

``` r
# Call the Add method
newInstance$call("GetAString")
#> [1] "A string from instance class"
```
