
# Iteration

## Broadcasting


```r
f_values <- c(0, 32, 212, -40)
```


```r
f_values * 10
## [1]    0  320 2120 -400
```


```r
f_values * c(10, 100)
## [1]     0  3200  2120 -4000
```

## For loops

Temp conversion functions


```r
f_k <- function(f_temp) {
    ((f_temp - 32) * (5 / 9)) + 273.15
}


k_c <- function(temp_k) {
    if (is.na(temp_k)) {
        return(NA)
    } else if (temp_k < 0) {
        warning('you passed in a negative Kelvin number')
        # stop()
        return(NA)
    } else {
        temp_c <- temp_k - 273.15
        return(temp_c)
    }
}

f_c <- function(temp_f) {
    temp_k <- f_k(temp_f)
    temp_c <- k_c(temp_k)
    return(temp_c)
}
```




```r
for (pizza in f_values) {
    print(pizza)
    converted <- f_c(pizza)
    print(converted)
}
## [1] 0
## [1] -17.77778
## [1] 32
## [1] 0
## [1] 212
## [1] 100
## [1] -40
## [1] -40
```


```r
# 1:length(f_values)
# seq_along(f_values)
for (i in seq_along(f_values)) {
    print(i)
    val <- f_values[i]
    print(val)
    
    converted <- f_c(val)
    print(converted)
}
## [1] 1
## [1] 0
## [1] -17.77778
## [1] 2
## [1] 32
## [1] 0
## [1] 3
## [1] 212
## [1] 100
## [1] 4
## [1] -40
## [1] -40
```

### Pre allocating in a loop


```r
# prepopulate an empty vector
converted_values <- vector("double", length(f_values))
for (to_be_converted_position in seq_along(f_values)) {
    converted <- f_c(to_be_converted_position)
    converted_values[to_be_converted_position] <- converted
}
```



```r
converted_values
## [1] -17.22222 -16.66667 -16.11111 -15.55556
```

## purrr (map)


```r
library(purrr)
```


```r
map(f_values, f_c)
## [[1]]
## [1] -17.77778
## 
## [[2]]
## [1] 0
## 
## [[3]]
## [1] 100
## 
## [[4]]
## [1] -40
```


```r
map_dbl(f_values, f_c)
## [1] -17.77778   0.00000 100.00000 -40.00000
```


```r
mtcars
##                      mpg cyl  disp  hp drat    wt  qsec vs am gear carb
## Mazda RX4           21.0   6 160.0 110 3.90 2.620 16.46  0  1    4    4
## Mazda RX4 Wag       21.0   6 160.0 110 3.90 2.875 17.02  0  1    4    4
## Datsun 710          22.8   4 108.0  93 3.85 2.320 18.61  1  1    4    1
## Hornet 4 Drive      21.4   6 258.0 110 3.08 3.215 19.44  1  0    3    1
## Hornet Sportabout   18.7   8 360.0 175 3.15 3.440 17.02  0  0    3    2
## Valiant             18.1   6 225.0 105 2.76 3.460 20.22  1  0    3    1
## Duster 360          14.3   8 360.0 245 3.21 3.570 15.84  0  0    3    4
## Merc 240D           24.4   4 146.7  62 3.69 3.190 20.00  1  0    4    2
## Merc 230            22.8   4 140.8  95 3.92 3.150 22.90  1  0    4    2
## Merc 280            19.2   6 167.6 123 3.92 3.440 18.30  1  0    4    4
## Merc 280C           17.8   6 167.6 123 3.92 3.440 18.90  1  0    4    4
## Merc 450SE          16.4   8 275.8 180 3.07 4.070 17.40  0  0    3    3
## Merc 450SL          17.3   8 275.8 180 3.07 3.730 17.60  0  0    3    3
## Merc 450SLC         15.2   8 275.8 180 3.07 3.780 18.00  0  0    3    3
## Cadillac Fleetwood  10.4   8 472.0 205 2.93 5.250 17.98  0  0    3    4
## Lincoln Continental 10.4   8 460.0 215 3.00 5.424 17.82  0  0    3    4
## Chrysler Imperial   14.7   8 440.0 230 3.23 5.345 17.42  0  0    3    4
## Fiat 128            32.4   4  78.7  66 4.08 2.200 19.47  1  1    4    1
## Honda Civic         30.4   4  75.7  52 4.93 1.615 18.52  1  1    4    2
## Toyota Corolla      33.9   4  71.1  65 4.22 1.835 19.90  1  1    4    1
## Toyota Corona       21.5   4 120.1  97 3.70 2.465 20.01  1  0    3    1
## Dodge Challenger    15.5   8 318.0 150 2.76 3.520 16.87  0  0    3    2
## AMC Javelin         15.2   8 304.0 150 3.15 3.435 17.30  0  0    3    2
## Camaro Z28          13.3   8 350.0 245 3.73 3.840 15.41  0  0    3    4
## Pontiac Firebird    19.2   8 400.0 175 3.08 3.845 17.05  0  0    3    2
## Fiat X1-9           27.3   4  79.0  66 4.08 1.935 18.90  1  1    4    1
## Porsche 914-2       26.0   4 120.3  91 4.43 2.140 16.70  0  1    5    2
## Lotus Europa        30.4   4  95.1 113 3.77 1.513 16.90  1  1    5    2
## Ford Pantera L      15.8   8 351.0 264 4.22 3.170 14.50  0  1    5    4
## Ferrari Dino        19.7   6 145.0 175 3.62 2.770 15.50  0  1    5    6
## Maserati Bora       15.0   8 301.0 335 3.54 3.570 14.60  0  1    5    8
## Volvo 142E          21.4   4 121.0 109 4.11 2.780 18.60  1  1    4    2
```


