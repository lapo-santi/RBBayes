# Tutorial

Follow the RBBayes practicals for Bradley–Terry comparisons, shared-strength
BT–SBM models and Plackett–Luce rankings. Start with the setup below, then run
the examples in order alongside the presentation.

<div class="mb-3">
<a class="btn btn-primary me-2 mb-2" href="tutorial/RBBayes-tutorial.zip" download>Download course files</a>
<a class="btn btn-outline-primary mb-2" href="tutorial/RBBayes-tutorial.html">Read the worked tutorial</a>
</div>

The ZIP contains an RStudio Project, the editable tutorial, a plain R script
and a setup script. No real data need downloading: the package supplies the
datasets used in the practicals.

| File | Use it for |
|:--|:--|
| [R Markdown tutorial](tutorial/RBBayes-tutorial.Rmd){download="RBBayes-tutorial.Rmd"} | Read explanations and run the labelled chunks in RStudio. |
| [Plain R script](tutorial/RBBayes-tutorial.R){download="RBBayes-tutorial.R"} | Run the same analysis without R Markdown. |
| [Worked HTML](tutorial/RBBayes-tutorial.html) | Read all the code, figures and output in a browser. |
| [Setup script](tutorial/install-packages.R){download="install-packages.R"} | Install the packages before class. |

## 1. Install R and RStudio

