context("glm")

test_that("convert binomial glm", {
  model <- glm(I(mpg >= 15) ~ -1 + hp + cyl + drat,
               data = mtcars, family = binomial())
  expect_silent(coreml_model <- coreml_convert(model))
})

test_that("prediction works", {
  tmp_file <- tempfile()
  f <- I(mpg >= 15) ~ -1 + hp + cyl + drat
  model <- glm(f, data = mtcars, family = binomial())
  coreml_model <- coreml_convert(model)
  pred <- coreml_predict(coreml_model, model.matrix(f, mtcars))
  expect_equal(pred, predict(model, type = "response"))
})