```r
map(mtcars, class)
## $mpg
## [1] "numeric"
## 
## $cyl
## [1] "numeric"
## 
## $disp
## [1] "numeric"
## 
## $hp
## [1] "numeric"
## 
## $drat
## [1] "numeric"
## 
## $wt
## [1] "numeric"
## 
## $qsec
## [1] "numeric"
## 
## $vs
## [1] "numeric"
## 
## $am
## [1] "numeric"
## 
## $gear
## [1] "numeric"
## 
## $carb
## [1] "numeric"
```


```r
map_chr(mtcars, class)
##       mpg       cyl      disp        hp      drat        wt      qsec        vs 
## "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" "numeric" 
##        am      gear      carb 
## "numeric" "numeric" "numeric"
```



```r
map_dbl(mtcars, mean)
##        mpg        cyl       disp         hp       drat         wt       qsec 
##  20.090625   6.187500 230.721875 146.687500   3.596563   3.217250  17.848750 
##         vs         am       gear       carb 
##   0.437500   0.406250   3.687500   2.812500
```


```r
map(mtcars, summary)
## $mpg
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   10.40   15.43   19.20   20.09   22.80   33.90 
## 
## $cyl
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   4.000   4.000   6.000   6.188   8.000   8.000 
## 
## $disp
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    71.1   120.8   196.3   230.7   326.0   472.0 
## 
## $hp
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    52.0    96.5   123.0   146.7   180.0   335.0 
## 
## $drat
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   2.760   3.080   3.695   3.597   3.920   4.930 
## 
## $wt
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.513   2.581   3.325   3.217   3.610   5.424 
## 
## $qsec
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   14.50   16.89   17.71   17.85   18.90   22.90 
## 
## $vs
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.0000  0.0000  0.0000  0.4375  1.0000  1.0000 
## 
## $am
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##  0.0000  0.0000  0.0000  0.4062  1.0000  1.0000 
## 
## $gear
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   3.000   3.000   4.000   3.688   4.000   5.000 
## 
## $carb
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##   1.000   2.000   2.000   2.812   4.000   8.000
```


### Exercise

1. Compute the mean of every column in mtcars.
2. Determine the type of each column in nycflights13::flights.
3. Compute the number of unique values in each column of iris.
(Hint: you may want to write a function)
4. Generate 10 random normals from distributions with means of -10, 0, 10, and 100.

#### Solutions


