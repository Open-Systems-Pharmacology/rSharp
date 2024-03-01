test_that("Object constructor discovery behaves as expected", {
  expect_equal(
    c(
      "Constructor: .ctor",
      "Constructor: .ctor, Double",
      "Constructor: .ctor, Double, Double",
      "Constructor: .ctor, Int32",
      "Constructor: .ctor, Int32, Int32",
      "Constructor: .ctor, Int32, Int32, Double, Double"
    ),
    getConstructors(testClassName)
  )
})
