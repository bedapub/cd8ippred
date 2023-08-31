
<!-- README.md is generated from README.Rmd. Please edit that file -->

# cd8ippred

<!-- badges: start -->

[![R-CMD-check](https://github.com/bedapub/cd8ippred/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/bedapub/cd8ippred/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

This package contains an ElasticNet model which can use RNA-Seq data to
predict immune phenotypes of the samples.

**Warning**: RNA-Seq expression values can be strongly affected by both
the experimental protocol and the data processing. Before running the
prediction make sure that your data is comparable to data used in the
training dataset. A simple way to check is to compare your data to
`load_simulated_counts()`.

## Installation

You can install the development version of cd8ippred like so:

``` r
remotes::install_github("bedapub/cd8ippred")
```

## Usage example

See
[here](https://bedapub.github.io/cd8ippred/articles/cd8_ip_predict.html).
