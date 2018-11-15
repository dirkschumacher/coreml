#' @export
install_coremltools <- function(method = "auto", conda = "auto") {
  py_install("coremltools", method = method, conda = conda, envname = "r-tensorflow")
}
