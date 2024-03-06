test_that("enums get/set", {
  # very basic support for the time being. Behavior to be defined for cases such as enums with binary operators ([FlagsAttribute])
  eType <- "ClrFacade.TestEnum"
  expect_that(getEnumNames(eType), equals(c("A", "B", "C")))
  e <- callStatic(rSharpEnv$testCasesTypeName, "GetTestEnum", "B")
  expect_false(is.null(e))
  expect_that(clrCall(e, "ToString"), equals("B"))
})
