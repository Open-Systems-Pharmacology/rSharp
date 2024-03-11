test_that("Object constructor discovery behaves as expected", {
  expect_equal(
    c(
      "Constructor: .ctor",
      "Constructor: .ctor, Double",
      "Constructor: .ctor, Double, Double",
      "Constructor: .ctor, Int32",
      "Constructor: .ctor, Int32, Int32",
      "Constructor: .ctor, Int32, Int32, Double, Double"
    ),
    getConstructors(rSharpEnv$testObjectTypeName)
  )
})

test_that("getType returns a `NetObject` with a pointer for an assembly name", {
  expect_equal(toStringNET(getType(rSharpEnv$testObjectTypeName)), rSharpEnv$testObjectTypeName)
})


test_that("getType returns a `NetObject` with a pointer for a `NetObject` object", {
  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  expect_equal(toStringNET(getType(testObj)), rSharpEnv$testObjectTypeName)
})

test_that("getType returns a `NetObject` with a pointer for a `NetObject` object
          created for a generic instance", {
  testObj <- callTestCase("CreateTestObjectGenericInstance")
  expect_equal(toStringNET(getType(testObj)), "ClrFacade.TestObjectGeneric`1[System.String]")
})