```r
# 1. Compute the mean of every column in mtcars
purrr::map_dbl(mtcars, mean)
##        mpg        cyl       disp         hp       drat         wt       qsec 
##  20.090625   6.187500 230.721875 146.687500   3.596563   3.217250  17.848750 
##         vs         am       gear       carb 
##   0.437500   0.406250   3.687500   2.812500
```


```r
# 2. Determine the type of each column in nycflights13::flights.
purrr::map_chr(nycflights13::flights, class)
## Error: Result 19 must be a single string, not a character vector of length 2
```


```r
purrr::map(nycflights13::flights, class)
## $year
## [1] "integer"
## 
## $month
## [1] "integer"
## 
## $day
## [1] "integer"
## 
## $dep_time
## [1] "integer"
## 
## $sched_dep_time
## [1] "integer"
## 
## $dep_delay
## [1] "numeric"
## 
## $arr_time
## [1] "integer"
## 
## $sched_arr_time
## [1] "integer"
## 
## $arr_delay
## [1] "numeric"
## 
## $carrier
## [1] "character"
## 
## $flight
## [1] "integer"
## 
## $tailnum
## [1] "character"
## 
## $origin
## [1] "character"
## 
## $dest
## [1] "character"
## 
## $air_time
## [1] "numeric"
## 
## $distance
## [1] "numeric"
## 
## $hour
## [1] "numeric"
## 
## $minute
## [1] "numeric"
## 
## $time_hour
## [1] "POSIXct" "POSIXt"
```


```r
# Compute the number of unique values in each column of iris.
count_unique <- function(x) {
    return(length(unique(x)))
}

purrr::map_int(iris, count_unique)
## Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
##           35           23           43           22            3
```


```r
purrr::map_int(iris, function(x) length(unique(x)))
## Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
##           35           23           43           22            3
```


```r
purrr::map_int(iris, ~ length(unique(.)))
## Sepal.Length  Sepal.Width Petal.Length  Petal.Width      Species 
##           35           23           43           22            3
```


```r
# Generate 10 random normals from distributions with means of -10, 0, 10, and 100.
purrr::map(c(-10, 0, 10, 100), ~ rnorm(n = 10, mean = .))
## [[1]]
##  [1]  -8.629042 -10.564698  -9.636872  -9.367137  -9.595732 -10.106125
##  [7]  -8.488478 -10.094659  -7.981576 -10.062714
## 
## [[2]]
##  [1]  1.3048697  2.2866454 -1.3888607 -0.2787888 -0.1333213  0.6359504
##  [7] -0.2842529 -2.6564554 -2.4404669  1.3201133
## 
## [[3]]
##  [1]  9.693361  8.218692  9.828083 11.214675 11.895193  9.569531  9.742731
##  [8]  8.236837 10.460097  9.360005
## 
## [[4]]
##  [1] 100.45545 100.70484 101.03510  99.39107 100.50496  98.28299  99.21554
##  [8]  99.14909  97.58579 100.03612
```

## Fitting models


```r
models <- mtcars %>% 
  split(.$cyl) %>% 
  map(function(df) lm(mpg ~ wt, data = df))
```


```r
models %>%
    map(summary) %>%
    map_dbl(~ .$r.squared)
##         4         6         8 
## 0.5086326 0.4645102 0.4229655
```


```r
models %>%
    map_df(broom::tidy)
## # A tibble: 6 x 5
##   term        estimate std.error statistic    p.value
##   <chr>          <dbl>     <dbl>     <dbl>      <dbl>
## 1 (Intercept)    39.6      4.35       9.10 0.00000777
## 2 wt             -5.65     1.85      -3.05 0.0137    
## 3 (Intercept)    28.4      4.18       6.79 0.00105   
## 4 wt             -2.78     1.33      -2.08 0.0918    
## 5 (Intercept)    23.9      3.01       7.94 0.00000405
## 6 wt             -2.19     0.739     -2.97 0.0118
```

## Apply (in base R)

apply family of functions


### lapply


```r
lapply(f_values, f_c)
## [[1]]
## [1] -17.77778
## 
## [[2]]
## [1] 0
## 
## [[3]]
## [1] 100
## 
## [[4]]
## [1] -40
```

### sapply


