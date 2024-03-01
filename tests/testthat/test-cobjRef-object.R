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
