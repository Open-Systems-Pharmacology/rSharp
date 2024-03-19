########### R to .NET tests##########
test_that("Basic NULL is passed to .NET as null", {
 expect_true(callTestCase("IsNull", NULL))
})
test_that("Basic NA is passed to .NET as NA", {
 expect_true(callTestCase("IsNA", NA))
})
test_that("Basic NaN is passed to .NET as NaN", {
  expect_true(callTestCase("IsNaN", NaN))
})

# test_that("NULL in an array is passed to .NET as NULL", {
#   browser()
#  expect_true(callTestCase("IsNull", c(1, NULL, 3)))
# })
# test_that("NA in an array is passed to .NET as NA", {
#   expect_true(callTestCase("IsNA", c(1, NA, 3)))
# })
# test_that("NaN in an array is passed to .NET as NaN", {
#   expect_true(callTestCase("IsNaN", c(1, NaN, 3)))
# })
#
# ########## .NET to R tests##########
test_that("Basic NULL is passed from .NET as null", {
  expect_equal(callTestCase("GetNull"), NULL)
})
# test_that("Basic NA is passed from .NET as NA", {
#   expect_true(callTestCase("GetNA", NA))
# })
test_that("Basic NaN is passed from .NET as NaN", {
  expect_equal(callTestCase("GetNaN"), NaN)
})
#
# test_that("Array NULL is passed from .NET as null", {
#   expect_equal(callTestCase("GetNULLArray", c(1, NULL, 3)))
# })
# test_that("Array NA is passed from .NET as NA", {
#   expect_equal(callTestCase("GetNAArray", c(1, NA, 3)))
# })
# test_that("Array NaN is passed from .NET as NaN", {
#   expect_equal(callTestCase("GetNaNlArray", c(1, NaN, 3)))
# })
