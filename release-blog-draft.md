# Introducing RBBayes 1.0.0

Draft for publication after CRAN acceptance.

RBBayes provides Bayesian Bradley–Terry models for paired comparisons
and Plackett–Luce models for rankings. Latent item blocks allow items
with similar strengths to share information, while ranking mixtures
accommodate differences between groups of rankers.

The package brings these models together through a common interface:
prepare the observations, specify a model and its priors, and fit it
with
[`fit_model()`](https://lapo-santi.github.io/RBBayes/reference/fit_model.md).
Posterior summaries and plots describe item strengths, uncertainty in
rankings and evidence for latent groups. Fitted objects can also be
converted for use with coda and bayesplot.

The first release includes reproducible teaching datasets and tutorials.
Short documentation examples demonstrate the interface; substantive
analyses require longer runs and assessment of convergence and Monte
Carlo uncertainty.

The Bradley–Terry stochastic block model is described by Santi and Friel
(2026), <doi:10.1214/26-AOAS2193>.

Documentation: <https://lapo-santi.github.io/RBBayes/> Source code:
<https://github.com/lapo-santi/RBBayes>

Before publication: add the confirmed CRAN package link and installation
instructions, and incorporate the final release-check results.
