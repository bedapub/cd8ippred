if (Sys.getenv("RENV_DIR") == "") {
  # do use renv during GRAN builds, due to a conflict
  source("renv/activate.R")
}

.CIaddGranPkg <- function() {
  pkg_name <- Sys.getenv("CI_PROJECT_NAME")
  env <- Sys.getenv("GRAN_ENV")
  if (Sys.getenv("GRAN_REBUILD") == "TRUE") {
    rebuild <- TRUE
  } else {
    rebuild <- FALSE
  }
  username <- Sys.getenv("GRAN_ID")
  api_token <- Sys.getenv("GRAN_TOKEN")
  package_url <- paste0(
    "https://token:",
    Sys.getenv("GITLAB_PROJECT_TOKEN"),
    "@",
    Sys.getenv("CI_SERVER_HOST"), ":", Sys.getenv("CI_SERVER_PORT"), "/",
    Sys.getenv("CI_PROJECT_PATH")
  )
  branch <- Sys.getenv("GRAN_BRANCH")
  if (rebuild && pkg_name %in% granny::availPkgs(env)[, "Package"]) {
    # if package is already in GRAN, but needs rebuilding
    cat("rebuilding", pkg_name, "\n")
    granny::rebuildPkg(
      pkg_name = pkg_name,
      username = username,
      api_token = api_token,
      env = env
    )
  } else {
    cat("adding", package_url, branch, "\n")
    granny::addPkg(
      package_url = package_url,
      username = username,
      api_token = api_token,
      branch = branch,
      replace = TRUE,
      env = env
    )
  }
}
