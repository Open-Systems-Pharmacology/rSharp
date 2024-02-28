test_that("It returns NULL if the passed object is NULL", {
  expect_equal(createNetObject(NULL), NULL)
})

test_that("It returns base R types as is", {
  expect_equal(createNetObject(1), 1)
  expect_equal(createNetObject("a"), "a")
  expect_equal(createNetObject(TRUE), TRUE)
  expect_equal(createNetObject(FALSE), FALSE)
  expect_equal(createNetObject(1L), 1L)
  expect_equal(createNetObject(1.1), 1.1)
  expect_equal(createNetObject(1.1 + 1i), 1.1 + 1i)
  expect_equal(createNetObject(1:3), 1:3)
  expect_equal(createNetObject(c(1, 2, 3)), c(1, 2, 3))
  expect_equal(createNetObject(list(1, 2, 3)), list(1, 2, 3))
  expect_equal(createNetObject(data.frame(a = 1:3, b = c("a", "b", "c"))), data.frame(a = 1:3, b = c("a", "b", "c")))
})

test_that("It returns a `NetObject` when a valid pointer is provided", {
  testClassName <- "ClrFacade.Tests.RefClasses.LevelOneClass"
  o <- .External("r_create_clr_object", testClassName, PACKAGE = rSharpEnv$nativePkgName)
  netObj <- createNetObject(o)
  # Check if the object is a NetObject
  expect_true(inherits(netObj, "NetObject"))
})
