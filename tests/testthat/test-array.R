# Name of the testcase class
cTypename <- "ClrFacade.TestArrayMemoryHandling"

# Test for expected length and type of an array returned from .NET
expectArrayTypeConv <- function(type, arrayLength, expectedRObj) {
  arrayLength <- as.integer(arrayLength)
  expect_equal(callStatic(cTypename, paste0("CreateArray_", type), arrayLength), expectedRObj)
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
