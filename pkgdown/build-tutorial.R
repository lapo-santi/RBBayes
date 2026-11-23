# Prepare the student page and downloads from the canonical tutorial.
# Run from the package root before pkgdown::build_site(). No student setup
# commands are executed here; installation and editor-launch chunks are skipped.
main <- function() {
  stopifnot(file.exists("DESCRIPTION"), file.exists("inst/tutorial/RBBayes-tutorial.Rmd"))
  source <- "inst/tutorial/RBBayes-tutorial.Rmd"
  assets <- "pkgdown/assets/tutorial"
  dir.create(assets, recursive = TRUE, showWarnings = FALSE)

  lines <- readLines(source, warn = FALSE)
  starts <- grep("^```\\{r[ ,]", lines)
  chunks <- list()
  options <- list()
  for (start in starts) {
    header <- sub("^```\\{r[ ,]+", "", lines[start])
    header <- sub("\\}$", "", header)
    label <- trimws(strsplit(header, ",", fixed = TRUE)[[1L]][1L])
    following <- seq.int(start + 1L, length(lines))
    end <- following[which(trimws(lines[following]) == "```")[1L]]
    chunks[[label]] <- lines[seq.int(start + 1L, end - 1L)]
    options[[label]] <- header
  }

  # Publish current output rather than trusting a potentially stale checked-in HTML.
  rmarkdown::render(source, output_dir = normalizePath("inst/tutorial"),
                    envir = new.env(parent = globalenv()), quiet = TRUE)
  html <- "inst/tutorial/RBBayes-tutorial.html"
  writeLines(sub("[[:blank:]]+$", "", readLines(html, warn = FALSE)), html)
  stopifnot(file.copy(source, file.path(assets, "RBBayes-tutorial.Rmd"), overwrite = TRUE),
            file.copy("inst/tutorial/RBBayes-tutorial.html",
                      file.path(assets, "RBBayes-tutorial.html"), overwrite = TRUE))

  # A plain script keeps the labelled analysis sections and optional-package
  # guards. It never automatically installs packages, opens a browser or edits files.
  script <- c(
    "# RBBayes practicals: BT, BT-SBM and PL",
    "# Setup and downloads: https://lapo-santi.github.io/RBBayes/tutorial.html",
    "# Open RBBayes-tutorial.Rproj, install packages, then run sections in order.",
    "# To display all output when sourcing: source('RBBayes-tutorial.R', echo = TRUE)", ""
  )
  skip <- c("setup", "install", "tutorial-read", "tutorial-path")
  for (label in setdiff(names(chunks), skip)) {
    code <- chunks[[label]]
    header <- options[[label]]
    if (grepl("eval\\s*=\\s*FALSE", header)) next
    script <- c(script, paste0("# ---- ", label, " ----"))
    if (grepl("eval\\s*=\\s*has_coda", header)) {
      code <- c("if (has_coda) {", paste0("  ", code), "}")
    } else if (grepl("eval\\s*=\\s*has_bayesplot", header)) {
      # R prints only the final value of an if block; print both optional plots.
      plot_calls <- startsWith(code, "bayesplot::")
      code[plot_calls] <- paste0("print(", code[plot_calls], ")")
      code <- c("if (has_bayesplot) {", paste0("  ", code), "}")
    }
    script <- c(script, code, "")
  }
  parse(text = script)
  writeLines(script, file.path(assets, "RBBayes-tutorial.R"))

  install <- c(
    "# Run once in RStudio's R Console after installing the system build tools.",
    'install.packages(c("remotes", "knitr", "rmarkdown"))',
    'remotes::install_github("lapo-santi/RBBayes", upgrade = "never")', "",
    "# Recommended for the diagnostic and partition-search sections:",
    'install.packages(c("coda", "bayesplot", "salso"))'
  )
  writeLines(install, file.path(assets, "install-packages.R"))

  # The project file makes the extracted folder the student's working directory.
  stage <- tempfile("rbbayes-student-")
  project <- file.path(stage, "RBBayes-tutorial")
  dir.create(project, recursive = TRUE)
  student_files <- c("RBBayes-tutorial.Rmd", "RBBayes-tutorial.R", "install-packages.R")
  stopifnot(all(file.copy(file.path(assets, student_files), project)))
  writeLines(c("Version: 1.0", "", "RestoreWorkspace: No", "SaveWorkspace: No",
               "AlwaysSaveHistory: Default", "", "Encoding: UTF-8",
               "UseSpacesForTab: Yes", "NumSpacesForTab: 2"),
             file.path(project, "RBBayes-tutorial.Rproj"))
  writeLines(c("RBBayes course files", "",
               "1. Install R and RStudio, plus Rtools (Windows) or Xcode Command Line Tools (macOS).",
               "2. Extract this folder and open RBBayes-tutorial.Rproj in RStudio.",
               "3. Run getwd() in the R Console: it should show this extracted folder.",
               "4. Open install-packages.R and run its commands once, with internet access.",
               "5. Open RBBayes-tutorial.Rmd and run its labelled chunks in order.",
               "   Or open RBBayes-tutorial.R for the plain-script version.", "",
               "Full setup, worked output and troubleshooting:",
               "https://lapo-santi.github.io/RBBayes/tutorial.html"),
             file.path(project, "README.txt"))
  zipfile <- file.path(normalizePath(assets), "RBBayes-tutorial.zip")
  if (file.exists(zipfile)) unlink(zipfile)
  previous <- getwd()
  on.exit(setwd(previous), add = TRUE)
  setwd(stage)
  utils::zip(zipfile, "RBBayes-tutorial", flags = "-qr9X")
  setwd(previous)
  stopifnot(file.exists(zipfile))

  fenced <- function(code) paste(c("```r", code, "```"), collapse = "\n")
  combine <- function(labels) unlist(lapply(labels, function(label) c(chunks[[label]], "")))
  replacements <- list(
    "<!-- INSTALL_CODE -->" = fenced(install[1:3]),
    "<!-- BT_CODE -->" = fenced(combine(c("simulate", "as-bt-data", "fit-bt", "bt-strength"))),
    "<!-- BTSBM_CODE -->" = fenced(combine(c("simulate-sbm", "fit-sbm", "K-table"))),
    "<!-- PL_CODE -->" = fenced(combine(c("pl-data", "pl-fit", "pl-strength")))
  )
  page <- paste(readLines("pkgdown/tutorial-page.md", warn = FALSE), collapse = "\n")
  for (marker in names(replacements)) {
    parts <- strsplit(page, marker, fixed = TRUE)[[1L]]
    stopifnot(length(parts) == 2L)
    page <- paste0(parts[1L], replacements[[marker]], parts[2L])
  }
  writeLines(page, "tutorial.md")
  cat("Prepared tutorial.html source, student downloads and RStudio starter ZIP.\n")
}

main()
