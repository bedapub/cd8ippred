#' Simulated RNA-Seq counts, an [Biobase::ExpressionSet] object.
#'
#' Samples with `CD8IMMPH` column available were simulated based on the feature
#' values from real samples with respective CD8 immune phenotypes. Samples
#' without this information where simulated based on the complete feature
#' distribution (irrespective of the CD8 immune phenotype).
#' @importFrom Biobase ExpressionSet
"cd8ip_simulated_counts"

#' A [data.frame] with feature distribution simulated from kernel-density
#' estimates based on the training data.
#'
#' This is based on the [DESeq2::vst()] transformation. It can be used to
#' compare your data with the training data, without revealing the training
#' data directly.
"cd8ip_features_distribution"
