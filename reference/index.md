# Package index

## Loading and managing assemblies

- [`loadAssembly()`](http://www.open-systems-pharmacology.org/rSharp/reference/loadAssembly.md)
  : Loads a .NET assembly.
- [`getLoadedAssemblies()`](http://www.open-systems-pharmacology.org/rSharp/reference/getLoadedAssemblies.md)
  : List the names of loaded assemblies
- [`getTypesInAssembly()`](http://www.open-systems-pharmacology.org/rSharp/reference/getTypesInAssembly.md)
  : Get a list of .NET type names exported by an assembly
- [`isAssemblyLoaded()`](http://www.open-systems-pharmacology.org/rSharp/reference/isAssemblyLoaded.md)
  : Is the assembly loaded?

## Creating objects

- [`NetObject`](http://www.open-systems-pharmacology.org/rSharp/reference/NetObject.md)
  : NetObject
- [`newObjectFromName()`](http://www.open-systems-pharmacology.org/rSharp/reference/newObjectFromName.md)
  : Create a new NetObject R6 object given the type name.
- [`newPointerFromName()`](http://www.open-systems-pharmacology.org/rSharp/reference/newPointerFromName.md)
  : Create a new external pointer to a .NET object given the type name.
- [`getConstructors()`](http://www.open-systems-pharmacology.org/rSharp/reference/getConstructors.md)
  : List the public constructors of a CLR Type
- [`castToRObject()`](http://www.open-systems-pharmacology.org/rSharp/reference/castToRObject.md)
  : Create if possible an object of the R6 class \`NetObject\`

## Working with static members

- [`callStatic()`](http://www.open-systems-pharmacology.org/rSharp/reference/callStatic.md)
  : Call a static method on a .NET type
- [`getStatic()`](http://www.open-systems-pharmacology.org/rSharp/reference/getStatic.md)
  : Gets the value of a static field or property of a class
- [`getStaticFields()`](http://www.open-systems-pharmacology.org/rSharp/reference/getStaticFields.md)
  : Gets the static fields for a type
- [`getStaticMemberSignature()`](http://www.open-systems-pharmacology.org/rSharp/reference/getStaticMemberSignature.md)
  : Gets the signature of a static member of a type
- [`getStaticMembers()`](http://www.open-systems-pharmacology.org/rSharp/reference/getStaticMembers.md)
  : Gets the static members for a type
- [`getStaticMethods()`](http://www.open-systems-pharmacology.org/rSharp/reference/getStaticMethods.md)
  : Gets the static methods for a type
- [`getStaticProperties()`](http://www.open-systems-pharmacology.org/rSharp/reference/getStaticProperties.md)
  : Gets the static properties for a type
- [`setStatic()`](http://www.open-systems-pharmacology.org/rSharp/reference/setStatic.md)
  : Sets the value of a field or property of an object or class

## Working with enums

- [`getEnumNames()`](http://www.open-systems-pharmacology.org/rSharp/reference/getEnumNames.md)
  : Gets the names of a .NET Enum value type

## Diagnostics

- [`dotnetAvailable()`](http://www.open-systems-pharmacology.org/rSharp/reference/dotnetAvailable.md)
  : Check whether the .NET runtime is available
- [`toStringNET()`](http://www.open-systems-pharmacology.org/rSharp/reference/toStringNET.md)
  : Calls the ToString method of an object
- [`getSexpType()`](http://www.open-systems-pharmacology.org/rSharp/reference/getSexpType.md)
  : Get the type code for a SEXP
- [`getType()`](http://www.open-systems-pharmacology.org/rSharp/reference/getType.md)
  : Gets the pointer to the \`System.RuntimeType\` of a \`NetObject\`
  object or a .NET type name.
- [`rToDotNetType()`](http://www.open-systems-pharmacology.org/rSharp/reference/rToDotNetType.md)
  : Gets the type of a .NET object resulting from converting an R object
- [`inspectArgs()`](http://www.open-systems-pharmacology.org/rSharp/reference/inspectArgs.md)
  : Peek into the structure of R objects 'as seen from C code'
- [`printTraceback()`](http://www.open-systems-pharmacology.org/rSharp/reference/printTraceback.md)
  : Prints the last .NET exception

## Miscelaneous

- [`setConvertAdvancedTypes()`](http://www.open-systems-pharmacology.org/rSharp/reference/setConvertAdvancedTypes.md)
  : Turn on/off the conversion of advanced data types with R.NET
- [`getRSharpSetting()`](http://www.open-systems-pharmacology.org/rSharp/reference/getRSharpSetting.md)
  : getRSharpSetting
- [`rSharpSettingNames`](http://www.open-systems-pharmacology.org/rSharp/reference/rSharpSettingNames.md)
  : Names of the settings stored in rSharpEnv Can be used with
  \`getRSharpSetting()\`

## Internal functions

- [`.clrTypeNameExtPtr()`](http://www.open-systems-pharmacology.org/rSharp/reference/dot-clrTypeNameExtPtr.md)
  : Gets the type name of an object
- [`.getCurrentConvertedObject()`](http://www.open-systems-pharmacology.org/rSharp/reference/dot-getCurrentConvertedObject.md)
  : System function to get a direct access to an object
- [`.mkClrObjRef()`](http://www.open-systems-pharmacology.org/rSharp/reference/dot-mkClrObjRef.md)
  : Create if possible an S4 \`cobjRef\` object.
