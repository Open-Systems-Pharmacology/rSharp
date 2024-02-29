# this file is automatically loaded by testthat when running tests

# Variables
testClassName <- "ClrFacade.TestObject"


# Functions
areClrRefEquals <- function(x, y) {
  callStatic("System.Object", "ReferenceEquals", x, y)
}

expectArrayTypeConv <- function(clrType, arrayLength, expectedRObj) {
  tn <- "ClrFacade.TestArrayMemoryHandling"
  arrayLength <- as.integer(arrayLength)
  expect_equal(callStatic(tn, paste0("CreateArray_", clrType), arrayLength), expectedRObj)
}

createArray <- function(clrType, arrayLength, elementObject) {
  tn <- "ClrFacade.TestArrayMemoryHandling"
  arrayLength <- as.integer(arrayLength)
  if (missing(elementObject)) {
    return(callStatic(tn, paste0("CreateArray_", clrType), arrayLength))
  }
  callStatic(tn, paste0("CreateArray_", clrType), arrayLength, elementObject)
}

expectClrArrayElementType <- function(rObj, expectedClrTypeName) {
  tn <- "ClrFacade.TestArrayMemoryHandling"
  expect_true(callStatic(tn, "CheckElementType", rObj, clrGetType(expectedClrTypeName)))
}

callTestCase <- function(...) {
  callStatic(rSharpEnv$testCasesTypeName, ...)
}