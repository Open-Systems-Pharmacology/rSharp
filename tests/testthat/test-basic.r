test_that("Methods with variable number of parameters with c# 'params' keyword", {
  testObj <- clrNew(testClassName)
  actual <- clrCall(testObj, "TestParams", "Hello, ", "World!", 1L, 2L, 3L, 6L, 5L, 4L)
  expected <- "Hello, World!123654"
  expect_equal(actual, expected = expected)
  actual <- clrCall(testObj, "TestParams", "Hello, ", "World!", as.integer(1:6))
  expected <- "Hello, World!123456"
  expect_equal(actual, expected = expected)
})

test_that("Correct method binding based on parameter types", {
  mkArrayTypeName <- function(typeName) {
    paste(typeName, "[]", sep = "")
  }
  f <- function(...) {
    callStatic("ClrFacade.TestMethodBinding", "SomeStaticMethod", ...)
  }
  printIfDifferent <- function(got, expected) {
    if (any(got != expected)) {
      print(paste("got", got, ", expected", expected))
    }
  }
  g <- function(values, typeName) {
    if (is.list(values)) { # this is what one gets with a concatenation of S4 objects, when we use c(testObj,testObj) with CLR objects
      printIfDifferent(f(values[[1]]), typeName)
      printIfDifferent(f(values), mkArrayTypeName(typeName)) # This is not yet supported?
      printIfDifferent(f(values[[1]], values[[2]]), rep(typeName, 2))
      expect_equal(f(values[[1]]), typeName)
      expect_equal(f(values), mkArrayTypeName(typeName))
      expect_equal(f(values[[1]], values[[2]]), rep(typeName, 2))
    } else {
      printIfDifferent(f(values[1]), typeName)
      printIfDifferent(f(values), mkArrayTypeName(typeName))
      printIfDifferent(f(values[1], values[2]), rep(typeName, 2))
      expect_equal(f(values[1]), typeName)
      expect_equal(f(values), mkArrayTypeName(typeName))
      expect_equal(f(values[1], values[2]), rep(typeName, 2))
    }
  }
  intName <- "System.Int32"
  doubleName <- "System.Double"
  stringName <- "System.String"
  boolName <- "System.Boolean"
  dateTimeName <- "System.DateTime"
  objectName <- "System.Object"
  testObj <- clrNew(testClassName)

  testMethodBinding <- function() {
    g(1:3, intName)
    g(1.2 * 1:3, doubleName)
    g(letters[1:3], stringName)
    g(rep(TRUE, 3), boolName)
    g(as.Date("2001-01-01") + 1:3, dateTimeName)
    g(c(testObj, testObj, testObj), objectName)

    expect_equal(f(1.0, "a"), c(doubleName, stringName))
    expect_equal(f(1.0, "a", "b"), c(doubleName, stringName, stringName))
    expect_equal(f(1.0, letters[1:2]), c(doubleName, mkArrayTypeName(stringName)))
    expect_equal(f(1.0, letters[1:10]), c(doubleName, mkArrayTypeName(stringName)))

    expect_equal(f("a", letters[1:3]), c(stringName, mkArrayTypeName(stringName)))
    expect_equal(f(letters[1:3], "a"), c(mkArrayTypeName(stringName), stringName))
    expect_equal(f(letters[1:3], letters[4:6]), c(mkArrayTypeName(stringName), mkArrayTypeName(stringName)))
  }
  testMethodBinding()
  obj <- clrNew("ClrFacade.TestMethodBinding")
  f <- function(...) {
    clrCall(obj, "SomeInstanceMethod", ...)
  }
  testMethodBinding()
  # Test that methods implemented to comply with an interface are found, even if the method is explicitely implemented.
  # We do not want the users to have to figure out which interface type they deal with, at least not for R users.
  f <- function(...) {
    clrCall(obj, "SomeExplicitlyImplementedMethod", ...)
  }
  testMethodBinding()
})

test_that("Conversion of non-bijective types can be turned on/off", {
  # When the conversion is turned off, a `cobjRef` is returned, which holds a reference to the .NET object.
  setConvertAdvancedTypes(FALSE)
  expect_true(is(callTestCase("CreateStringDictionary"), "cobjRef"))
  expect_true(is(callTestCase("CreateStringDoubleArrayDictionary"), "cobjRef"))
  # When the conversion is turned on, the .NET object is converted to an R list.
  setConvertAdvancedTypes(TRUE)
  expect_equal(callTestCase("CreateStringDictionary"), list(a = "A", b = "B"))
  expect_equal(callTestCase("CreateStringDoubleArrayDictionary"), list(a = c(1.0, 2.0, 3.0, 3.5, 4.3, 11), b = c(1.0, 2.0, 3.0, 3.5, 4.3), c = c(2.2, 3.3, 6.5)))
})

test_that("Object members discovery behaves as expected", {
  expect_true("ClrFacade.TestObject" %in% getTypesInAssembly("ClrFacade"))
  testObj <- clrNew(testClassName)
  members <- clrReflect(testObj)

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
  f(testClassName, static = TRUE, getStaticFields, getStaticProperties, getStaticMethods)
  # TODO test that methods that are explicit implementations of interfaces are found
})

test_that("Retrieval of object or class (i.e. static) members values behaves as expected", {
  f <- function(obj_or_type, rootMemberName, staticPrefix = "") {
    fieldName <- paste(staticPrefix, "Field", rootMemberName, sep = "")
    propName <- paste(staticPrefix, "Property", rootMemberName, sep = "")
    clrSet(obj_or_type, fieldName, as.integer(0))
    expect_that(clrGet(obj_or_type, fieldName), equals(0))
    clrSet(obj_or_type, fieldName, as.integer(2))
    expect_that(clrGet(obj_or_type, fieldName), equals(2))
    clrSet(obj_or_type, propName, as.integer(0))
    expect_that(clrGet(obj_or_type, propName), equals(0))
    clrSet(obj_or_type, propName, as.integer(2))
    expect_that(clrGet(obj_or_type, propName), equals(2))
  }
  # first object members
  testObj <- clrNew(testClassName)
  f(testObj, "IntegerOne", staticPrefix = "")
  # then test static members
  f(testClassName, "IntegerOne", staticPrefix = "Static")
})

test_that("toStringNET works for primitive types", {
  expect_that(toStringNET(1), equals("1"))
  expect_that(toStringNET(1.0), equals("1"))
  expect_that(toStringNET("a"), equals("a"))
  expect_that(toStringNET(TRUE), equals("True"))
  expect_that(toStringNET(FALSE), equals("False"))
  # Check of correct behavior
  #  expect_that(toStringNET(NA), equals("null"))
  #  expect_that(toStringNET(NULL), equals("null"))
  expect_that(toStringNET(NaN), equals("NaN"))
})

# Re-enable when https://github.com/Open-Systems-Pharmacology/rSharp/issues/35 is fixed
 test_that("Print Traceback", {
   tryCatch(
     callStatic(rSharpEnv$testCasesTypeName, "ThrowException", 10L), # will be truncated by the Rf_error API
     error = function(e) {
       cat("Caught an exception:\n", conditionMessage(e), "\n")
     }
   )
   #printTraceback() # prints the full stack trace
 })
