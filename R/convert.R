#' @export
coreml_convert <- function(model, input, output) UseMethod("coreml_convert")

#' @export
coreml_convert.glm <- function(model, input, output) {
  coreml_model <- new(CoreML.Specification.Model)
  glm_classifier <- new(CoreML.Specification.GLMClassifier)
  link <- if (model$family$link == "logit") 1
  link <- if (model$family$link == "probit") 2 else link
  glm_classifier$postEvaluationTransform <- link
  x <- new(CoreML.Specification.GLMClassifier.DoubleArray)
  x$add("value", as.numeric(model$coefficients))
  glm_classifier$add("weights", x)
  coreml_model$glmClassifier <- glm_classifier
  structure(list(spec = coreml_model), class = "coreml_model")
}