```r
sapply(f_values, f_c)
## [1] -17.77778   0.00000 100.00000 -40.00000
```

### vapply


```r
vapply(f_values, f_c, numeric(1))
## [1] -17.77778   0.00000 100.00000 -40.00000
```


### mapply


```r
v1 <- c(1, 2, 3, 4)
v2 <- c(100, 200, 300, 400)
```


```r
my_mean <- function(x, y){
    return((x + y) / 2)
}
```


```r
# sapply(v1, v2, my_mean)
```


```r
mapply(my_mean, v1, v2)
## [1]  50.5 101.0 151.5 202.0
# this is the same as purrr::map2
```

### apply (2-dimensions)


```r
apply(mtcars, MARGIN = 1, mean)
##           Mazda RX4       Mazda RX4 Wag          Datsun 710      Hornet 4 Drive 
##            29.90727            29.98136            23.59818            38.73955 
##   Hornet Sportabout             Valiant          Duster 360           Merc 240D 
##            53.66455            35.04909            59.72000            24.63455 
##            Merc 230            Merc 280           Merc 280C          Merc 450SE 
##            27.23364            31.86000            31.78727            46.43091 
##          Merc 450SL         Merc 450SLC  Cadillac Fleetwood Lincoln Continental 
##            46.50000            46.35000            66.23273            66.05855 
##   Chrysler Imperial            Fiat 128         Honda Civic      Toyota Corolla 
##            65.97227            19.44091            17.74227            18.81409 
##       Toyota Corona    Dodge Challenger         AMC Javelin          Camaro Z28 
##            24.88864            47.24091            46.00773            58.75273 
##    Pontiac Firebird           Fiat X1-9       Porsche 914-2        Lotus Europa 
##            57.37955            18.92864            24.77909            24.88027 
##      Ford Pantera L        Ferrari Dino       Maserati Bora          Volvo 142E 
##            60.97182            34.50818            63.15545            26.26273
```


```r
apply(mtcars, MARGIN = 2, mean)
##        mpg        cyl       disp         hp       drat         wt       qsec 
##  20.090625   6.187500 230.721875 146.687500   3.596563   3.217250  17.848750 
##         vs         am       gear       carb 
##   0.437500   0.406250   3.687500   2.812500
```

## Safely dealing with failure

`safely` 
is a function that takes a function, and returns a modified version of that function.
Like how decorators work in Python.


```r
safe_log <- safely(log)
```


```r
safe_log(10)
## $result
## [1] 2.302585
## 
## $error
## NULL
```


```r
safe_log("a")
## $result
## NULL
## 
## $error
## <simpleError in .Primitive("log")(x, base): non-numeric argument to mathematical function>
```



```r
x <- list(1, 10, "a")
y <- x %>% map(safely(log))
```


```r
str(y)
## List of 3
##  $ :List of 2
##   ..$ result: num 0
##   ..$ error : NULL
##  $ :List of 2
##   ..$ result: num 2.3
##   ..$ error : NULL
##  $ :List of 2
##   ..$ result: NULL
##   ..$ error :List of 2
##   .. ..$ message: chr "non-numeric argument to mathematical function"
##   .. ..$ call   : language .Primitive("log")(x, base)
##   .. ..- attr(*, "class")= chr [1:3] "simpleError" "error" "condition"
```

You can specify the error value


```r
safe_log <- safely(log, otherwise = NA)
x <- list(1, 10, "a")
y <- x %>% map(safe_log)
```

Extract values out manually

```r
y %>% purrr::map_dbl(magrittr::extract(1))
## [1] 0.000000 2.302585       NA
```

Use the transpose function


```r
y <- y %>% purrr::transpose()
str(y)
## List of 2
##  $ result:List of 3
##   ..$ : num 0
##   ..$ : num 2.3
##   ..$ : logi NA
##  $ error :List of 3
##   ..$ : NULL
##   ..$ : NULL
##   ..$ :List of 2
##   .. ..$ message: chr "non-numeric argument to mathematical function"
##   .. ..$ call   : language .Primitive("log")(x, base)
##   .. ..- attr(*, "class")= chr [1:3] "simpleError" "error" "condition"
```


