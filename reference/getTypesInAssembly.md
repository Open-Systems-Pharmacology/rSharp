# Get a list of .NET type names exported by an assembly

Get a list of .NET type names exported by an assembly

## Usage

``` r
getTypesInAssembly(assemblyName)
```

## Arguments

- assemblyName:

  the name of the assembly

## Value

The names of the types exported by the assembly

## Examples

``` r
getTypesInAssembly("ClrFacade")
#>  [1] "ClrFacade.ClrFacade"                                     
#>  [2] "ClrFacade.ClrObjectToSexpDelegate"                       
#>  [3] "ClrFacade.IUnmanagedDll"                                 
#>  [4] "ClrFacade.DataConversionHelper"                          
#>  [5] "ClrFacade.SymbolicExpressionWrapper"                     
#>  [6] "ClrFacade.DataConverterExtensions"                       
#>  [7] "ClrFacade.HelloWorld"                                    
#>  [8] "ClrFacade.IDataConverter"                                
#>  [9] "ClrFacade.InternalReflectionHelper"                      
#> [10] "ClrFacade.InternalRSharpFacade"                          
#> [11] "ClrFacade.PerformanceProfiling"                          
#> [12] "ClrFacade.RdotnetDataConverterTests"                     
#> [13] "ClrFacade.RSharpValueType"                               
#> [14] "ClrFacade.RSharpGenericValueExtensions"                  
#> [15] "ClrFacade.RSharpGenericValue"                            
#> [16] "ClrFacade.RSharpUnmanagedDll"                            
#> [17] "ClrFacade.TestArrayMemoryHandling"                       
#> [18] "ClrFacade.TestCases"                                     
#> [19] "ClrFacade.TestObjectWithEnum"                            
#> [20] "ClrFacade.ITestInterface"                                
#> [21] "ClrFacade.ITestGenericInterface`1"                       
#> [22] "ClrFacade.TestEnum"                                      
#> [23] "ClrFacade.TestFlagEnum"                                  
#> [24] "ClrFacade.TestObjectGeneric`1"                           
#> [25] "ClrFacade.TestObject"                                    
#> [26] "ClrFacade.TestMethodBinding"                             
#> [27] "ClrFacade.ITestMethodBindings"                           
#> [28] "ClrFacade.Tests.TestUtilities"                           
#> [29] "ClrFacade.Tests.RefClasses.BaseAbstractClassOne"         
#> [30] "ClrFacade.Tests.RefClasses.InterfaceOne"                 
#> [31] "ClrFacade.Tests.RefClasses.InterfaceBaseTwo"             
#> [32] "ClrFacade.Tests.RefClasses.InterfaceBaseOne"             
#> [33] "ClrFacade.Tests.RefClasses.InterfaceTwo"                 
#> [34] "ClrFacade.Tests.RefClasses.LevelOneClass"                
#> [35] "ClrFacade.Tests.RefClasses.LevelThreeClass"              
#> [36] "ClrFacade.Tests.RefClasses.LevelTwoClass"                
#> [37] "ClrFacade.ClrFacade+CallInstanceMethodDelegate"          
#> [38] "ClrFacade.ClrFacade+CreateSexpWrapperDelegate"           
#> [39] "ClrFacade.ClrFacade+CallStaticMethodDelegate"            
#> [40] "ClrFacade.ClrFacade+CurrentObjectDelegate"               
#> [41] "ClrFacade.ClrFacade+CreateInstanceDelegate"              
#> [42] "ClrFacade.ClrFacade+GetObjectTypeNameDelegate"           
#> [43] "ClrFacade.ClrFacade+LoadFromDelegate"                    
#> [44] "ClrFacade.ClrFacade+FreeObjectDelegate"                  
#> [45] "ClrFacade.RdotnetDataConverterTests+MemTestObjectRDotnet"
```
