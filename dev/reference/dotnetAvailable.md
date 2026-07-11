# Check whether the .NET runtime is available

Reports whether rSharp can currently call into .NET. The runtime is
initialised when the package loads, but loading never fails when the
runtime is missing or cannot be initialised (see the package startup
message). \`dotnetAvailable()\` lets you branch on that state, for
example to conditionally run code, examples, or vignette chunks that
require .NET.

## Usage

``` r
dotnetAvailable()
```

## Value

A single logical: \`TRUE\` if the .NET runtime is available and
initialised, \`FALSE\` otherwise.

## Details

If the runtime was not initialised at load time (for instance because
.NET was installed afterwards), a single initialisation attempt is made.
The attempt never raises an error; it only reports success or failure.

## Examples

``` r
if (dotnetAvailable()) {
  callStatic("System.Environment", "get_Version")
}
#> 
#> ── <NetObject> ──
#> 
#> Type: System.Version
#> 
#> ── Available Methods 
#>   • `Clone()`
#>   • `CompareTo()`
#>   • `CompareTo()`
#>   • `Equals()`
#>   • `Equals()`
#>   • `get_Build()`
#>   • `get_Major()`
#>   • `get_MajorRevision()`
#>   • `get_Minor()`
#>   • `get_MinorRevision()`
#>   • `get_Revision()`
#>   • `GetHashCode()`
#>   • `GetType()`
#>   • `ToString()`
#>   • `ToString()`
#>   • `TryFormat()`
#>   • `TryFormat()`
#>   • `TryFormat()`
#>   • `TryFormat()`
#> 
#> ── Available Properties 
#>   • Build
#>   • Major
#>   • MajorRevision
#>   • Minor
#>   • MinorRevision
#>   • Revision
```