```r
y$result %>% purrr::flatten_dbl()
## [1] 0.000000 2.302585       NA
```

## Possibly and quietly succeeds

Possibly always succeeds by giving it a default value.
Safely defaults to `NULL`,
possibly requres the `otherwise` parameter


```r
x <- list(1, 10, "a")
x %>% map_dbl(possibly(log, NA_real_))
## [1] 0.000000 2.302585       NA
```

quietly captures output, messages, and warnings, instead of errors


```r
x <- list(1, -1)
x %>% map(quietly(log)) %>% str()
## List of 2
##  $ :List of 4
##   ..$ result  : num 0
##   ..$ output  : chr ""
##   ..$ warnings: chr(0) 
##   ..$ messages: chr(0) 
##  $ :List of 4
##   ..$ result  : num NaN
##   ..$ output  : chr ""
##   ..$ warnings: chr "NaNs produced"
##   ..$ messages: chr(0)
```


```r
x %>% map(quietly(log)) %>% purrr::transpose() %>% str()
## List of 4
##  $ result  :List of 2
##   ..$ : num 0
##   ..$ : num NaN
##  $ output  :List of 2
##   ..$ : chr ""
##   ..$ : chr ""
##  $ warnings:List of 2
##   ..$ : chr(0) 
##   ..$ : chr "NaNs produced"
##  $ messages:List of 2
##   ..$ : chr(0) 
##   ..$ : chr(0)
```

## Mapping over different arguments

`map2` and `pmap`

varying just a single value


```r
mu <- list(5, 10, -3)
mu %>% 
  map(rnorm, n = 5) %>% 
  str()
## List of 3
##  $ : num [1:5] 5.21 4.64 5.76 4.27 3.63
##  $ : num [1:5] 10.43 9.19 11.44 9.57 10.66
##  $ : num [1:5] -2.68 -3.78 -1.42 -2.36 -2.91
```

varying both mu and sigmna


```r
sigma <- list(1, 5, 10)

map2(mu, sigma, rnorm, n = 5) %>% str()
## List of 3
##  $ : num [1:5] 5.28 5.68 5.09 2.01 5.28
##  $ : num [1:5] 8.16 10.93 12.91 17 6.36
##  $ : num [1:5] 10.025 0.358 7.385 6.207 4.209
```

variying across mu, sigma, and n


```r
n <- list(1, 3, 5)

args <- list(mean = mu, sd = sigma, n = n)
```


```r
pmap(args, rnorm) %>% str()
## List of 3
##  $ : num 3.96
##  $ : num [1:3] 9.55 13.12 5.23
##  $ : num [1:5] -8.43 2.81 4.68 1.64 -11.86
```

If your data is all the same length it can be stored in a dataframe.
Or if you have a dataframe of values you are planning to "apply" over.


```r
library(tibble)
params <- tribble(
  ~mean, ~sd, ~n,
    5,     1,  1,
   10,     5,  3,
   -3,    10,  5
)
params %>% 
  pmap(rnorm)
## [[1]]
## [1] 3.900219
## 
## [[2]]
## [1] 17.56354 11.28961 10.44220
## 
## [[3]]
## [1]  -4.208965 -14.943289   3.119969  -5.171398  -4.827567
```

Having a dataframe and using list columns, you can change
the function an it's arguments with `invoke_map`


```r
f <- c("runif", "rnorm", "rpois")
param <- list(
  list(min = -1, max = 1), 
  list(sd = 5), 
  list(lambda = 10)
)
```


```r
invoke_map(f, param, n = 5) %>% str()
## List of 3
##  $ : num [1:5] 0.649 0.185 0.589 0.538 0.836
##  $ : num [1:5] 5.46 -3.23 3.33 4.09 -2.8
##  $ : int [1:5] 12 17 13 13 6
```


```r
library(dplyr)
## 
## Attaching package: 'dplyr'
## The following objects are masked from 'package:stats':
## 
##     filter, lag
## The following objects are masked from 'package:base':
## 
##     intersect, setdiff, setequal, union
sim <- tribble(
  ~f,      ~params,
  "runif", list(min = -1, max = 1),
  "rnorm", list(sd = 5),
  "rpois", list(lambda = 10)
)
sim_invoked <- sim %>% 
  mutate(sim = invoke_map(f, params, n = 10))
```


