# Gets the static members for a type

Gets the static members for a type

## Usage

``` r
getStaticMembers(objOrType)
```

## Arguments

- objOrType:

  a .NET object, or type name, possibly namespace and assembly qualified
  type name, e.g. 'My.Namespace.MyClass,MyAssemblyName'.

## Examples

``` r
cTypename <- getRSharpSetting("testCasesTypeName")
getStaticMembers(cTypename)
#> $Methods
#>  [1] "CallGC"                            "CheckIsDailySequence"             
#>  [3] "ComplexEquals"                     "ComplexEquals"                    
#>  [5] "ConvertTime"                       "CreateArrayMemFootprint"          
#>  [7] "CreateComplex"                     "CreateComplex"                    
#>  [9] "CreateDate"                        "CreateDateArray"                  
#> [11] "CreateDateArraySeconds"            "CreateDouble"                     
#> [13] "CreateEmptyArray"                  "CreateEmptyArrayBool"             
#> [15] "CreateEmptyArrayByte"              "CreateEmptyArrayDouble"           
#> [17] "CreateEmptyArrayFloat"             "CreateEmptyArrayInt"              
#> [19] "CreateEmptyArrayLong"              "CreateEmptyArrayString"           
#> [21] "CreateException"                   "CreateFloat"                      
#> [23] "CreateFloatArray"                  "CreateInnerExceptions"            
#> [25] "CreateInt"                         "CreateIntArray"                   
#> [27] "CreateJaggedDoubleArray"           "CreateJaggedFloatArray"           
#> [29] "CreateLong"                        "CreateMemTestObj"                 
#> [31] "CreateNumArray"                    "CreateNumArrayMissingVal"         
#> [33] "CreateObjectDictionary"            "CreateRectDoubleArray"            
#> [35] "CreateRectFloatArray"              "CreateString"                     
#> [37] "CreateStringArray"                 "CreateStringDictionary"           
#> [39] "CreateStringDoubleArrayDictionary" "CreateTestArrayGenericInterface"  
#> [41] "CreateTestArrayGenericObjects"     "CreateTestArrayInterface"         
#> [43] "CreateTestDataFrame"               "CreateTestNumericVector"          
#> [45] "CreateTestObject"                  "CreateTestObjectGenericInstance"  
#> [47] "CreateTimeSpanArray"               "DateEquals"                       
#> [49] "DateEquals"                        "DateEquals"                       
#> [51] "DoubleEquals"                      "GetComplexDataCase"               
#> [53] "GetComplexDataTypeName"            "GetExceptionMessage"              
#> [55] "GetFalse"                          "GetMemTestObjCounter"             
#> [57] "GetNaN"                            "GetNaNArray"                      
#> [59] "GetNull"                           "GetNullArray"                     
#> [61] "GetNumComplexDataCases"            "GetPrivateMemoryMegabytes"        
#> [63] "GetRFunctionInvoke"                "GetTestEnum"                      
#> [65] "GetTrue"                           "GetWorkingSetMemoryMegabytes"     
#> [67] "IntEquals"                         "IsNA"                             
#> [69] "IsNaN"                             "IsNaNInArray"                     
#> [71] "IsNull"                            "IsNullInArray"                    
#> [73] "IsTrue"                            "NumArrayEquals"                   
#> [75] "NumArrayMissingValuesEquals"       "NumericMatrixEquals"              
#> [77] "SinkDateTime"                      "SinkLargeObject"                  
#> [79] "StringArrayEquals"                 "StringArrayMissingValuesEquals"   
#> [81] "StringEquals"                      "ThrowException"                   
#> [83] "TimeSpanEquals"                    "TimeZoneToLocalDate"              
#> [85] "UtcDateEquals"                     "UtcDateEquals"                    
#> [87] "UtcDateForTimeZone"                "UtcDateForTimeZone"               
#> 
#> $Fields
#> character(0)
#> 
#> $Properties
#> character(0)
#> 
```
