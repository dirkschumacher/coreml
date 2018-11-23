
<!-- README.md is generated from README.Rmd. Please edit that file -->

# coreml

The goal of coreml is to convert models trained/fitted in R to
[coreml](https://developer.apple.com/documentation/coreml) so that you
can use them in Apple iOS applications.

This is work in progress and just a proof of concept. Do not use it for
production, it barely works and I am still learning and testing.

## Installation

``` r
remotes::install_github("dirkschumacher/coreml")
```

## API

The API can and will change.

  - `coreml_convert` convert a R model to coreml
  - `coreml_predict` make predictions with a coreml model (just a proof
    of concept)
  - `coreml_save` save a coreml model to disk as binary data
  - `coreml_load` load a coreml model from disk
  - `convert_keras` convert a keras model to coreml using
    [coremltools](https://github.com/apple/coremltools). This does not
    work at the moment.

## Example

Here we convert a logistic regression model (GLM with `family=binomial`)
to a coreml model. Save it to disk, read it in again and make
predictions.

``` r
  library(coreml)
  model <- glm(I(mpg >= 15) ~ -1 + hp + cyl + drat, data = mtcars, family = binomial())

  coreml_model <- coreml_convert(model)
  
  path <- file.path(tempdir(), "test.mlmodel")
  
  coreml_save(coreml_model, path)

  mod <- coreml_load(path)

  newdata <- as.matrix(mtcars[, c("hp", "cyl", "drat")])
  
  all.equal(
    coreml_predict(mod, newdata),
    predict(model, mtcars, type = "response")
  )
#> [1] TRUE
```
