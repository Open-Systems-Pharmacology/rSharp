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
#>  [1] "ArrayOfObjectsArgument"            "CallGC"                           
#>  [3] "CheckIsDailySequence"              "ComplexEquals"                    
#>  [5] "ComplexEquals"                     "ConvertTime"                      
#>  [7] "CreateArrayMemFootprint"           "CreateComplex"                    
#>  [9] "CreateComplex"                     "CreateDate"                       
#> [11] "CreateDateArray"                   "CreateDateArraySeconds"           
#> [13] "CreateDouble"                      "CreateEmptyArray"                 
#> [15] "CreateEmptyArrayBool"              "CreateEmptyArrayByte"             
#> [17] "CreateEmptyArrayDouble"            "CreateEmptyArrayFloat"            
#> [19] "CreateEmptyArrayInt"               "CreateEmptyArrayLong"             
#> [21] "CreateEmptyArrayString"            "CreateException"                  
#> [23] "CreateFloat"                       "CreateFloatArray"                 
#> [25] "CreateInnerExceptions"             "CreateInt"                        
#> [27] "CreateIntArray"                    "CreateJaggedDoubleArray"          
#> [29] "CreateJaggedFloatArray"            "CreateLong"                       
#> [31] "CreateMemTestObj"                  "CreateNumArray"                   
#> [33] "CreateNumArrayMissingVal"          "CreateObjectDictionary"           
#> [35] "CreateRectDoubleArray"             "CreateRectFloatArray"             
#> [37] "CreateString"                      "CreateStringArray"                
#> [39] "CreateStringDictionary"            "CreateStringDoubleArrayDictionary"
#> [41] "CreateTestArrayGenericInterface"   "CreateTestArrayGenericObjects"    
#> [43] "CreateTestArrayInterface"          "CreateTestDataFrame"              
#> [45] "CreateTestNumericVector"           "CreateTestObject"                 
#> [47] "CreateTestObjectGenericInstance"   "CreateTimeSpanArray"              
#> [49] "DateEquals"                        "DateEquals"                       
#> [51] "DateEquals"                        "DoubleEquals"                     
#> [53] "GetComplexDataCase"                "GetComplexDataTypeName"           
#> [55] "GetExceptionMessage"               "GetFalse"                         
#> [57] "GetMemTestObjCounter"              "GetNaN"                           
#> [59] "GetNaNArray"                       "GetNull"                          
#> [61] "GetNullArray"                      "GetNumComplexDataCases"           
#> [63] "GetPrivateMemoryMegabytes"         "GetRFunctionInvoke"               
#> [65] "GetTestEnum"                       "GetTrue"                          
#> [67] "GetWorkingSetMemoryMegabytes"      "IntEquals"                        
#> [69] "IsNA"                              "IsNaN"                            
#> [71] "IsNaNInArray"                      "IsNull"                           
#> [73] "IsNullInArray"                     "IsTrue"                           
#> [75] "NumArrayEquals"                    "NumArrayMissingValuesEquals"      
#> [77] "NumericMatrixEquals"               "SingleObjectArgument"             
#> [79] "SinkDateTime"                      "SinkLargeObject"                  
#> [81] "StringArrayEquals"                 "StringArrayMissingValuesEquals"   
#> [83] "StringEquals"                      "ThrowException"                   
#> [85] "TimeSpanEquals"                    "TimeZoneToLocalDate"              
#> [87] "UtcDateEquals"                     "UtcDateEquals"                    
#> [89] "UtcDateForTimeZone"                "UtcDateForTimeZone"               
#> 
#> $Fields
#> character(0)
#> 
#> $Properties
#> character(0)
#> 
```
