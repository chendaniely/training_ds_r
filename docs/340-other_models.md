
# Other models

## Exercise

1. Load the ames dataset
2. Split the data, `rsplit`
3. Fit a linear model and test it
    1. define model spec
    2. create workflow
    3. fit model
4. calculate the `rmse`

### Solution


```r
library(tidyverse)
## ── Attaching packages ──────────────────────────────────── tidyverse 1.3.0 ──
## ✓ ggplot2 3.2.1     ✓ purrr   0.3.3
## ✓ tibble  2.1.3     ✓ dplyr   0.8.4
## ✓ tidyr   1.0.2     ✓ stringr 1.4.0
## ✓ readr   1.3.1     ✓ forcats 0.4.0
## ── Conflicts ─────────────────────────────────────── tidyverse_conflicts() ──
## x dplyr::filter() masks stats::filter()
## x dplyr::lag()    masks stats::lag()
library(tidymodels)
## ── Attaching packages ─────────────────────────────────── tidymodels 0.0.3 ──
## ✓ broom     0.5.4     ✓ recipes   0.1.9
## ✓ dials     0.0.4     ✓ rsample   0.0.5
## ✓ infer     0.5.1     ✓ yardstick 0.0.5
## ✓ parsnip   0.0.5
## ── Conflicts ────────────────────────────────────── tidymodels_conflicts() ──
## x scales::discard()   masks purrr::discard()
## x dplyr::filter()     masks stats::filter()
## x recipes::fixed()    masks stringr::fixed()
## x dplyr::lag()        masks stats::lag()
## x dials::margin()     masks ggplot2::margin()
## x yardstick::spec()   masks readr::spec()
## x recipes::step()     masks stats::step()
## x recipes::yj_trans() masks scales::yj_trans()
library(AmesHousing)
```


```r
ames <- AmesHousing::make_ames()
```


```r
ames_split <- rsample::initial_split(ames)
```


```r
lm_spec <- parsnip::linear_reg() %>%
  parsnip::set_engine("lm")
```



```r
lm_wf <- workflows::workflow() %>%
  workflows::add_formula(Sale_Price ~ Gr_Liv_Area) %>%
  workflows::add_model(lm_spec)
```


```r
lm_split <- lm_wf %>%
  tune::last_fit(ames_split)
```


```r
lm_split %>% tune::collect_metrics()
## # A tibble: 2 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard   56478.   
## 2 rsq     standard       0.435
```

## Decision trees

https://tidymodels.github.io/parsnip/articles/articles/Models.html

Fit a decision tree using `rpart`


```r
rt_spec <- parsnip::decision_tree() %>%
  parsnip::set_engine("rpart") %>%
  parsnip::set_mode("regression")
```


```r
rt_wf <- lm_wf %>%
  workflows::update_model(rt_spec)
```


```r
rt_wf
## ══ Workflow ═════════════════════════════════════════════════════════════════
## Preprocessor: Formula
## Model: decision_tree()
## 
## ── Preprocessor ─────────────────────────────────────────────────────────────
## Sale_Price ~ Gr_Liv_Area
## 
## ── Model ────────────────────────────────────────────────────────────────────
## Decision Tree Model Specification (regression)
## 
## Computational engine: rpart
```


```r
rt_wf %>%
  tune::last_fit(ames_split) %>%
  tune::collect_metrics()
## # A tibble: 2 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard   54906.   
## 2 rsq     standard       0.452
```

## KNN


```r
knn_spec <- parsnip::nearest_neighbor() %>%
  parsnip::set_engine("kknn") %>%
  parsnip::set_mode("regression")
```


```r
knn_wf <- rt_wf %>%
  workflows::update_model(knn_spec)
```


```r
knn_wf %>% tune::last_fit(ames_split) %>%
  tune::collect_metrics()
## # A tibble: 2 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard   58943.   
## 2 rsq     standard       0.418
```


```r
lm_wf %>% tune::last_fit(ames_split) %>%
  tune::collect_metrics()
## # A tibble: 2 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard   56478.   
## 2 rsq     standard       0.435
```


```r
rt_wf %>% tune::last_fit(ames_split) %>%
  tune::collect_metrics()
## # A tibble: 2 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard   54906.   
## 2 rsq     standard       0.452
```

## Selecting your metrics

https://tidymodels.github.io/yardstick/reference/index.html


```r
rt_wf %>% tune::last_fit(
  ames_split,
  metrics = yardstick::metric_set(
    yardstick::rmse,
    yardstick::rsq,
    yardstick::mae
    )) %>%
  tune::collect_metrics()
## # A tibble: 3 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard   54906.   
## 2 rsq     standard       0.452
## 3 mae     standard   38035.
```

