########## R to .NET tests##########

# test_that("Array NULL is passed to .NET as null", {
#   expect_true(callTestCase("IsNull", c(1, NULL, 3)))
# })
# test_that("Array NA is passed to .NET as NA", {
#   expect_true(callTestCase("IsNull", c(1, NA, 3)))
# })
# test_that("Array NaN is passed to .NET as NaN", {
#   expect_true(callTestCase("IsNull", c(1, NaN, 3)))
# })

########## .NET to R tests##########
# test_that("Array NULL is passed from .NET as null", {
#   expect_equal(callTestCase("IsNull", NULL))
# })
# test_that("Array NA is passed from .NET as NA", {
#   expect_equal(callTestCase("IsNull", NA))
# })
# test_that("Array NaN is passed from .NET as NaN", {
#   expect_equal(callTestCase("IsNull", NA))
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
