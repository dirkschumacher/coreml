context("keras")

test_that("can convert keras", {
  skip_if_no_coremltools()
  skip("Awaiting the next version of coremltools")
  model <- keras::keras_model_sequential()
  convert_keras(model)
})