## Resubmission

This resubmission addresses the incoming checks dated 18 November 2026:

* Rebuilt the software-paper PDF vignette from its current source, replacing
  the stale URL https://github.com/laposanti/BTSBM with
  https://github.com/lapo-santi/RBBayes.
* Replaced the README relative link to IMPLEMENTATION_STATUS.md (a development
  document excluded from the source package) with its absolute GitHub URL.
* Friel, Santi and Plackett are surnames. Psychometrics is the intended
  technical term. These spelling flags require no correction.
* RBBayes is a new submission.

## Submission status

Release candidate only: do not submit until outstanding data-licensing questions
in RELEASE-CHECKS.md and remote check outcomes have been resolved.

## Local R CMD check results

R 4.5.2, macOS arm64; remote checks, manual and donttest examples enabled.

0 errors | 1 warning | 2 notes

* The installation warning is from R_ext/Boolean.h: Apple clang does not
  recognise the warning group -Wfixed-enum-extension.
* This is a new submission.
* The check could not verify current time.
* Examples, tests, vignettes and PDF/HTML manuals passed.

## Remote checks

Windows development check: 0 errors, 0 warnings, 2 notes (new submission
and deprecated .Dim usage, now corrected).
R-hub Linux, Windows and macOS checks passed. The initial no-Suggests check
failed on optional coda and vignette-builder rmarkdown prerequisites; these
have been corrected and the fresh no-Suggests run passed:
https://github.com/lapo-santi/RBBayes/actions/runs/44265903706
See RELEASE-CHECKS.md for run links.

## URL check

DOI 10.1080/10618600.2012.638220 returned HTTP 403 during automated checking.
The Kaggle ATP source page returned HTTP 404 to the URL checker, although
its public dataset metadata API was accessible during provenance review.
