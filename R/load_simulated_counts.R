#' Simulated RNA-Seq counts, an [Biobase::ExpressionSet] object.
#'
#' Samples with `CD8IMMPH` column available were simulated based on the feature
#' values from real samples with respective CD8 immune phenotypes. Samples
#' without this information where simulated based on the complete feature
#' distribution (irrespective of the CD8 immune phenotype).
#' @return [Biobase::ExpressionSet]
#' @export
load_simulated_counts <- function() {
  Biobase::ExpressionSet(
    assayData = cd8ip_simulated_counts_exprs,
    phenoData = Biobase::AnnotatedDataFrame(cd8ip_simulated_counts_pdata),
    featureData = Biobase::AnnotatedDataFrame(cd8ip_simulated_counts_fdata)
  )
}
