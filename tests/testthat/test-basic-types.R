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
