# this code was used to avoid package dependencies in the simulated counts
load("data/cd8ip_simulated_counts.rda")

cd8ip_simulated_counts_exprs <- Biobase::exprs(cd8ip_simulated_counts)
cd8ip_simulated_counts_pdata <- Biobase::pData(cd8ip_simulated_counts)
cd8ip_simulated_counts_fdata <- Biobase::fData(cd8ip_simulated_counts)

load("R/sysdata.rda")
usethis::use_data(
  cd8ip_model_partial,
  cd8ip_model_cnames,
  cd8ip_model_beta_dimnames,
  cd8ip_simulated_counts_exprs,
  cd8ip_simulated_counts_pdata,
  cd8ip_simulated_counts_fdata,
  internal = T,
  overwrite = T
)
