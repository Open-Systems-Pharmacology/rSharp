testGarbageCollection <- function(getObjCountMethodName = "GetMemTestObjCounter", createTestObjectMethodName = "CreateMemTestObj") {
  callGcMethname <- "CallGC"
  forceDotNetGc <- function() {
    callTestCase(callGcMethname)
  }
  checkPlusOne <- function() {
    expect_that(callTestCase(getObjCountMethodName), equals(counter + 1))
  }

  counter <- callTestCase(getObjCountMethodName)
  expect_that(counter, equals(0)) # make sure none of these test objects instances are hanging in the CLR
  testObj <- callTestCase(createTestObjectMethodName)
  checkPlusOne()
  forceDotNetGc()
  # the object should still be in memory.
  checkPlusOne()
  gc()
  # the object should still be in memory, since testObj is in use and thus the underlying clr handle should be pinned too.
  checkPlusOne()
  rm(testObj)
  gc()
  forceDotNetGc()
  expect_that(callTestCase(getObjCountMethodName), equals(counter))

  counter <- callTestCase(getObjCountMethodName)
  expect_that(counter, equals(0))
  testObj <- callTestCase(createTestObjectMethodName)
  clrSet(testObj, "Text", "et nous alimentons nos aimables remords comme les mendiants nourissent leur vermine")
  forceDotNetGc()
  checkPlusOne()
  clrSet(testObj, "Text", "Sur l'oreiller du mal...")
  checkPlusOne()
  rm(testObj)
  gc()
  forceDotNetGc()
}

test_that("Garbage collection in R and the .NET behaves as expected", {
  testGarbageCollection(getObjCountMethodName = "GetMemTestObjCounter", createTestObjectMethodName = "CreateMemTestObj")
})

# https://github.com/Open-Systems-Pharmacology/rSharp/issues/59
# test_that("Garbage collection of R.NET objects", {
#   testGarbageCollection( getObjCountMethodName = 'GetMemTestObjCounterRDotnet', createTestObjectMethodName = 'CreateMemTestObjRDotnet')
# })
