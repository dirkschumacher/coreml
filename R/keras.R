#' @export
convert_keras <- function(model, ...) {
  coremltools$converters$keras$convert(model, ...)
}