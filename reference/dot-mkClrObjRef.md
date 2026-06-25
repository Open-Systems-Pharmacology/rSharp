# Create if possible an S4 \`cobjRef\` object.

Create if possible and adequate the S4 object that wraps the external
pointer to a \`cobjRef\` object.

## Usage

``` r
.mkClrObjRef(obj, clrtype = NULL)
```

## Arguments

- obj:

  the presumed external pointer.

- clrtype:

  character; the name of the type for the object. If NULL, rSharp
  retrieves the type name.

## Value

a cobjRef S4 object if the argument is indeed an external pointer,
otherwise returned unchanged.
