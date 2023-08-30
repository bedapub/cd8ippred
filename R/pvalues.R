#' Computes a two-sided p-value from a one-sided p-value.
#'
#' @param p a vector of p-values
#'
#' @return a vector of two-sided p-values
two_sided_p <- function(p) 2 * pmin(p, 1 - p)

#' Given a matrix of observations, computes p-values for out of range features.
#'
#' For every observation the function will compute it's two-sided p-value
#' based on [stats::ecdf()]. This will tell you how unlikely is it to observe
#' such a value given the reference distribution.Then it will use Holm's method to correct
#' p-values for every observation and return number of significantly
#' out-of-range features.
#'
#' @param obs a matrix of observation, where every column is a variable
#' and every row is an observation
#' @param reference either a [data.frame] with reference variable distributions
#'   or a [list] of [stats::ecdf] functions computed based on reference
#'   distribution. If `NULL`, [cd8ip_features_distribution] is used.
#'
#' @return a [data.frame] of p-values
#' @export
ecdf_pvals <- function(obs, reference = NULL) {
  if (is.null(reference)) {
    prepare_cache()
    refernce <- cache_env$reference_ecdf
  }
  if (is.data.frame(reference)) {
    reference <- lapply(reference, stats::ecdf)
  }
  n <- environment(reference[[1]])$nobs

  p_df <- lapply(
    names(reference),
    \(feature) reference[[feature]](obs[, feature, drop = TRUE])
  ) |>
    lapply(two_sided_p) |>
    # a p-value cannot be less then 1/n
    # when you have only n observations
    lapply(pmax, 1 / n) |>
    as.data.frame()

  p_df
}

#' Given a matrix of observations, computes how many features are out of range.
#'
#' See [ecdf_pvals()] for details. It will use Holm's method to correct
#' p-values for every observation and return number of significantly
#' out-of-range features.
#'
#' @param obs a matrix of observation, where every column is a variable
#' and every row is an observation
#' @param reference either a [data.frame] with reference variable distributions
#'   or a [list] of [stats::ecdf] functions computed based on reference
#'   distribution. If `NULL`, [cd8ip_features_distribution] is used.
#' @param thr p-value threshold
#'
#' @return a vector with number of out-of-range features for every sample
#' @export
get_n_out_of_range <- function(obs, reference, thr = 0.01) {
  p_df <- ecdf_pvals(obs, reference)
  colSums(
    apply(p_df, 1, stats::p.adjust, "holm") < thr
  )
}
