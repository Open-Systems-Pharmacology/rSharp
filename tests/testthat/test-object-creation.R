test_that("newObjectFromName calls constructors when a valid name is provided", {
  tName <- "ClrFacade.TestObject"
  i1 <- as.integer(23)
  i2 <- as.integer(42)
  d1 <- 1.234
  d2 <- 2.345
  # Constructor without arguments
  obj <- newObjectFromName(tName)
  # Constructor with one argument
  obj <- newObjectFromName(tName, i1)
  expect_that(obj$get(obj, "FieldIntegerOne"), equals(i1))
  # Constructor with two arguments
  obj <- newObjectFromName(tName, i1, i2)
  expect_that(obj$get(obj, "FieldIntegerOne"), equals(i1))
  expect_that(obj$get(obj, "FieldIntegerTwo"), equals(i2))
  # Constructor with two double arguments
  obj <- newObjectFromName(tName, d1, d2)
  expect_that(obj$get(obj, "FieldDoubleOne"), equals(d1))
  expect_that(obj$get(obj, "FieldDoubleTwo"), equals(d2))
})

# Re-enable when https://github.com/Open-Systems-Pharmacology/rSharp/issues/66 is fixed
# test_that("newObjectFromName returns an error when an invalid name is provided", {
#   expect_error(newObjectFromName("InvalidTypeName"))
# })

test_that("Basic objects are created correctly", {
  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  expect_true(inherits(testObj, "NetObject"))
  expect_equal(testObj$type, rSharpEnv$testObjectTypeName)
  rm(testObj)

  # Call to a static method creates an S4 object
  testObj <- .External("r_call_static_method", rSharpEnv$testCasesTypeName, "CreateTestObject", PACKAGE = rSharpEnv$nativePkgName)
  expect_false(is.null(testObj))
  expect_that(testObj@clrtype, equals(rSharpEnv$testObjectTypeName))
  rm(testObj)
})