#' Apply [DESeq2::vst()] transformation to the data.
#'
#' This will use the [DESeq2::dispersionFunction()] learned from the
#' dataset used for model creation.
#'
#' If your pipeline/protocol is different than the one used for training,
#' you would probably need to use some sort of a batch-correction.
#'
#' @param matr Input raw counts matrix.
#'
#' @return A matrix with transformed values. R
#' Matrix rows are genes, matrix columns are samples.
#' @export
compute_vst <- function(matr) {
  if (is.null(colnames(matr))) {
    colnames(matr) <- seq_len(ncol(matr))
  }
  object <- DESeq2::DESeqDataSetFromMatrix(
    matr,
    data.frame(row.names = colnames(matr)),
    ~1
  )
  object <- DESeq2::estimateSizeFactors(object)
  suppressMessages({
    DESeq2::dispersionFunction(object) <- cd8ip_vst_dispersion_f
  })

  vsd <- DESeq2::varianceStabilizingTransformation(object, blind = FALSE)
  SummarizedExperiment::assay(vsd)
}
