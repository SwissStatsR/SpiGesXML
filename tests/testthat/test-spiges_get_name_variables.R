test_that("spiges_get_name_variables() returns a none-zero list", {
  name_variables <- spiges_get_name_variables(
    schema_xsd = "https://dam-api.bfs.admin.ch/hub/api/dam/assets/27905037/master"
  )
  expect_true(class(name_variables) == "list")
  expect_true(length(name_variables) > 1)
})
