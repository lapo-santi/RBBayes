# RBBayes 1.0.0 release checks

## Completed preparation

- Updated the package version and organised NEWS.md under the release heading.
- Corrected the website URL to https://lapo-santi.github.io/RBBayes/.
- Expanded MCMC in DESCRIPTION, standardised the method citation, and added the copyright-holder role.
- Removed all dontrun wrappers; examples now define their own inputs.
- Added examples for public functions, guarded optional coda/loo examples, and suppressed help pages for internal helpers.
- All generated help pages have value and examples sections.
- Local tests: 305 passed, no failures or skips; two salso cluster-limit warnings.
- Excluded website output and development documents from the source package.

## Outstanding release evidence

- Full local check, Windows development check and R-hub results: see final run records below.
- URL checker: the DOI 10.1080/10618600.2012.638220 returned HTTP 403; retain the correct scholarly identifier rather than inventing a replacement.
- Licensing: GPL (>= 3) is declared. No original Sushi Preference Dataset rows are redistributed. ATP data cite Jeff Sackmann, but the upstream repository was unavailable when checked; redistribution terms still need verification. The NFL and orthodontics examples transcribe published tables; citation alone does not establish redistribution permission. The provenance/licensing of inst/extdata/resGN_demo.rds also needs confirmation.
- R-hub no-Suggests check launched; outcome pending.

CRAN submission, publication of the draft blog post, a GitHub release and the post-release development version remain pending successful checks and resolution of licensing questions.

## Run records (18 November 2026)

- Prepared source commit: c3a56cb.
- Full local `devtools::check(remote = TRUE, manual = TRUE)` with `--run-donttest`: **0 errors, 1 warning, 2 notes**. Examples, tests, vignettes, PDF and HTML manuals passed.
- Installation warning: the local R header requests `-Wfixed-enum-extension`, which Apple clang does not recognise. This is a local R/compiler compatibility warning.
- Notes: new submission; unable to verify current time.
- Windows development check: source successfully uploaded to win-builder; results sent by that service to the maintainer email.
- R-hub Linux, Windows and macOS: https://github.com/lapo-santi/RBBayes/actions/runs/44263199866
- R-hub without suggested packages: https://github.com/lapo-santi/RBBayes/actions/runs/44263312073
- R-hub runs were still in progress when these records were written; they are not recorded as passing.

## Remote results and no-Suggests correction

- Standard R-hub Linux, Windows and macOS jobs all passed.
- Win-builder completed with 0 errors, 0 warnings and 2 notes: new submission (including spelling flags for author names and psychometrics), and deprecated `.Dim` usage.
- The original no-Suggests run failed because the plotting example used optional coda and vignette rebuilding could not load rmarkdown.
- Corrected the example with an explicit coda prerequisite, added a clear runtime dependency error, declared rmarkdown as a vignette builder, and removed the redundant deprecated `.Dim` assignment.
- After correction: 305 local tests passed and all examples ran; two existing salso test warnings remain.

- Corrected no-Suggests rerun **passed**: https://github.com/lapo-santi/RBBayes/actions/runs/44265903706 (source commit 8e206f9). This supersedes the earlier failed run and pending status.
