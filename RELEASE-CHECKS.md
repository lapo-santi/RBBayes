# RBBayes 1.0.0 release checks

## Completed preparation

- Updated the package version and organised NEWS.md under the release
  heading.
- Corrected the website URL to <https://lapo-santi.github.io/RBBayes/>.
- Expanded MCMC in DESCRIPTION, standardised the method citation, and
  added the copyright-holder role.
- Removed all dontrun wrappers; examples now define their own inputs.
- Added examples for public functions, guarded optional coda/loo
  examples, and suppressed help pages for internal helpers.
- All generated help pages have value and examples sections.
- Local tests: 305 passed, no failures or skips; two salso cluster-limit
  warnings.
- Excluded website output and development documents from the source
  package.

## Outstanding release evidence

- Full local check, Windows development check and R-hub results: see
  final run records below.
- URL checker: the DOI 10.1080/10618600.2012.638220 returned HTTP 403;
  retain the correct scholarly identifier rather than inventing a
  replacement.
- Licensing: GPL (\>= 3) is declared. No original Sushi Preference
  Dataset rows are redistributed. ATP data cite Jeff Sackmann, but the
  upstream repository was unavailable when checked; redistribution terms
  still need verification. The NFL and orthodontics examples transcribe
  published tables; citation alone does not establish redistribution
  permission. The provenance/licensing of inst/extdata/resGN_demo.rds
  also needs confirmation.
- A complete no-Suggests run has not yet been performed.

CRAN submission, publication of the draft blog post, a GitHub release
and the post-release development version remain pending successful
checks and resolution of licensing questions.
