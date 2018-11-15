#' Coreml tools
#'
#' @import RProtoBuf
#' @import reticulate
#'
#' @docType package
#' @name coreml
NULL
coremltools <- NULL

.onLoad <- function(libname, pkgname) {
  coremltools <<- import("coremltools", delay_load = list(
    environment = "r-tensorflow",
    priority = 5,
    on_load = function() {},
    on_error = function() {}
  ))
  readProtoFiles2("Model.proto", protoPath = system.file("coreml/mlmodel", package = "coreml"))
}
