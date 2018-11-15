#' @export
coreml_predict <- function(model, newdata) {
  internal_model <- model
  if (model$spec$has("glmClassifier")) {
    class(internal_model) <- c(class(internal_model), "GLMClassifier")
  }
  coreml_predict_internal(internal_model, newdata)
}

coreml_predict_internal <- function(model, newdata) UseMethod("coreml_predict_internal")

coreml_predict_internal.GLMClassifier <- function(model, newdata) {
  spec <- model$spec
  is_logit <- spec$glmClassifier$postEvaluationTransform == 1
  link <- stats::binomial(link = if (is_logit) "logit" else "probit")
  coefficients <- spec$glmClassifier$weights[[1]]$value
  link$linkinv(newdata %*% coefficients)[, 1]
}