```r
sim_invoked
## # A tibble: 3 x 3
##   f     params           sim       
##   <chr> <list>           <list>    
## 1 runif <named list [2]> <dbl [10]>
## 2 rnorm <named list [1]> <dbl [10]>
## 3 rpois <named list [1]> <int [10]>
```


```r
sim_invoked$sim
## [[1]]
##  [1] -0.03082414 -0.49508312 -0.48062004  0.08403188  0.29975168 -0.32716174
##  [7] -0.87810051 -0.09737830  0.67751007  0.14927467
## 
## [[2]]
##  [1]  -1.881454   6.205581  -4.738676   8.839889   4.586639  -4.473877
##  [7]  -3.440830  -4.992420 -10.536207   4.287095
## 
## [[3]]
##  [1] 13  9 10  7  6 14  7 15 10  6
```

## Exercise

Write a pipeline that caclculates the mean of each simulation


```r
sim_invoked %>%
    mutate(estimate = map_dbl(sim, mean))
## # A tibble: 3 x 4
##   f     params           sim        estimate
##   <chr> <list>           <list>        <dbl>
## 1 runif <named list [2]> <dbl [10]>   -0.110
## 2 rnorm <named list [1]> <dbl [10]>   -0.614
## 3 rpois <named list [1]> <int [10]>    9.7
```

## Walk

the `map` set of functions return function values,
you use `walk` if you are only interested in the function side effects.
E.g., saving out to a file.



```r
x <- list(1, "a", 3)

x %>% 
  walk(print)
## [1] 1
## [1] "a"
## [1] 3
```

list of plots with file names, you can use pwalk to save


```r
library(ggplot2)
plots <- mtcars %>% 
  split(.$cyl) %>% 
  map(~ggplot(., aes(mpg, wt)) + geom_point())
paths <- stringr::str_c(names(plots), ".pdf")

# pwalk(list(paths, plots), ggsave, path = tempdir())
```

## Other predicates

`keep`, `discard`

only keeps or discards `TRUE` values


```r
iris %>% 
  keep(is.factor) %>% 
  str()
## 'data.frame':	150 obs. of  1 variable:
##  $ Species: Factor w/ 3 levels "setosa","versicolor",..: 1 1 1 1 1 1 1 1 1 1 ...
```

`some` and `every` work like `any` and `all`


```r
x <- list(1:5, letters, list(10))

x %>% 
  some(is_character)
## [1] TRUE
```

`detect` and `detect_index` finds the first element



```r
x <- sample(10)
x
##  [1]  2  8  7  3  5  6  4  1 10  9
```


```r
x %>% 
  detect(~ . > 5)
## [1] 8
```

`head_while` `tail_while` returns the head or tail while something is true


```r
x
##  [1]  2  8  7  3  5  6  4  1 10  9
```



```r
x %>% 
  head_while(~ . > 5)
## integer(0)
```


```r
x %>% 
  tail_while(~ . > 5)
## [1] 10  9
```

`reduce` applies a function until there is only one left.
Useful for repeadily joinging dataframes together


```r
dfs <- list(
  age = tibble(name = "John", age = 30),
  sex = tibble(name = c("John", "Mary"), sex = c("M", "F")),
  trt = tibble(name = "Mary", treatment = "A")
)

dfs
## $age
## # A tibble: 1 x 2
##   name    age
##   <chr> <dbl>
## 1 John     30
## 
## $sex
## # A tibble: 2 x 2
##   name  sex  
##   <chr> <chr>
## 1 John  M    
## 2 Mary  F    
## 
## $trt
## # A tibble: 1 x 2
##   name  treatment
##   <chr> <chr>    
## 1 Mary  A
```


```r
dfs %>% reduce(full_join)
## Joining, by = "name"
## Joining, by = "name"
## # A tibble: 2 x 4
##   name    age sex   treatment
##   <chr> <dbl> <chr> <chr>    
## 1 John     30 M     <NA>     
## 2 Mary     NA F     A
```

