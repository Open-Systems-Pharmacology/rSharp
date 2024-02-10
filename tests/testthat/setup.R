# this file is automatically loaded by testthat when running tests

# Variables
cTypename <- "Rclr.TestCases"
testClassName <- "Rclr.TestObject"


# Functions
areClrRefEquals <- function(x, y) {clrCallStatic('System.Object', 'ReferenceEquals', x, y)}

expectArrayTypeConv <- function(clrType, arrayLength, expectedRObj) {
  tn <- "Rclr.TestArrayMemoryHandling"
  arrayLength <- as.integer(arrayLength)
  expect_equal( clrCallStatic(tn, paste0("CreateArray_", clrType), arrayLength ), expectedRObj )
}

createArray <- function(clrType, arrayLength, elementObject) {
  tn <- "Rclr.TestArrayMemoryHandling"
  arrayLength <- as.integer(arrayLength)
  if(missing(elementObject)) { return(clrCallStatic(tn, paste0("CreateArray_", clrType), arrayLength )) }
  clrCallStatic(tn, paste0("CreateArray_", clrType), arrayLength, elementObject )
}

expectClrArrayElementType <- function(rObj, expectedClrTypeName) {
  print('Rclr.TestArrayMemoryHandling')
  tn <- "Rclr.TestArrayMemoryHandling"
  print('Expect True 1')
  print(expectedClrTypeName)
  type <- clrGetType(expectedClrTypeName)
  print('Call Static')
  callStatic <- clrCallStatic(tn, 'CheckElementType', rObj , type )
  print('Expect True 2')
  expect_true( callStatic)
}

callTestCase <- function(...) {
  clrCallStatic(cTypename, ...)
}
