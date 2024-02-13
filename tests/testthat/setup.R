# this file is automatically loaded by testthat when running tests

# Variables
cTypename <- "ClrFacade.TestCases"
testClassName <- "ClrFacade.TestObject"


# Functions
areClrRefEquals <- function(x, y) {clrCallStatic('System.Object', 'ReferenceEquals', x, y)}

expectArrayTypeConv <- function(clrType, arrayLength, expectedRObj) {
  tn <- "ClrFacade.TestArrayMemoryHandling"
  arrayLength <- as.integer(arrayLength)
  expect_equal( clrCallStatic(tn, paste0("CreateArray_", clrType), arrayLength ), expectedRObj )
}

createArray <- function(clrType, arrayLength, elementObject) {
  tn <- "ClrFacade.TestArrayMemoryHandling"
  arrayLength <- as.integer(arrayLength)
  if(missing(elementObject)) { return(clrCallStatic(tn, paste0("CreateArray_", clrType), arrayLength )) }
  clrCallStatic(tn, paste0("CreateArray_", clrType), arrayLength, elementObject )
}

expectClrArrayElementType <- function(rObj, expectedClrTypeName) {
  tn <- "ClrFacade.TestArrayMemoryHandling"
  expect_true(clrCallStatic(tn, 'CheckElementType', rObj , clrGetType(expectedClrTypeName) ))
}

callTestCase <- function(...) {
  clrCallStatic(cTypename, ...)
}
