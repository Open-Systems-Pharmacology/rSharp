# Turn on/off the conversion of advanced data types with R.NET

Turn on/off the conversion of advanced data types with R.NET. This will
turn off the conversion of classes such as dictionaries into R lists, as
these are not bidirectional and you may want to see and manipulate
external pointers to dictionaries in some circumstances.

## Usage

``` r
setConvertAdvancedTypes(enable = TRUE)
```

## Arguments

- enable:

  if true enable, otherwise disable

## Examples

``` r
library(rSharp)
cTypename <- getRSharpSetting("testCasesTypeName")
callStatic(cTypename, "CreateStringDictionary")
#> $a
#> [1] "A"
#> 
#> $b
#> [1] "B"
#> 
setConvertAdvancedTypes(FALSE)
callStatic(cTypename, "CreateStringDictionary")
#> 
#> ── <NetObject> ──
#> 
#> Type: System.Collections.Generic.Dictionary`2[[System.String,
#> System.Private.CoreLib, Version=10.0.0.0, Culture=neutral,
#> PublicKeyToken=7cec85d7bea7798e],[System.String, System.Private.CoreLib,
#> Version=10.0.0.0, Culture=neutral, PublicKeyToken=7cec85d7bea7798e]]
#> 
#> ── Available Methods 
#>   • `Add()`
#>   • `Clear()`
#>   • `ContainsKey()`
#>   • `ContainsValue()`
#>   • `EnsureCapacity()`
#>   • `Equals()`
#>   • `get_Capacity()`
#>   • `get_Comparer()`
#>   • `get_Count()`
#>   • `get_Item()`
#>   • `get_Keys()`
#>   • `get_Values()`
#>   • `GetAlternateLookup()`
#>   • `GetEnumerator()`
#>   • `GetHashCode()`
#>   • `GetObjectData()`
#>   • `GetType()`
#>   • `OnDeserialization()`
#>   • `Remove()`
#>   • `Remove()`
#>   • `set_Item()`
#>   • `ToString()`
#>   • `TrimExcess()`
#>   • `TrimExcess()`
#>   • `TryAdd()`
#>   • `TryGetAlternateLookup()`
#>   • `TryGetValue()`
#> 
#> ── Available Properties 
#>   • Capacity
#>   • Comparer
#>   • Count
#>   • Item
#>   • Keys
#>   • Values
```
