# Simulate a tiered twenty-player tennis league

Simulate a complete league with user-specified block strengths and
sizes. A common random permutation shuffles both axes.

## Usage

``` r
tennis_tiered_toy(
  matches_per_pair = 20L,
  seed = 101L,
  n_blocks = length(latent_strength),
  latent_strength = c(12, 6, 2, 1),
  players_per_block = 5L,
  item_labels = NULL,
  format = c("data", "edgelist")
)
```

## Arguments

- matches_per_pair:

  Positive integer number of matches for each pair.

- seed:

  Integer random seed, or NULL to use the current random state.

- n_blocks:

  Positive integer number of generating blocks.

- latent_strength:

  Positive vector with one strength per generating block. The default
  `c(12, 6, 2, 1)` is on the same scale as the default Gamma prior and
  gives tiers that are separable but not perfectly so.

- players_per_block:

  Positive integer block sizes, either one common size or a vector of
  length n_blocks.

- item_labels:

  Optional unique names for all players.

- format:

  Return validated data (default) or a winner/loser/count edge list.

## Value

A btsbm_pairwise_data object, or an edge-list data frame, with
generating groups and strengths stored in its truth attribute. All
observations are synthetic.

## Examples

``` r
head(tennis_tiered_toy())
#> $wins
#>           Isla Kent Tara Fox Will Gray Jack Ford Rosa Hill Maya Cole Leo Wood
#> Isla Kent         0        8         6         3        12        11        6
#> Tara Fox         12        0        15         9        14        15       10
#> Will Gray        14        5         0         5         4        11        2
#> Jack Ford        17       11        15         0         8        13       11
#> Rosa Hill         8        6        16        12         0        15        6
#> Maya Cole         9        5         9         7         5         0        3
#> Leo Wood         14       10        18         9        14        17        0
#> Hugo Dale        10        5        12         3         3         8        2
#> Ella Shaw         3        3         6         2         6         3        0
#> Finn Lake         4        2         5         0         1         9        1
#> Sam Ward          5        3         7         2         6         7        1
#> Dan Moss         16       14        15         8        16        18       12
#> Orla Hart        15       10        15         8         9        12        5
#> Kira Lane        15       15        19         9        14        15       11
#> Paul Snow        16        9        15        10         5        17        2
#> Noah Bell        15       15        16        10        16        16       12
#> Cara Reed         3        2         6         1         0         8        4
#> Ben Holt         11        8         8         4         4        15        3
#> Alex Vale        15       10        14         8         7        16        6
#> Gina West         7        5         5         1         6         6        3
#>           Hugo Dale Ella Shaw Finn Lake Sam Ward Dan Moss Orla Hart Kira Lane
#> Isla Kent        10        17        16       15        4         5         5
#> Tara Fox         15        17        18       17        6        10         5
#> Will Gray         8        14        15       13        5         5         1
#> Jack Ford        17        18        20       18       12        12        11
#> Rosa Hill        17        14        19       14        4        11         6
#> Maya Cole        12        17        11       13        2         8         5
#> Leo Wood         18        20        19       19        8        15         9
#> Hugo Dale         0        16        14       15        5         6         0
#> Ella Shaw         4         0        11       13        0         5         5
#> Finn Lake         6         9         0       11        0         3         2
#> Sam Ward          5         7         9        0        0         4         0
#> Dan Moss         15        20        20       20        0        16         8
#> Orla Hart        14        15        17       16        4         0         7
#> Kira Lane        20        15        18       20       12        13         0
#> Paul Snow        12        15        17       17        4        10         5
#> Noah Bell        17        18        18       17       12        15         8
#> Cara Reed         5        10        12       14        3         4         2
#> Ben Holt         11        12        12       11        3         6         4
#> Alex Vale        15        16        20       19        5        13         6
#> Gina West         6        11         9        9        2         5         1
#>           Paul Snow Noah Bell Cara Reed Ben Holt Alex Vale Gina West
#> Isla Kent         4         5        17        9         5        13
#> Tara Fox         11         5        18       12        10        15
#> Will Gray         5         4        14       12         6        15
#> Jack Ford        10        10        19       16        12        19
#> Rosa Hill        15         4        20       16        13        14
#> Maya Cole         3         4        12        5         4        14
#> Leo Wood         18         8        16       17        14        17
#> Hugo Dale         8         3        15        9         5        14
#> Ella Shaw         5         2        10        8         4         9
#> Finn Lake         3         2         8        8         0        11
#> Sam Ward          3         3         6        9         1        11
#> Dan Moss         16         8        17       17        15        18
#> Orla Hart        10         5        16       14         7        15
#> Kira Lane        15        12        18       16        14        19
#> Paul Snow         0        11        14       19         8        18
#> Noah Bell         9         0        18       16        16        18
#> Cara Reed         6         2         0        8         5        12
#> Ben Holt          1         4        12        0         5        13
#> Alex Vale        12         4        15       15         0        15
#> Gina West         2         2         8        7         5         0
#> 
#> $n_items
#> [1] 20
#> 
#> $item_labels
#>  [1] "Isla Kent" "Tara Fox"  "Will Gray" "Jack Ford" "Rosa Hill" "Maya Cole"
#>  [7] "Leo Wood"  "Hugo Dale" "Ella Shaw" "Finn Lake" "Sam Ward"  "Dan Moss" 
#> [13] "Orla Hart" "Kira Lane" "Paul Snow" "Noah Bell" "Cara Reed" "Ben Holt" 
#> [19] "Alex Vale" "Gina West"
#> 
```
