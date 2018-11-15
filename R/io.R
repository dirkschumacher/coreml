#' @export
coreml_save <- function(model, file) {
  invisible(serialize(model$spec, file))
}

#' @export
coreml_load <- function(file) {
  coreml_model <- CoreML.Specification.Model$read(file)
  structure(list(spec = coreml_model), class = "coreml_model")
}
