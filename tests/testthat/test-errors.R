# calling constructor with wrong arguments

# r_create_clr_object
# https://github.com/Open-Systems-Pharmacology/rSharp/issues/87
# test_that("Trying to create an object with wrong arguments", {
#   expect_error(newObjectFromName(rSharpEnv$testObjectTypeName, 1, 1, 1))
# })

# https://github.com/Open-Systems-Pharmacology/rSharp/issues/87
# test_that("Trying to create an object with wrong type name", {
#   expect_error(newObjectFromName("foo", 1, 1))
# })

# r_call_method
testObj <- newObjectFromName(rSharpEnv$testObjectTypeName, 1, 1)

# https://github.com/Open-Systems-Pharmacology/rSharp/issues/88
# test_that("Calling a method with wrong arguments", {
#   expect_error(testObj$call(methodName = "TestDefaultValues", "a", 3))
# })
# https://github.com/Open-Systems-Pharmacology/rSharp/issues/88
# test_that("Calling a method with wrong method name", {
#   expect_error(testObj$call(methodName = "foo", "a", as.integer(3)))
# })

# r_get_object_direct

# r_get_typename_externalptr

# r_get_sexp_type

# r_show_args

# r_call_static_method
