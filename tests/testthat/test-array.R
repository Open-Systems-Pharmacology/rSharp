# Name of the testcase class
cTypename <- "ClrFacade.TestArrayMemoryHandling"

# Test for expected length and type of an array returned from .NET
expectArrayTypeConv <- function(type, arrayLength, expectedRObj, ...) {
  arrayLength <- as.integer(arrayLength)
  obj <- callStatic(cTypename, paste0("CreateArray_", type), arrayLength, ...)
  expect_equal(obj, expectedRObj)
}

# Test that R passes correct type of array to .NET
expectArrayElementType <- function(rObj, expectedTypeName) {
  netType <- callStatic(rSharpEnv$clrFacadeTypeName, "GetType", expectedTypeName)
  expect_true(callStatic(cTypename, "CheckElementType", rObj, netType))
}

test_that("Basic types of length zero are returned correctly from .NET", {
  expectArrayTypeConv("float", 0, numeric(0))
  expectArrayTypeConv("double", 0, numeric(0))
  expectArrayTypeConv("int", 0, integer(0))
  expectArrayTypeConv("byte", 0, raw(0))
  expectArrayTypeConv("char", 0, character(0))
  expectArrayTypeConv("bool", 0, logical(0))
  expectArrayTypeConv("string", 0, character(0))

  # Empty arrays of a certain type are empty lists in R
  expectArrayTypeConv("object", 0, list())
  expectArrayTypeConv("Type", 0, list())
})

test_that("Basic types of length 1 are returned correctly from .NET", {
  expectArrayTypeConv("float", 1, numeric(1))
  expectArrayTypeConv("double", 1, numeric(1))
  expectArrayTypeConv("int", 1, integer(1))
  expectArrayTypeConv("byte", 1, raw(1))
  expectArrayTypeConv("char", 1, character(1))
  expectArrayTypeConv("bool", 1, logical(1))
  expectArrayTypeConv("string", 1, character(1), "")

  # Empty arrays of a certain type are empty lists in R
  expectArrayTypeConv("object", 1, vector("list", 1))
  expectArrayTypeConv("Type", 1, vector("list", 1))
})

test_that("Basic types of length >1 are returned correctly from .NET", {
  expectArrayTypeConv("float", 2, numeric(2))
  expectArrayTypeConv("double", 2, numeric(2))
  expectArrayTypeConv("int", 2, integer(2))
  expectArrayTypeConv("byte", 2, raw(2))
  expectArrayTypeConv("char", 2, character(2))
  expectArrayTypeConv("bool", 2, logical(2))
  expectArrayTypeConv("string", 2, character(2), "")

  # Empty arrays of a certain type are empty lists in R
  expectArrayTypeConv("object", 2, vector("list", 2))
  expectArrayTypeConv("Type", 2, vector("list", 2))
})

test_that("Basic types of length zero are passed correctly from R to .NET", {
  expectArrayElementType(numeric(0), "System.Double")
  expectArrayElementType(integer(0), "System.Int32")
  expectArrayElementType(raw(0), "System.Byte")
  expectArrayElementType(logical(0), "System.Boolean")
  expectArrayElementType(character(0), "System.String")


  aPosixCt <- numeric(0)
  attributes(aPosixCt) <- list(tzone = "UTC")
  class(aPosixCt) <- c("POSIXct", "POSIXt")

  expect_equal(callStatic(cTypename, "CreateArray_DateTime", 0L), aPosixCt)

  tdiff <- numeric(0)
  class(tdiff) <- "difftime"
  attr(tdiff, "units") <- "secs"
  expect_equal(callStatic(cTypename, "CreateArray_TimeSpan", 0L), tdiff)

  expectArrayElementType(aPosixCt, "System.DateTime")
  expectArrayElementType(tdiff, "System.TimeSpan")
})

# Same for length 1!
# Investigate after https://github.com/Open-Systems-Pharmacology/rSharp/issues/35
# test_that("Basic types of length one are passed correctly from R to .NET", {
#   expectArrayElementType(numeric(1), "System.Double")
#   expectArrayElementType(integer(1), "System.Int32")
#   expectArrayElementType(raw(1), "System.Byte")
#   expectArrayElementType(logical(1), "System.Boolean")
#   expectArrayElementType(character(1), "System.String")
#   expectArrayElementType("a", "System.String")
# })

# Same for length >1!
# Investigate after https://github.com/Open-Systems-Pharmacology/rSharp/issues/35
# test_that("Basic types of length one are passed correctly from R to .NET", {
#   expectArrayElementType(numeric(2), "System.Double")
#   expectArrayElementType(integer(2), "System.Int32")
#   expectArrayElementType(raw(2), "System.Byte")
#   expectArrayElementType(logical(2), "System.Boolean")
#   expectArrayElementType(character(2), "System.String")
#   expectArrayElementType("aa", "System.String")
# })
