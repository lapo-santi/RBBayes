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

<!-- INSTALL_CODE -->

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
stopifnot(all(c("simulate_data", "pairwise_summary") %in%
              getNamespaceExports("RBBayes")))
```

