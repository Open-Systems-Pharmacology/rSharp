test_that("Object constructors calls work", {
  tName <- "ClrFacade.TestObject"
  i1 <- as.integer(23)
  i2 <- as.integer(42)
  d1 <- 1.234
  d2 <- 2.345
  # Constructor without arguments
  obj <- clrNew(tName)
  # Constructor with one argument
  obj <- clrNew(tName, i1)
  expect_that(clrGet(obj, "FieldIntegerOne"), equals(i1))
  # Constructor with two arguments
  obj <- clrNew(tName, i1, i2)
  expect_that(clrGet(obj, "FieldIntegerOne"), equals(i1))
  expect_that(clrGet(obj, "FieldIntegerTwo"), equals(i2))
  # Constructor with two double arguments
  obj <- clrNew(tName, d1, d2)
  expect_that(clrGet(obj, "FieldDoubleOne"), equals(d1))
  expect_that(clrGet(obj, "FieldDoubleTwo"), equals(d2))
})

test_that("getType function", {
  testObj <- clrNew(testClassName)
  expect_equal(testClassName, clrGet(getType(testClassName), "FullName"))
  expect_equal(testClassName, clrGet(getType(testObj), "FullName"))
})

test_that("Basic objects are created correctly", {
  testObj <- clrNew(testClassName)
  expect_that(testObj@clrtype, equals(testClassName))
  rm(testObj)
  testObj <- .External("r_call_static_method", rSharpEnv$testCasesTypeName, "CreateTestObject", PACKAGE = rSharpEnv$nativePkgName)
  expect_false(is.null(testObj))
  expect_that(testObj@clrtype, equals(testClassName))
  rm(testObj)
  testObj <- callTestCase("CreateTestObject")
  expect_false(is.null(testObj))
  expect_that(testObj@clrtype, equals(testClassName))

  testObj <- callTestCase("CreateTestObjectGenericInstance")
  expect_false(is.null(testObj))

  # Not clear what should be tested here...
  testObj <- callTestCase("CreateTestArrayGenericObjects")
  testObj <- callTestCase("CreateTestArrayInterface")
  testObj <- callTestCase("CreateTestArrayGenericInterface")
})

test_that("set works ", {
  testClassName <- rSharpEnv$testObjectTypeName
  testObj <- clrNew(testClassName)
  clrReflect(testObj)
  clrSet(testObj, "FieldIntegerOne", as.integer(42))
  clrSet(testClassName, "StaticPropertyIntegerOne", as.integer(42))
})
