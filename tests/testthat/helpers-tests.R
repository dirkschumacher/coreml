skip_if_no_coremltools <- function() {
  have_coremltools <- reticulate::py_module_available("coremltools")
  if (!have_coremltools) {
    skip("coremltools not available for testing")
  }
}