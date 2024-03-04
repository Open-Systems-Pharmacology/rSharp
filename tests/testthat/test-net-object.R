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

test_that("$getMethods lists all methods of an object", {
  expectedMethods <-  c("Equals", "get_PropertyIntegerOne", "get_PropertyIntegerTwo", "GetFieldIntegerOne",
                        "GetFieldIntegerTwo", "GetHashCode", "GetMethodWithParameters",
                        "GetPublicInt", "GetType", "set_PropertyIntegerOne",
                        "set_PropertyIntegerTwo", "TestDefaultValues", "TestParams", "ToString")

  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  expect_true(all(testObj$getMethods() %in% expectedMethods))
})

test_that("$getMethods lists all methods of an object that include a given string", {
  expectedMethods <-  c("get_PropertyIntegerOne", "GetFieldIntegerOne", "set_PropertyIntegerOne")

  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  expect_true(all(testObj$getMethods(contains = "IntegerOne") %in% expectedMethods))
})


test_that("$getFields lists all fields of an object", {
  expectedFields <- c("FieldDoubleOne", "FieldDoubleTwo", "FieldIntegerOne", "FieldIntegerTwo", "PublicInt")

  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  expect_true(all(testObj$getFields() %in% expectedFields))
})

test_that("$getFields lists all fields of an object that include a given string", {
  expectedFields <- c("FieldIntegerOne")

  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  expect_true(all(testObj$getFields(contains = "IntegerOne") %in% expectedFields))
})

test_that("$getProperties lists all properties of an object", {
  expectedProperties <- c("PropertyIntegerOne", "PropertyIntegerTwo")

  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  expect_true(all(testObj$getProperties() %in% expectedProperties))
})

test_that("$getProperties lists all properties of an object that include a given string", {
  expectedProperties <- c("PropertyIntegerOne")

  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  expect_true(all(testObj$getProperties(contains = "IntegerOne") %in% expectedProperties))
})


test_that("Object members discovery behaves as expected", {
  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)

  f <- function(obj_or_tname, static = FALSE, getF, getP, getM) { # copy-paste may have been more readable... Anyway.
    prefix <- ifelse(static, "Static", "")
    collate <- function(...) {
      paste(..., sep = "")
    } # surely in stringr, but avoid dependency
    p <- function(basefieldname) {
      collate(prefix, basefieldname)
    }

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

  f(rSharpEnv$testObjectTypeName, static = TRUE, getStaticFields, getStaticProperties, getStaticMethods)
})

###########




test_that("set works ", {
  testObj <- newObjectFromName(rSharpEnv$testObjectTypeName)
  clrSet(testObj, "FieldIntegerOne", as.integer(42))
  clrSet(rSharpEnv$testObjectTypeName, "StaticPropertyIntegerOne", as.integer(42))
})
