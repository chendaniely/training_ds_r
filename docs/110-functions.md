

# Functions

## Writing Functions

###  Fahrenheit to Kelvin

$k = ((f - 32) * (5 / 9)) + 273.15$


```r
((32 - 32) * (5 / 9)) + 273.15
## [1] 273.15
((212 - 32) * (5 / 9)) + 273.15
## [1] 373.15
((-42 - 32) * (5 / 9)) + 273.15
## [1] 232.0389
```


```r
f_k <- function(f_temp) {
    ((f_temp - 32) * (5 / 9)) + 273.15
}
```


```r
f_k(32)
## [1] 273.15
f_k(212)
## [1] 373.15
f_k(-42)
## [1] 232.0389
```

### Kelvin to Celsius


```r
k_c <- function(temp_k) {
    temp_c <- temp_k - 273.15
    return(temp_c)
}
```


```r
k_c(0)
## [1] -273.15
```

### Fahrenheit to Celsius


```r
f_c <- function(temp_f) {
    temp_k <- f_k(temp_f)
    temp_c <- k_c(temp_k)
    return(temp_c)
}
```


```r
f_c(32)
## [1] 0
f_c(212)
## [1] 100
```

## Testing Functions


```r
library(testthat)

testthat::expect_equal(f_c(32), 0)
testthat::expect_equal(f_c(212), 100)
```

## Exercise

1. What happens if you use `NA`, `Inf`, `-Inf` in your function?
2. What are some better names to give the functions we wrote?
  - How would you name these functions in a package?


## Checking values

Calculating weighted means


```r
mean_wt <- function(x, w) {
  sum(x * w) / sum(w)
}
```


```r
mean_wt(1:6, 1:6)
## [1] 4.333333
```

If you expect the lengths to be the same,
then you should test for it in the function


```r
mean_wt(1:6, 1:3)
## [1] 7.666667
```


```r
mean_wt <- function(x, w) {
  if (length(x) != length(w)) {
    stop("`x` and `w` should be the same length")
  }
  sum(x * w) / sum(w)
}
```


```r
mean_wt(1:6, 1:3)
## Error in mean_wt(1:6, 1:3): `x` and `w` should be the same length
```

## dot-dot-dot ...

Use it to pass on arguments to another function inside.

But you can also use it to force named arguments in your function.


```r
sum_3 <- function(x, y, z) {
  return(x + y + z)
}
```


```r
sum_3(1, 2, 3)
## [1] 6
```


```r
sum_3 <- function(x, y, ..., z) {
  return(x + y + z)
}
```


```r
sum_3(1, 2, z = 3)
## [1] 6
```


```r
sum_3(1, 2, z = 3)
## [1] 6
```
