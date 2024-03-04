test_that("callStatic returns a NetObject when the static .NET method returns a non-primitive object", {
  testObj <- callTestCase("CreateTestObject")
  expect_true(inherits(testObj, "NetObject"))
  expect_equal(testObj$type, rSharpEnv$testObjectTypeName)

  testObj <- callTestCase("CreateTestObjectGenericInstance")
  expect_true(inherits(testObj, "NetObject"))
  # 2DO: Test for IS!

  # Not clear what should be tested here...
  testObj <- callTestCase("CreateTestArrayGenericObjects")
  testObj <- callTestCase("CreateTestArrayInterface")
  testObj <- callTestCase("CreateTestArrayGenericInterface")
})
