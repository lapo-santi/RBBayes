# NFL quarterback rankings with item covariates

A faithful transcription of Tables 1 and 2 in Li, Yi and Liu (2022). It
records the week-12, 2014 rankings of 24 quarterbacks by 13 experts and
the 11 player statistics available before that week. Missing entries in
`ranking_positions` mean that an expert did not include that player in
the expert's top-24 list. Lower values are better ranks.

## Usage

``` r
nfl_quarterbacks_2014()
```

## Value

A list with `ranking_positions` (items by experts), `item_covariates`
(items by covariates), and source metadata. The two tabular components
share row names and can be used as a realistic fixture for future
covariate-assisted ranking models.

## Details

The source websites in the article are dynamic historical sports
websites. Keeping this small, cited transcription makes the published
example reproducible without presenting it as a live data download.

## References

Li, X., Yi, D. and Liu, J. S. (2022). Bayesian analysis of rank data
with covariates and heterogeneous rankers. *Statistical Science*, 37(1),
1–23. [doi:10.1214/20-STS818](https://doi.org/10.1214/20-STS818)

## Examples

``` r
head(nfl_quarterbacks_2014())
#> $ranking_positions
#>                    Expert_01 Expert_02 Expert_03 Expert_04 Expert_05 Expert_06
#> Andrew Luck                1         1         1         3         3         1
#> Aaron Rodgers              2         3         4         2         1         2
#> Peyton Manning             3         2         5         4         2         3
#> Tom Brady                  4         7         3         5         4         5
#> Tony Romo                  9         5         6         1         5         4
#> Drew Brees                10         4         2         8         9         7
#> Ben Roethlisberger         6         8         7         7         7         6
#> Ryan Tannehill             5         6        13         6        11         8
#> Matthew Stafford           8         9        11        13         8         9
#> Mark Sanchez              22        10         9         9        16        10
#> Russell Wilson            12        13        17        10        10        12
#> Philip Rivers              7        14        15        20         6        17
#> Cam Newton                18        12         8        17        19        11
#> Eli Manning               17        NA        18        19        14        19
#> Matt Ryan                 21        17        19        15        20        15
#> Andy Dalton               15        NA        14        NA        17        14
#> Alex Smith                16        11        21        16        18        18
#> Colin Kaepernick          11        16        16        11        12        16
#> Joe Flacco                24        15        12        14        24        13
#> Jay Cutler                13        18        10        12        13        21
#> Josh McCown               14        19        22        18        15        22
#> Drew Stanton              20        20        NA        22        22        20
#> Teddy Bridgewater         23        21        20        21        23        23
#> Brian Hoyer               19        NA        NA        NA        21        24
#>                    Expert_07 Expert_08 Expert_09 Expert_10 Expert_11 Expert_12
#> Andrew Luck                1         1         1         1         1         1
#> Aaron Rodgers              3         3         2         2         3         4
#> Peyton Manning             2         2         3         4         4         2
#> Tom Brady                  4         6         4         3         6         8
#> Tony Romo                  5         4         5         5         7         6
#> Drew Brees                 7         5         7         6         2         3
#> Ben Roethlisberger         6        10         6         7         5         7
#> Ryan Tannehill             8         7         9         9         8         5
#> Matthew Stafford           9         8         8         8         9         9
#> Mark Sanchez              10         9        10        10        12        12
#> Russell Wilson            11        12        11        12        11        14
#> Philip Rivers             17        11        16        15        14        10
#> Cam Newton                14        14        14        16        21        13
#> Eli Manning               12        13        12        13        16        23
#> Matt Ryan                 15        15        13        11        20        21
#> Andy Dalton               16        20        15        14        19        22
#> Alex Smith                18        16        20        21        13        11
#> Colin Kaepernick          21        17        19        18        22        16
#> Joe Flacco                13        18        18        20        15        15
#> Jay Cutler                19        19        17        17        23        20
#> Josh McCown               22        21        21        19        18        17
#> Drew Stanton              20        23        22        22        10        19
#> Teddy Bridgewater         23        22        23        24        17        18
#> Brian Hoyer               24        24        24        23        24        24
#>                    Expert_13
#> Andrew Luck                1
#> Aaron Rodgers              3
#> Peyton Manning             2
#> Tom Brady                  4
#> Tony Romo                  6
#> Drew Brees                 5
#> Ben Roethlisberger         7
#> Ryan Tannehill             8
#> Matthew Stafford           9
#> Mark Sanchez              12
#> Russell Wilson            15
#> Philip Rivers             10
#> Cam Newton                14
#> Eli Manning               11
#> Matt Ryan                 13
#> Andy Dalton               16
#> Alex Smith                17
#> Colin Kaepernick          21
#> Joe Flacco                19
#> Jay Cutler                18
#> Josh McCown               23
#> Drew Stanton              20
#> Teddy Bridgewater         22
#> Brian Hoyer               24
#> 
#> $item_covariates
#>                    games_played pass_completion_pct pass_attempts_per_game
#> Andrew Luck                  11                63.4                   42.2
#> Aaron Rodgers                11                66.7                   31.1
#> Peyton Manning               11                68.1                   40.2
#> Tom Brady                    11                65.0                   37.9
#> Tony Romo                    10                68.8                   29.5
#> Drew Brees                   11                70.3                   42.0
#> Ben Roethlisberger           11                68.3                   37.5
#> Ryan Tannehill               11                66.1                   36.4
#> Matthew Stafford             11                58.8                   37.7
#> Mark Sanchez                  4                62.3                   36.5
#> Russell Wilson               11                63.6                   28.5
#> Philip Rivers                11                68.3                   33.0
#> Cam Newton                   10                58.6                   33.3
#> Eli Manning                  11                62.3                   36.9
#> Matt Ryan                    11                65.1                   38.5
#> Andy Dalton                  11                62.4                   30.7
#> Alex Smith                   11                65.1                   29.7
#> Colin Kaepernick             11                61.7                   31.5
#> Joe Flacco                   11                63.2                   34.1
#> Jay Cutler                   11                66.8                   36.4
#> Josh McCown                   6                60.4                   30.3
#> Drew Stanton                  6                53.6                   25.2
#> Teddy Bridgewater             8                60.3                   32.8
#> Brian Hoyer                  11                55.9                   33.2
#>                    passing_yards_per_attempt passing_yards_per_game
#> Andrew Luck                              7.8                  331.0
#> Aaron Rodgers                            8.6                  268.8
#> Peyton Manning                           8.0                  323.5
#> Tom Brady                                7.2                  272.5
#> Tony Romo                                8.5                  251.9
#> Drew Brees                               7.6                  317.4
#> Ben Roethlisberger                       7.9                  297.3
#> Ryan Tannehill                           6.6                  234.7
#> Matthew Stafford                         7.1                  267.5
#> Mark Sanchez                             8.1                  296.8
#> Russell Wilson                           7.1                  202.7
#> Philip Rivers                            7.8                  257.7
#> Cam Newton                               7.2                  239.2
#> Eli Manning                              7.0                  257.5
#> Matt Ryan                                7.2                  278.7
#> Andy Dalton                              7.1                  219.4
#> Alex Smith                               6.8                  201.0
#> Colin Kaepernick                         7.5                  237.7
#> Joe Flacco                               7.8                  251.3
#> Jay Cutler                               7.1                  256.8
#> Josh McCown                              7.4                  225.0
#> Drew Stanton                             7.1                  178.2
#> Teddy Bridgewater                        6.4                  211.1
#> Brian Hoyer                              7.8                  260.4
#>                    touchdown_pct interception_pct rushing_attempts_per_game
#> Andrew Luck                  6.3              2.2                       4.2
#> Aaron Rodgers                8.8              0.9                       2.5
#> Peyton Manning               7.7              2.0                       1.5
#> Tom Brady                    6.2              1.4                       1.7
#> Tony Romo                    7.5              2.0                       1.5
#> Drew Brees                   4.8              2.4                       1.7
#> Ben Roethlisberger           5.8              1.5                       1.9
#> Ryan Tannehill               5.1              2.1                       3.7
#> Matthew Stafford             3.1              2.4                       2.8
#> Mark Sanchez                 4.8              4.1                       3.5
#> Russell Wilson               4.5              1.6                       7.6
#> Philip Rivers                6.1              2.5                       2.5
#> Cam Newton                   3.6              3.0                       6.4
#> Eli Manning                  5.2              3.0                       0.8
#> Matt Ryan                    4.5              2.1                       1.6
#> Andy Dalton                  3.6              3.0                       3.8
#> Alex Smith                   4.0              1.2                       3.2
#> Colin Kaepernick             4.3              1.7                       6.8
#> Joe Flacco                   4.8              2.1                       2.0
#> Jay Cutler                   5.5              3.0                       2.9
#> Josh McCown                  3.8              4.4                       2.7
#> Drew Stanton                 3.3              2.0                       3.0
#> Teddy Bridgewater            2.3              2.7                       3.5
#> Brian Hoyer                  3.0              2.2                       1.8
#>                    rushing_yards_per_attempt rushing_yards_per_game
#> Andrew Luck                              4.2                   17.5
#> Aaron Rodgers                            6.4                   16.2
#> Peyton Manning                          -0.5                   -0.7
#> Tom Brady                                0.7                    1.3
#> Tony Romo                                2.5                    3.7
#> Drew Brees                               2.8                    4.9
#> Ben Roethlisberger                       1.1                    2.1
#> Ryan Tannehill                           6.7                   25.1
#> Matthew Stafford                         2.0                    5.6
#> Mark Sanchez                             0.6                    2.0
#> Russell Wilson                           7.7                   58.5
#> Philip Rivers                            2.5                    6.4
#> Cam Newton                               4.6                   29.3
#> Eli Manning                              3.8                    3.1
#> Matt Ryan                                4.3                    7.1
#> Andy Dalton                              2.5                    9.5
#> Alex Smith                               5.5                   17.4
#> Colin Kaepernick                         4.5                   30.5
#> Joe Flacco                               1.7                    3.4
#> Jay Cutler                               3.9                   11.3
#> Josh McCown                              5.8                   15.3
#> Drew Stanton                             2.0                    6.0
#> Teddy Bridgewater                        4.6                   16.1
#> Brian Hoyer                              0.9                    1.5
#>                    rushing_first_down_pct
#> Andrew Luck                          30.4
#> Aaron Rodgers                        50.0
#> Peyton Manning                        0.0
#> Tom Brady                            21.1
#> Tony Romo                            20.0
#> Drew Brees                           26.3
#> Ben Roethlisberger                   19.0
#> Ryan Tannehill                       36.6
#> Matthew Stafford                     16.1
#> Mark Sanchez                          7.1
#> Russell Wilson                       45.2
#> Philip Rivers                        25.0
#> Cam Newton                           37.5
#> Eli Manning                          33.3
#> Matt Ryan                            33.3
#> Andy Dalton                          33.3
#> Alex Smith                           25.7
#> Colin Kaepernick                     22.7
#> Joe Flacco                           45.5
#> Jay Cutler                           28.1
#> Josh McCown                          50.0
#> Drew Stanton                         22.2
#> Teddy Bridgewater                    32.1
#> Brian Hoyer                          20.0
#> 
#> $ranking_labels
#>  [1] "Expert_01" "Expert_02" "Expert_03" "Expert_04" "Expert_05" "Expert_06"
#>  [7] "Expert_07" "Expert_08" "Expert_09" "Expert_10" "Expert_11" "Expert_12"
#> [13] "Expert_13"
#> 
#> $source
#> $source$citation
#> [1] "Li, Yi and Liu (2022), Tables 1--2"
#> 
#> $source$ranking_source
#> [1] "fantasy.nfl.com/research/rankings"   "fantasypros.com/nfl/rankings/qb.php"
#> 
#> $source$covariate_source
#> [1] "nfl.com/stats"
#> 
#> $source$note
#> [1] "Static transcription of published tables; not a live scrape."
#> 
#> 
```
