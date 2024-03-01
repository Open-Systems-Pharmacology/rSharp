test_that("Loaded assemblies discovery", {
  expect_true("ClrFacade" %in% getLoadedAssemblies())
  d <- getLoadedAssemblies(fullname = TRUE, filenames = TRUE)
  expect_true(is.data.frame(d))
})
