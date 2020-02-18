
# Linear Models

## Fit a linear model

### Base R

```r
library(AmesHousing)
```


```r
ames <- AmesHousing::make_ames()
```



```r
# Gr Liv Area = Above grade (ground) living area square feet
lm_ames <- lm(Sale_Price ~ Gr_Liv_Area, data = ames)
```


```r
lm_ames
## 
## Call:
## lm(formula = Sale_Price ~ Gr_Liv_Area, data = ames)
## 
## Coefficients:
## (Intercept)  Gr_Liv_Area  
##     13289.6        111.7
```


```r
broom::tidy(lm_ames)
## # A tibble: 2 x 5
##   term        estimate std.error statistic   p.value
##   <chr>          <dbl>     <dbl>     <dbl>     <dbl>
## 1 (Intercept)   13290.   3270.        4.06 0.0000494
## 2 Gr_Liv_Area     112.      2.07     54.1  0
```

### Tidymodels

Steps in a parsnip model:

1. Pick a model
2. Set the engine (what library is running the model)
3. Set the mode (if needed, e.g., regression or classification)

List of models: https://tidymodels.github.io/parsnip/articles/articles/Models.html

Allows you to quickly swap out and try different models


```r
library(parsnip)
```


```r
lm_spec <- parsnip::linear_reg() %>%
  parsnip::set_engine(engine = "lm")
```

Train/fit the model:


```r
lm_fit <- parsnip::fit(lm_spec, Sale_Price ~ Gr_Liv_Area, data = ames)
lm_fit
## parsnip model object
## 
## Fit time:  3ms 
## 
## Call:
## stats::lm(formula = formula, data = data)
## 
## Coefficients:
## (Intercept)  Gr_Liv_Area  
##     13289.6        111.7
```


```r
broom::tidy(lm_fit)
## # A tibble: 2 x 5
##   term        estimate std.error statistic   p.value
##   <chr>          <dbl>     <dbl>     <dbl>     <dbl>
## 1 (Intercept)   13290.   3270.        4.06 0.0000494
## 2 Gr_Liv_Area     112.      2.07     54.1  0
```

## Predict


```r
price_pred <- stats::predict(lm_fit, new_data = ames)
price_pred
## # A tibble: 2,930 x 1
##      .pred
##      <dbl>
##  1 198255.
##  2 113367.
##  3 161731.
##  4 248964.
##  5 195239.
##  6 192447.
##  7 162736.
##  8 156258.
##  9 193787.
## 10 214786.
## # … with 2,920 more rows
```


```r
price_pred <- price_pred %>%
  dplyr::mutate(truth = ames$Sale_Price)
```


```r
price_pred
## # A tibble: 2,930 x 2
##      .pred  truth
##      <dbl>  <int>
##  1 198255. 215000
##  2 113367. 105000
##  3 161731. 172000
##  4 248964. 244000
##  5 195239. 189900
##  6 192447. 195500
##  7 162736. 213500
##  8 156258. 191500
##  9 193787. 236500
## 10 214786. 189000
## # … with 2,920 more rows
```

## Error metrics

$$
\begin{aligned}
\text{MAE}  &= \dfrac{1}{n}\sum_{i=1}^{n} \left| \hat{y}_i - y_i \right|\\
\text{RMSE} &= \sqrt{\dfrac{1}{n}\sum_{i=1}^{n} \left( \hat{y}_i - y_i \right)^2}
\end{aligned}
$$

Regression Metrics Guide: https://www.h2o.ai/blog/regression-metrics-guide/


```r
library(yardstick)
## For binary classification, the first factor level is assumed to be the event.
## Set the global option `yardstick.event_first` to `FALSE` to change this.

yardstick::rmse(price_pred, truth = truth, estimate = .pred)
## # A tibble: 1 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard      56505.
```

## Train Test Split

- best way to measure model performance is to see how it performs to *new data*

http://www.feat.engineering/

train-test-split


```r
ames_split <- rsample::initial_split(ames, prop = 0.75)
ames_split
## <2198/732/2930>
```


```r
dim(ames)
## [1] 2930   81
```


```r
class(ames_split)
## [1] "rsplit"   "mc_split"
```
 

```r
ames_train <- rsample::training(ames_split)
```


```r
ames_test <- rsample::testing(ames_split)
```

## Exercise


1. Split the `ames` dataset into training and testing sets
2. Fit a linear model
3. Measure how the model is performing

- Hint: set a seed (e.g., 42)
- Hint: `library(tidyverse)`, `library(tidymodels)`

### Solution


```r
library(tidyverse)
## ── Attaching packages ────────────────────────────────────────────────────────────── tidyverse 1.3.0 ──
## ✓ ggplot2 3.2.1     ✓ purrr   0.3.3
## ✓ tibble  2.1.3     ✓ dplyr   0.8.4
## ✓ tidyr   1.0.2     ✓ stringr 1.4.0
## ✓ readr   1.3.1     ✓ forcats 0.4.0
## ── Conflicts ───────────────────────────────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
## x readr::spec()   masks yardstick::spec()
library(tidymodels)
## ── Attaching packages ───────────────────────────────────────────────────────────── tidymodels 0.0.3 ──
## ✓ broom   0.5.4     ✓ recipes 0.1.9
## ✓ dials   0.0.4     ✓ rsample 0.0.5
## ✓ infer   0.5.1
## ── Conflicts ──────────────────────────────────────────────────────────────── tidymodels_conflicts() ──
## x scales::discard()   masks purrr::discard()
## x dplyr::filter()     masks stats::filter()
## x recipes::fixed()    masks stringr::fixed()
## x dplyr::lag()        masks stats::lag()
## x dials::margin()     masks ggplot2::margin()
## x readr::spec()       masks yardstick::spec()
## x recipes::step()     masks stats::step()
## x recipes::yj_trans() masks scales::yj_trans()
set.seed(42)

ames_split <- rsample::initial_split(ames)
```


```r
ames_train <- rsample::training(ames_split)
ames_test <- rsample::testing(ames_split)
```


```r
lm_fit <- parsnip::linear_reg() %>%
  parsnip::set_engine(engine = "lm") %>%
  parsnip::fit(Sale_Price ~ Gr_Liv_Area, data = ames_train)
```


```r
price_pred <- lm_fit %>%
  stats::predict(new_data = ames_test) %>%
  dplyr::mutate(price_truth = ames_test$Sale_Price)
```


```r
yardstick::rmse(price_pred, truth = price_truth, estimate = .pred)
## # A tibble: 1 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard      56478.
```
