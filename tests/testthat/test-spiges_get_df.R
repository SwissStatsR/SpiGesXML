test_that("spiges_get_df() works", {
  x <- "https://dam-api.bfs.admin.ch/hub/api/dam/assets/32129227/master"

  df <- spiges_get_df(
    x = x,
    node = "Administratives"
  )
  expect_s3_class(df, "data.frame")
  expect_true(nrow(df) >= 1)
  expect_true(ncol(df) >= 1)

  # force return data
  df_incorrect <- spiges_get_df(
    x = system.file("example_incorrect_format.xml", package = "SpiGesXML"),
    node = "Administratives",
    force = TRUE
  )
  expect_s3_class(df_incorrect, "data.frame")
  expect_true(nrow(df_incorrect) >= 1)
  expect_true(ncol(df_incorrect) >= 1)
})

test_that("spiges_get_df() with spiges-ids works", {
  df_ids <- spiges_get_df(
    x = "https://dam-api.bfs.admin.ch/hub/api/dam/assets/32129180/master",
    node = "Personenidentifikatoren"
  )
  expect_s3_class(df_ids, "data.frame")
  expect_true(nrow(df_ids) >= 1)
  expect_true(ncol(df_ids) >= 1)
})

test_that("spiges_get_df() with version 1.3 works", {
  df_v1_3 <- spiges_get_df(
    x = "https://dam-api.bfs.admin.ch/hub/api/dam/assets/27905035/master",
    node = "Administratives",
    schema_xsd = "https://dam-api.bfs.admin.ch/hub/api/dam/assets/27905037/master"
  )
  expect_s3_class(df_v1_3, "data.frame")
  expect_true(nrow(df_v1_3) >= 1)
  expect_true(ncol(df_v1_3) >= 1)
})

cli::test_that_cli("spiges_get_df() returns error properly", {
  testthat::expect_snapshot({
    spiges_get_df(
      x = system.file("example_incorrect_format.xml", package = "SpiGesXML"),
      node = "Administratives"
    )
  })
})
