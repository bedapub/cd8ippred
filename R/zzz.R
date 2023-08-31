.onLoad <- function(libname, pkgname) {
  # the beta matrix was not saved with the package, but stored in
  # inst/extdata instead. this is to avoid dependencies in .rda files
  #
  # this code recreates full glmnet model
  beta <- sapply(
    c("inflamed", "excluded", "desert"),
    function(ip) {
      m <- Matrix::readMM(
        system.file(
          "extdata",
          paste0("beta_", ip, ".mtx"),
          package = pkgname,
          mustWork = TRUE
        )
      )
      dimnames(m) <- cd8ip_model_beta_dimnames
      m
    },
    simplify = FALSE,
    USE.NAMES = TRUE
  )
  model_env$cd8ip_model <- cd8ip_model_partial
  model_env$cd8ip_model$glmnet.fit$beta <- beta

  invisible()
}
