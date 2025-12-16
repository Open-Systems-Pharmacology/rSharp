# List the names of loaded assemblies

List the names of loaded assemblies

## Usage

``` r
getLoadedAssemblies(fullname = FALSE, filenames = FALSE)
```

## Arguments

- fullname:

  should the full name of the assemblies be returned. \`FALSE\` by
  default.

- filenames:

  if TRUE, return a data frame where the second column is the URI
  (usually file path) of the loaded assembly. \`FALSE\` by default.

## Value

the names of loaded assemblies

## Examples

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
#> [25] "Microsoft.CSharp"                          
#> [26] "System.Reflection.Emit.ILGeneration"       
#> [27] "System.Reflection.Emit.Lightweight"        
#> [28] "System.Reflection.Primitives"              
#> [29] "Anonymously Hosted DynamicMethods Assembly"
```
