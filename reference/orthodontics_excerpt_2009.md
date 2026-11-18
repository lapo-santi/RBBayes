# Orthodontics ranking-and-covariate excerpt

An anonymised, published excerpt from Tables 3 and 4 in Li, Yi and Liu
(2022): 15 experts rank two non-overlapping groups (A and H) of 12
cases, with 11 PAR-index covariates for every case. The full 108-case
clinical dataset is not provided by the article, so this deliberately
exposes only the reproducible table excerpt.

## Usage

``` r
orthodontics_excerpt_2009()
```

## Value

A list with separate complete within-group ranking-position matrices, a
24-case covariate table, and source metadata. Lower values are better
ranks in each `ranking_positions` matrix.

## References

Li, X., Yi, D. and Liu, J. S. (2022). Bayesian analysis of rank data
with covariates and heterogeneous rankers. *Statistical Science*, 37(1),
1–23. [doi:10.1214/20-STS818](https://doi.org/10.1214/20-STS818)

## Examples

``` r
head(orthodontics_excerpt_2009())
#> $ranking_positions
#> $ranking_positions$A
#>     Expert_01 Expert_02 Expert_03 Expert_04 Expert_05 Expert_06 Expert_07
#> A1          1         3         5         2         4         1         1
#> A2         11         5        10         9         9        12         9
#> A3          6        10         8        11        11         8        11
#> A4          3         2         4         3         1         4         2
#> A5          9         4         7         5         6         6         6
#> A6         10         9         3         6         5        11         5
#> A7          8         8        11         7        12         9        12
#> A8          4         1         1         4         3         2         4
#> A9          2        12         9         8         8         5         7
#> A10         7        11         6        10        10         7         8
#> A11         5         7         2         1         2         3        10
#> A12        12         6        12        12         7        10         3
#>     Expert_08 Expert_09 Expert_10 Expert_11 Expert_12 Expert_13 Expert_14
#> A1          2         5         5        10         8         2         4
#> A2          7        11        12         4         7         5         6
#> A3          8        12         9         6        11        12        11
#> A4         10         1         6         8         2         1         1
#> A5          5         3         3         2         5        11         7
#> A6          9         6         7         3         1         6         8
#> A7         11         8        10         7         9         8        12
#> A8          4         2         1         1         6         3         2
#> A9          3         9         8        11        12         7         5
#> A10         6         7        11         9         3        10         9
#> A11         1        10         2         5         4         9         3
#> A12        12         4         4        12        10         4        10
#>     Expert_15
#> A1          2
#> A2          5
#> A3         11
#> A4          1
#> A5          9
#> A6          7
#> A7         12
#> A8          6
#> A9          8
#> A10         4
#> A11         3
#> A12        10
#> 
#> $ranking_positions$H
#>     Expert_01 Expert_02 Expert_03 Expert_04 Expert_05 Expert_06 Expert_07
#> H1          4         8         5         8         4        11         4
#> H2          1         2         4         5         2         7         2
#> H3          2         3         2         2         1         4         1
#> H4          3         4         3         4         3         3         3
#> H5         12        12        12        12        12        12        12
#> H6          6         5         1         1         6         2         7
#> H7          8        11         6         9        10         9        11
#> H8         11         6         8         3         7         1         6
#> H9          5         7        10        11         5        10        10
#> H10        10         9         9         7         9         5         5
#> H11         9        10         7        10        11         8         9
#> H12         7         1        11         6         8         6         8
#>     Expert_08 Expert_09 Expert_10 Expert_11 Expert_12 Expert_13 Expert_14
#> H1          3         8         9         4         4         3        11
#> H2          2         1         2         1         1         2         2
#> H3          1         2         1         6         5         5         3
#> H4          4         3         4         7         7         1         1
#> H5         12        12        12        10        12        12         9
#> H6          5         7         3         5         3         7         4
#> H7         11        10        11        11        11         6         7
#> H8          6         6         6         8         8         4         8
#> H9         10        11         8         2         6        10        12
#> H10         7         5         7        12         9        11         5
#> H11         8         9        10         9        10         8         6
#> H12         9         4         5         3         2         9        10
#>     Expert_15
#> H1          8
#> H2          1
#> H3          3
#> H4          2
#> H5         12
#> H6          6
#> H7         10
#> H8          9
#> H9          4
#> H10         7
#> H11        11
#> H12         5
#> 
#> 
#> $item_covariates
#>     upper_right_segment upper_anterior_segment upper_left_segment
#> A1                 1.56                   0.22               1.44
#> A2                 1.33                   0.22               1.00
#> A3                 1.22                   0.33               1.00
#> A4                 0.00                   0.00               0.11
#> A5                 1.33                   0.22               0.78
#> A6                 1.11                   0.56               1.78
#> A7                 1.22                   0.67               1.89
#> A8                 1.44                   0.22               1.56
#> A9                 1.11                   0.33               1.22
#> A10                0.67                   0.11               0.89
#> A11                0.67                   0.89               1.00
#> A12                0.67                   0.11               0.22
#> H1                 0.67                   0.22               0.78
#> H2                 1.56                   0.56               0.22
#> H3                 0.56                   0.22               1.00
#> H4                 0.56                   0.22               0.67
#> H5                 1.22                   0.33               0.67
#> H6                 0.56                   0.11               1.33
#> H7                 0.56                   0.33               0.78
#> H8                 0.78                   0.22               1.56
#> H9                 0.44                   0.22               1.00
#> H10                1.11                   0.33               1.78
#> H11                0.67                   0.67               1.00
#> H12                1.22                   0.78               1.00
#>     lower_right_segment lower_anterior_segment lower_left_segment
#> A1                 1.00                   0.00               1.22
#> A2                 0.33                   0.00               0.33
#> A3                 0.67                   0.11               1.44
#> A4                 1.78                   0.22               1.89
#> A5                 1.22                   0.11               1.67
#> A6                 0.89                   0.22               0.89
#> A7                 0.89                   0.11               1.00
#> A8                 0.89                   0.22               0.56
#> A9                 0.44                   0.00               1.00
#> A10                0.11                   0.00               0.00
#> A11                0.67                   1.33               2.44
#> A12                1.00                   0.00               0.56
#> H1                 1.67                   0.56               0.78
#> H2                 0.44                   0.00               0.11
#> H3                 0.33                   0.11               0.78
#> H4                 0.44                   0.11               0.44
#> H5                 0.44                   0.00               0.33
#> H6                 1.22                   0.00               1.33
#> H7                 0.78                   0.00               1.22
#> H8                 0.89                   0.00               0.33
#> H9                 0.00                   0.11               0.11
#> H10                0.22                   0.22               0.33
#> H11                0.67                   0.56               0.56
#> H12                0.33                   0.33               0.67
#>     right_buccal_occlusion left_buccal_occlusion overjet overbite centerline
#> A1                    0.00                  0.33    0.00     0.00       0.00
#> A2                    0.00                  0.33    0.00     0.33       0.00
#> A3                    0.00                  0.00    0.00     0.00       0.00
#> A4                    0.33                  0.67    0.00     0.00       0.00
#> A5                    0.33                  0.00    0.78     0.00       0.00
#> A6                    0.67                  1.00    0.78     0.00       0.00
#> A7                    0.67                  0.33    0.67     0.00       0.00
#> A8                    2.00                  2.00    0.00     0.00       0.00
#> A9                    2.33                  0.67    0.00     0.00       0.00
#> A10                   0.67                  1.00    0.00     0.67       0.00
#> A11                   1.33                  1.00    0.11     0.00       0.67
#> A12                   0.33                  1.33    0.00     0.33       0.00
#> H1                    0.67                  0.00    0.78     0.00       0.00
#> H2                    0.00                  0.67    0.00     0.00       0.00
#> H3                    0.00                  0.67    0.00     0.33       0.00
#> H4                    0.67                  1.00    0.00     0.00       0.00
#> H5                    1.00                  0.67    0.33     0.00       0.00
#> H6                    1.00                  0.67    0.22     0.00       0.00
#> H7                    2.00                  1.33    0.44     0.33       0.00
#> H8                    1.67                  2.00    0.00     0.00       0.00
#> H9                    1.00                  0.00    0.00     0.00       0.00
#> H10                   1.33                  1.67    0.00     0.00       0.00
#> H11                   1.00                  1.00    0.11     0.00       0.00
#> H12                   1.00                  0.67    0.56     0.00       0.00
#> 
#> $item_group
#>  [1] "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "A" "H" "H" "H" "H" "H" "H" "H"
#> [20] "H" "H" "H" "H" "H"
#> 
#> $ranking_labels
#>  [1] "Expert_01" "Expert_02" "Expert_03" "Expert_04" "Expert_05" "Expert_06"
#>  [7] "Expert_07" "Expert_08" "Expert_09" "Expert_10" "Expert_11" "Expert_12"
#> [13] "Expert_13" "Expert_14" "Expert_15"
#> 
#> $source
#> $source$citation
#> [1] "Li, Yi and Liu (2022), Tables 3--4"
#> 
#> $source$note
#> [1] "Published 24-case excerpt only; not the full clinical dataset."
#> 
#> 
```
