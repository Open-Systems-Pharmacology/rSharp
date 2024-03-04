test_that("Booleans are marshalled correctly", {
  expect_false(callTestCase("GetFalse"))
  expect_true(callTestCase("GetTrue"))
  expect_true(callTestCase("IsTrue", TRUE))
  expect_false(callTestCase("IsTrue", FALSE))
})

test_that("Basic types of length one are marshalled correctly", {
  # R to NET
  expect_true(callTestCase("DoubleEquals", 123.0))
  expect_true(callTestCase("IntEquals", as.integer(123)))
  expect_true(callTestCase("StringEquals", "ab"))
  # NET to R
  expect_that(callTestCase("CreateDouble"), equals(123.0))
  expect_that(callTestCase("CreateInt"), equals(as.integer(123)))
  expect_that(callTestCase("CreateString"), equals("ab"))
})

# Requires https://github.com/Open-Systems-Pharmacology/rSharp/issues/40
# test_that("Unicode strings are marshalled correctly", {
#   # R to NET
#   expect_true(callTestCase("UnicodeStringEquals", "äöü"))
#   # NET to R
#   expect_true(callTestCase("CreateUnicodeString", "äöü"))
# })

# https://github.com/Open-Systems-Pharmacology/rSharp/issues/57
# test_that("Basic NULL is passed to .NET as null", {
#   expect_true(callTestCase("IsNull", NULL))
# })
# test_that("Basic NA is passed to .NET as NA", {
#   expect_true(callTestCase("IsNull", NA))
# })
# test_that("Basic NaN is passed to .NET as NaN", {
#   expect_true(callTestCase("IsNull", NaN))
# })
#
# test_that("Basic NULL is passed from .NET as null", {
#   expect_true(callTestCase("IsNull", NULL))
# })
# test_that("Basic NA is passed from .NET as NA", {
#   expect_true(callTestCase("IsNull", NA))
# })
# test_that("Basic NaN is passed from .NET as NaN", {
#   expect_true(callTestCase("IsNull", NaN))
# })

test_that("Complex numbers are converted", {
  z <- 1 + 2i
  expect_equal(callTestCase("CreateComplex", 1, 2), z)
  expect_true(callTestCase("ComplexEquals", z, 1, 2))
  z <- c(1 + 2i, 3 + 4i, 3.3 + 4.4i)
  expect_equal(callTestCase("CreateComplex", c(1, 3, 3.3), c(2, 4, 4.4)), z)
  expect_true(callTestCase("ComplexEquals", z, c(1, 3, 3.3), c(2, 4, 4.4)))
})
