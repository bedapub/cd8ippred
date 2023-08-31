# this code was used to avoid package dependencies in the glmnet model
load("R/sysdata.rda")
ips <- names(cd8ip_model$glmnet.fit$beta)
ips
stopifnot(length(ips) == 3)
for (ip in ips) {
  Matrix::writeMM(
    cd8ip_model$glmnet.fit$beta[[ip]],
    paste0("inst/extdata/beta_", ip, ".mtx")
  )
}

cmp_dimnames <- function(m1, m2) {
  stopifnot(length(dimnames(m1)) == 2)
  stopifnot(length(dimnames(m2)) == 2)
  stopifnot(
    all(dimnames(m1)[[1]] == dimnames(m2)[[1]])
  )
  stopifnot(
    all(dimnames(m1)[[2]] == dimnames(m2)[[2]])
  )
}

cmp_dimnames(
  cd8ip_model$glmnet.fit$beta[[1]],
  cd8ip_model$glmnet.fit$beta[[2]]
)
cmp_dimnames(
  cd8ip_model$glmnet.fit$beta[[1]],
  cd8ip_model$glmnet.fit$beta[[3]]
)

cd8ip_model_beta_dimnames <- dimnames(cd8ip_model$glmnet.fit$beta[[1]])

cd8ip_model$glmnet.fit$beta <- NULL

cd8ip_model_partial <- cd8ip_model

usethis::use_data(cd8ip_model_partial, cd8ip_model_cnames, cd8ip_model_beta_dimnames, internal = T, overwrite = T)