Install [R from CRAN](https://cloud.r-project.org/) first; RBBayes requires
R 4.3 or later. Then install [RStudio Desktop](https://docs.posit.co/ide/user/download.html).
R runs the analysis; RStudio provides the editor, Console, plots and project tools.

If both are already installed, open RStudio and check the R version in its **Console**:

```r
R.version.string
```

## 2. Install the build tools

The GitHub installation below builds RBBayes from source, including its C++
code. Install the tools for your operating system before running it.

### Windows

Download [Rtools from CRAN](https://cran.r-project.org/bin/windows/Rtools/),
choosing the version listed for your R version. Use the installer's default
options, then restart RStudio. Rtools is a separate installer, not an R
package: do not use `install.packages("Rtools")`.

### macOS

Open the macOS **Terminal** application and run:

```sh
xcode-select --install
```

Complete the installation dialogue. The [Xcode Command Line Tools](https://developer.apple.com/documentation/xcode/installing-the-command-line-tools/)
are sufficient; the full Xcode application is not required. If the tools are
already installed, continue to the next step. This command belongs in
Terminal, not in the R Console.

### Linux

Install the C/C++ build tools and R development headers for your distribution.
For Ubuntu or Debian, a system administrator can install `build-essential`
and `r-base-dev`. Rtools and Xcode are for Windows and macOS respectively.

## 3. Open a project and check the working directory

1. Download the **course files ZIP** above and extract it. Move the extracted
   `RBBayes-tutorial` folder somewhere convenient, such as Documents.
2. Open `RBBayes-tutorial.Rproj` from that folder in RStudio.
3. In the RStudio Console, run:

```r
getwd()
list.files()
```

`getwd()` should end in `RBBayes-tutorial`. The file list should include
`RBBayes-tutorial.Rmd`, `RBBayes-tutorial.R` and `install-packages.R`.
An [RStudio Project sets the working directory to its own folder](https://docs.posit.co/ide/user/ide/guide/code/projects.html),
so paths in the examples refer to this project rather than the Downloads folder.

### If you downloaded individual files

Put them together in one folder. In RStudio select **File → New Project →
Existing Directory**, browse to that folder and choose **Create Project**.
Open the resulting `.Rproj` file when you return to the practicals.

### If you are working without an RStudio Project

Set the working directory explicitly to the folder containing your downloaded
files. For example, this creates a tutorial folder under your home directory:

```r
tutorial_dir <- file.path(path.expand("~"), "RBBayes-tutorial")
dir.create(tutorial_dir, recursive = TRUE, showWarnings = FALSE)
setwd(tutorial_dir)
getwd()
```

Move the downloaded `.Rmd` and `.R` files into the folder printed by `getwd()`.
Alternatively, use `setwd("/the/actual/path/to/your/tutorial-folder")`, replacing
the example path with your own. On Windows, forward slashes work in R paths,
for example `"C:/Users/your-name/Documents/RBBayes-tutorial"`.

## 4. Install the R packages

Run the following in the **RStudio Console**, once. An internet connection is
needed for installation. The same commands are in `install-packages.R`.

```r
# Run once in RStudio's R Console after installing the system build tools.
install.packages(c("remotes", "knitr", "rmarkdown"))
remotes::install_github("lapo-santi/RBBayes", upgrade = "never")
```

`remotes` installs the GitHub version of RBBayes and its required dependencies,
including `dplyr`, `tidyr` and `ggplot2`. `knitr` and `rmarkdown` let you knit
the editable tutorial. Accept a personal R library if R asks to create one.
Restart the R session after updating an already-loaded RBBayes installation.

For the diagnostic and partition-search sections used in class, also run:

```r
install.packages(c("coda", "bayesplot", "salso"))
```

`coda` provides MCMC diagnostics, `bayesplot` provides posterior plots, and
`salso` supplies the partition search. They are optional: the tutorial skips
unavailable diagnostic sections and uses a built-in partition search when
`salso` is absent. Match the packages used in class for matching results.

Check that the installed package has the teaching interface:

```r
library(RBBayes)
packageVersion("RBBayes")
stopifnot("simulate_data" %in% getNamespaceExports("RBBayes"))
```

## 5. Open the tutorial and run the code

In RStudio, choose **File → Open File** and select `RBBayes-tutorial.Rmd`
inside your project. It opens in the **Source** pane. Run the `packages`
chunk first, then continue through the labelled chunks from top to bottom.

Use the green Run button beside a chunk. To run selected lines, use **Run**
or **Ctrl+Enter** (**Cmd+Enter** on macOS). The **Console** shows text output;
figures appear inline or in the **Plots** pane, depending on your RStudio settings.
See [RStudio's code-execution guide](https://docs.posit.co/ide/user/ide/guide/code/execution.html).

The sequence matches the practical sessions:

1. **BT:** simulate individual strengths, prepare comparisons, fit and inspect
   normalised posterior strengths.
2. **BT–SBM:** after the block-model theory session, simulate shared block
   strengths and study the partition and its uncertainty; then analyse ATP data.
3. **PL:** prepare rankings and fit a Plackett–Luce model.

The complete tutorial includes the diagnostics and appendix. The short code
examples further down this page use the same chunks.

### If you prefer a plain R script

Open `RBBayes-tutorial.R` and run its named sections in order. It contains the
analysis code, with optional diagnostics guarded by package-availability
checks. To run the whole file and display its output from the Console:

```r
source("RBBayes-tutorial.R", echo = TRUE)
```

### Produce your own HTML output

With the `.Rmd` open, click **Knit**. Or run:

```r
rmarkdown::render("RBBayes-tutorial.Rmd")
```

The result, `RBBayes-tutorial.html`, is created beside your source file and
opens in a browser or viewer. Rendering runs the model fits again and can
take a few minutes. Results can vary with R/package versions and optional
packages; `sessionInfo()` at the end records your environment.

## BT: individual player strengths

Begin with one generating strength per player. No block model is needed here.

```r
lambda <- exp(seq(log(12), 0, length.out = 20)) # One strength per player.
edges <- simulate_data(
  model = "bt", latent_strength = lambda,
  item_labels = paste("Player", seq_along(lambda)),
  matches_per_pair = 20, seed = 101, format = "edgelist"
)
edges |> slice_head(n = 6) |> knitr::kable()

tennis <- as_bt_data(edges, format = "edgelist")
tennis

bt_fit <- fit_model(
  tennis,
  bt_model(shape_lambda = 2),
  mcmc_control(iter = 4000, warmup = 2000, seed = 12)
)
bt_fit
summary(bt_fit)

bt_strength <- strength_summary(bt_fit)
plot_strength_summary(bt_fit)

```

## BT–SBM: shared block strengths

Introduce generating blocks after the BT–SBM theory session. Block sizes may
be equal or different; the comments show both forms.

```r
edges_sbm <- simulate_data(
  model = "bt-sbm",
  n_blocks = 4, latent_strength = c(12, 6, 2, 1), # One strength per block.
  players_per_block = 5, # Unequal sizes are also allowed: c(3, 4, 5, 8).
  matches_per_pair = 20, seed = 101, format = "edgelist"
)
tennis_sbm <- as_bt_data(edges_sbm, format = "edgelist")
truth <- attr(edges_sbm, "truth")
edges_sbm |> slice_head(n = 6) |> knitr::kable()

sbm_model <- bt_sbm_model(
  shape_lambda = 2,
  item_clustering = gnedin_prior(gnedin_hyper = 0.5)
)
sbm_model
sbm_fit <- fit_model(tennis_sbm, sbm_model,
                     mcmc_control(iter = 10000, warmup = 5000, seed = 2))
summary(sbm_fit)

posterior_K_table(sbm_fit)

```

## PL: ranked observations

The same fitting interface also handles rankings.

```r
sushi <- sushi_toy(n_rankings = 40, rank_length = 5, seed = 3)
sushi
head(sushi$rankings, 3)
plot_ranking_positions(sushi)

pl_fit <- fit_model(sushi, pl_model(shape_lambda = 1),
                    mcmc_control(iter = 2000, warmup = 1000, seed = 4))
summary(pl_fit)

plot_strength_summary(pl_fit)

```

Read the [complete worked tutorial](tutorial/RBBayes-tutorial.html) for
posterior uncertainty, MCMC diagnostics, the ATP example and exercises.

## If something does not work

| What you see | What to check |
|:--|:--|
| `could not find function "simulate_data"` | Restart R, reinstall RBBayes from GitHub, then run `library(RBBayes)`. |
| A compiler error mentioning `g++`, `make` or `clang++` | Complete the build-tools step for your operating system. |
| `there is no package called ...` | Install that package in the R Console, then rerun the `packages` chunk. |
| `cannot open file` or `file not found` | Check `getwd()` and `list.files()`; open the tutorial's `.Rproj` or choose the correct folder. |
| An object such as `tennis` or `bt_fit` is missing | Run the preceding tutorial chunks first. |
| `file.copy()` returns `FALSE` | The destination may already exist or be unwritable. Use the direct downloads above or a fresh project folder; preserve your edited copy. |

## Find the copy bundled with the package

The website downloads do not require searching your R library. If you already
installed RBBayes, the package also contains the tutorial. Installation stores
it inside the package; it does not create a Desktop file or open a Source tab.

Read that installed HTML with:

```r
browseURL(system.file("tutorial", "RBBayes-tutorial.html",
                      package = "RBBayes", mustWork = TRUE))
```

Copy its editable source into your current working directory and open it:

```r
source_file <- system.file("tutorial", "RBBayes-tutorial.Rmd",
                           package = "RBBayes", mustWork = TRUE)
if (!file.exists("RBBayes-tutorial.Rmd")) {
  stopifnot(file.copy(source_file, "RBBayes-tutorial.Rmd"))
}
file.edit("RBBayes-tutorial.Rmd")
```

An existing file is kept. Use a fresh folder if you need a new copy without
replacing your work. This bundled file is separate from the package's
registered vignettes, so it does not appear in `vignette()` listings.
