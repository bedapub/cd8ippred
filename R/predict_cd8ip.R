cache_env <- new.env(parent = emptyenv())

# create ecdf functions based on the reference distributions
prepare_cache <- function() {
  if (is.null(cache_env$reference_ecdf)) {
    cache_env$reference_ecdf <- getExportedValue(
      topenv(),
      "cd8ip_features_distribution"
    ) |>
      lapply(stats::ecdf)
  }
}

# convert a data.frame to a matrix for the prediction
prepare_data_matrix <- function(df) {
  assertthat::assert_that(!is.null(cache_env$reference_ecdf))
  essential_cols <- names(cache_env$reference_ecdf)
  missing_cols <- setdiff(
    essential_cols,
    colnames(df)
  )
  assertthat::assert_that(
    length(missing_cols) == 0,
    msg = paste0(
      "Some columns are missing from the input. E.g., ",
      paste0(utils::head(missing_cols, 10), collapse = ", ")
    )
  )

  non_essential_cols <- setdiff(cd8ip_model_cnames, essential_cols)

  essential_m <- df[, essential_cols] |>
    as.matrix()

  # we are not looking at non-essential columns, since they are not used
  # by the model anyway
  non_essential_m <- matrix(
    nrow = nrow(essential_m),
    ncol = length(non_essential_cols),
    dimnames = list(NULL, non_essential_cols)
  )

  m <- cbind(
    essential_m,
    non_essential_m
  )

  if (!is.null(rownames(df))) {
    rownames(m) <- rownames(df)
  }

  assertthat::assert_that(
    all(
      sort(colnames(m)) == sort(cd8ip_model_cnames)
    )
  )
  assertthat::assert_that(
    nrow(m) == nrow(df)
  )

  # reorder columns into expected order
  m[, cd8ip_model_cnames]
}

#' Predict a CD8 immune phenotype using RNA-Seq data.
#'
#' @param df a [data.frame] with each row corresponding to a single observation.
#'   This [data.frame] should have all the columns available in the
#'   [cd8ip_features_distribution]. Feature values should be based on the
#'   `DESeq2::vst()` transformation.
#'
#' @return a [data.frame()] with class probabilities (`prob.inflamed`,
#'   `prob.excluded`, `prob.desert`) and the most-likely class
#'   `predicted.class`. The `n_out_of_range` column indicates how many out of
#'   range features were in the sample. In case more than 6 features
#'   are out of range, the predictions will be `NA`s.
#' @export
predict_cd8ip <- function(df) {
  # load S3 method predict
  # equivalent of loadNamespace("glmnet")
  glmnet::cv.glmnet
  assertthat::assert_that(
    is.data.frame(df)
  )
  prepare_cache()
  m <- prepare_data_matrix(df)
  n_out_of_range <- get_n_out_of_range(m, cache_env$reference_ecdf)
  if (any(n_out_of_range >= 2)) {
    warning("Some samples have large number of feature values outside the ",
            "training range. Interpret results with caution.")
  }
  pred <- stats::predict(
    model_env$cd8ip_model,
    newx = m, type = "response"
  )[, , 1]

  colnames(pred) <- paste0("prob.", colnames(pred))
  pred <- as.data.frame(pred)

  pred$predicted.class <- stats::predict(
    model_env$cd8ip_model,
    newx = m, type = "class"
  )[, 1]

  # hide low-confidence predictions
  pred[n_out_of_range >= 3, ] <- NA

  pred$n_out_of_range <- n_out_of_range
  pred
}
