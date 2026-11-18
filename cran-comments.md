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
have been corrected and a fresh run is being launched.
See RELEASE-CHECKS.md for run links.

## URL check

DOI 10.1080/10618600.2012.638220 returned HTTP 403 during automated checking.
