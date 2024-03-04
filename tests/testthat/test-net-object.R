test_that("It creates a `NetObject` from a valid pointer is provided", {
  testClassName <- "ClrFacade.Tests.RefClasses.LevelOneClass"
  o <- .External("r_create_clr_object", testClassName, PACKAGE = rSharpEnv$nativePkgName)
  netObj <- NetObject$new(o)
  # Check if the object is a NetObject
  expect_true(inherits(netObj, "NetObject"))
  # Check the type
  expect_equal(netObj$type, testClassName)
  # Check the print method
  netObj$print()
})

# Re-enable once https://github.com/Open-Systems-Pharmacology/rSharp/issues/67
# test_that("CLR type compatibility checking", {
#   testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
#   expect_true(clrIs(testObj, rSharpEnv$testObjectTypeName))
#   expect_true(clrIs(testObj, "System.Object"))
#   expect_false(clrIs(testObj, "System.Double"))
#   testObj <- newObjectFromName("ClrFacade.TestMethodBinding")
#   expect_true(clrIs(testObj, "ClrFacade.ITestMethodBindings"))
#   expect_true(clrIs(testObj, getType("ClrFacade.ITestMethodBindings")))
#   expect_true(clrIs(testObj, getType("ClrFacade.TestMethodBinding")))
#   expect_false(clrIs(testObj, getType("System.Reflection.Assembly")))
#   expect_error(clrIs(testObj, testObj))
# })



test_that("set works ", {
  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  clrReflect(testObj)
  clrSet(testObj, "FieldIntegerOne", as.integer(42))
  clrSet(rSharpEnv$testObjectTypeName, "StaticPropertyIntegerOne", as.integer(42))
})
