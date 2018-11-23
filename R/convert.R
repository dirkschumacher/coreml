#' @export
coreml_convert <- function(model, input, output) UseMethod("coreml_convert")

#' @export
coreml_convert.glm <- function(model, input, output) {
  # hacked together. WIP. Don't judge me
  coreml_model <- new(CoreML.Specification.Model)
  coreml_model$specificationVersion <- 1
  coreml_model$description$predictedFeatureName <- "class"
  coreml_model$description$predictedProbabilitiesName <- "prob"
  features <- lapply(names(coef(model)), function(input) {
    input_feature <- new(CoreML.Specification.FeatureDescription)
    input_feature$name <- input
    type <- new(CoreML.Specification.FeatureType)
    type$doubleType <- new(CoreML.Specification.DoubleFeatureType)
    input_feature$type <- type
    input_feature
  })
  coreml_model$description$input <- features
  output_feature_prob <- new(CoreML.Specification.FeatureDescription)
  output_feature_prob$name <- "prob"
  type <- new(CoreML.Specification.FeatureType)
  type$multiArrayType <- new(CoreML.Specification.ArrayFeatureType)
  type$multiArrayType$shape <- 1
  type$multiArrayType$dataType <- 65600
  output_feature_prob$type <- type
  output_feature_class <- new(CoreML.Specification.FeatureDescription)
  output_feature_class$name <- "class"
  type <- new(CoreML.Specification.FeatureType)
  type$int64Type <- new(CoreML.Specification.Int64FeatureType)
  output_feature_class$type <- type
  coreml_model$description$output <- list(output_feature_prob, output_feature_class)
  metadata <- new(CoreML.Specification.Metadata)
  metadata$versionString <- "1.0.0"
  coreml_model$description$metadata <- metadata
  glm_classifier <- new(CoreML.Specification.GLMClassifier)
  link <- if (model$family$link == "logit") 1
  link <- if (model$family$link == "probit") 2 else link
  glm_classifier$postEvaluationTransform <- link
  glm_classifier$int64ClassLabels$vector <- c(0L, 1L)
  glm_classifier$classEncoding <- 0L
  x <- new(CoreML.Specification.GLMClassifier.DoubleArray)
  x$add("value", as.numeric(model$coefficients))
  glm_classifier$add("weights", x)
  glm_classifier$add("offset", 0)
  coreml_model$glmClassifier <- glm_classifier
  structure(list(spec = coreml_model), class = "coreml_model")
}

