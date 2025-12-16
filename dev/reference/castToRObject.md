# Create if possible an object of the R6 class \`NetObject\`

Create if possible an object of the R6 class \`NetObject\`

## Usage

``` r
castToRObject(obj, recursive = TRUE)
```

## Arguments

- obj:

  the presumed external pointer.

- recursive:

  logical; if TRUE, the function is applied recursively to the list
  elements.

## Value

A \`NetObject\` R6 object if the argument is indeed an external pointer,
otherwise returned unchanged. If \`recursive\` is TRUE and \`obj\` is a
list, the function is applied recursively to the list elements.

## Details

Create if possible and adequate the R6 object of the class \`NetObject\`
that wraps the external pointer to a .NET object. If \`obj\` is not a
pointer, returns \`obj\` unchanged.

## Examples

``` r
castToRObject(1)
#> [1] 1
castToRObject("a")
#> [1] "a"
castToRObject(TRUE)
#> [1] TRUE
castToRObject(FALSE)
#> [1] FALSE
castToRObject(1L)
#> [1] 1
castToRObject(1.1)
#> [1] 1.1
castToRObject(1.1 + 1i)
#> [1] 1.1+1i
castToRObject(list(1, 2, 3))
#> [[1]]
#> [1] 1
#> 
#> [[2]]
#> [1] 2
#> 
#> [[3]]
#> [1] 3
#> 
castToRObject(data.frame(a = 1:3, b = c("a", "b", "c")))
#>   a b
#> 1 1 a
#> 2 2 b
#> 3 3 c
```
