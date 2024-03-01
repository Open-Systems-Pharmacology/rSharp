# test_that("It creates a `NetObject` from a valid pointer is provided", {
#   testClassName <- "ClrFacade.Tests.RefClasses.LevelOneClass"
#   o <- .External("r_create_clr_object", testClassName, PACKAGE = rSharpEnv$nativePkgName)
#   netObj <- NetObject$new(o)
#   # Check if the object is a NetObject
#   expect_true(inherits(netObj, "NetObject"))
#   # Check the type
#   expect_equal(netObj$type, testClassName)
#   # Check the print method
#   netObj$print()
# })
#
#
# # Check if the type is correct
# expect_equal(netObj$type, testClassName)


test_that("CLR type compatibility checking", {
  testObj <- clrNew(testClassName)
  expect_true(clrIs(testObj, testClassName))
  expect_true(clrIs(testObj, "System.Object"))
  expect_false(clrIs(testObj, "System.Double"))
  testObj <- clrNew("ClrFacade.TestMethodBinding")
  expect_true(clrIs(testObj, "ClrFacade.ITestMethodBindings"))
  expect_true(clrIs(testObj, getType("ClrFacade.ITestMethodBindings")))
  expect_true(clrIs(testObj, getType("ClrFacade.TestMethodBinding")))
  expect_false(clrIs(testObj, getType("System.Reflection.Assembly")))
  expect_error(clrIs(testObj, testObj))
})
