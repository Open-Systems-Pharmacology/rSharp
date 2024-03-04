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

test_that("$reflect lists all methods, fields, and properties", {
  expectedMethods <-  c("Equals", "get_PropertyIntegerOne", "get_PropertyIntegerTwo", "GetFieldIntegerOne",
                        "GetFieldIntegerTwo", "GetHashCode", "GetMethodWithParameters",
                        "GetPublicInt", "GetType", "set_PropertyIntegerOne",
                        "set_PropertyIntegerTwo", "TestDefaultValues", "TestParams", "ToString")
  expectedFields <- c("FieldDoubleOne", "FieldDoubleTwo", "FieldIntegerOne", "FieldIntegerTwo", "PublicInt")
  expectedProperties <- c("PropertyIntegerOne", "PropertyIntegerTwo")

  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  members <- testObj$reflect()
  expect_true(all(c("Methods", "Fields", "Properties") %in% names(members)))
  expect_true(all(members$Methods %in% expectedMethods))
  expect_true(all(members$Fields %in% expectedFields))
  expect_true(all(members$Properties %in% expectedProperties))
})



test_that("Object members discovery behaves as expected", {
  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  members <- testObj$reflect()

  f <- function(obj_or_tname, static = FALSE, getF, getP, getM) { # copy-paste may have been more readable... Anyway.
    prefix <- ifelse(static, "Static", "")
    collate <- function(...) {
      paste(..., sep = "")
    } # surely in stringr, but avoid dependency
    p <- function(basefieldname) {
      collate(prefix, basefieldname)
    }

    expect_that(getF(obj_or_tname, "IntegerOne"), equals(p("FieldIntegerOne")))
    expect_that(getP(obj_or_tname, "IntegerOne"), equals(p("PropertyIntegerOne")))

    expected_mnames <- paste(c("get_", "", "set_"), p(c("PropertyIntegerOne", "GetFieldIntegerOne", "PropertyIntegerOne")), sep = "")
    actual_mnames <- getM(obj_or_tname, "IntegerOne")

    expect_that(length(actual_mnames), equals(length(expected_mnames)))
    expect_true(all(actual_mnames %in% expected_mnames))

    sig_prefix <- ifelse(static, "Static, ", "")
    expect_that(
      clrGetMemberSignature(obj_or_tname, p("GetFieldIntegerOne")),
      equals(collate(sig_prefix, "Method: Int32 ", p("GetFieldIntegerOne")))
    )
    expect_that(
      clrGetMemberSignature(obj_or_tname, p("GetMethodWithParameters")),
      equals(collate(sig_prefix, "Method: Int32 ", p("GetMethodWithParameters, Int32, String")))
    )
  }


  f(testObj, static = FALSE, getFields, clrGetProperties, clrGetMethods)
  f(rSharpEnv$testObjectTypeName, static = TRUE, getStaticFields, getStaticProperties, getStaticMethods)
  # TODO test that methods that are explicit implementations of interfaces are found
})

###########




test_that("set works ", {
  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  clrReflect(testObj)
  clrSet(testObj, "FieldIntegerOne", as.integer(42))
  clrSet(rSharpEnv$testObjectTypeName, "StaticPropertyIntegerOne", as.integer(42))
})
