test_that("spiges_get_name_nodes() returns a none-zero character string", {
  name_nodes <- spiges_get_name_nodes(
    x = "https://dam-api.bfs.admin.ch/hub/api/dam/assets/32129227/master"
  )
  expect_true(class(name_nodes) == "character")
  expect_true(length(name_nodes) > 1)
})
