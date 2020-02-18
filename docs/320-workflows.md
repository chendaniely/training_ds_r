
# Workflows

1. Transform data: center/scale `Sale_price`
2. Split data
3. Train on the training set
4. Evaluate/predict on the test set

Data Leakage: When information from the test set "leaks" into the training data

1. Split data
2. Transform training set
3. Train on training set
4. Transformation + Evaluate/predict on test set


```r
library(AmesHousing)
library(tidymodels)
## ── Attaching packages ─────────────────────────────────── tidymodels 0.0.3 ──
## ✓ broom     0.5.4     ✓ purrr     0.3.3
## ✓ dials     0.0.4     ✓ recipes   0.1.9
## ✓ dplyr     0.8.4     ✓ rsample   0.0.5
## ✓ ggplot2   3.2.1     ✓ tibble    2.1.3
## ✓ infer     0.5.1     ✓ yardstick 0.0.5
## ✓ parsnip   0.0.5
## ── Conflicts ────────────────────────────────────── tidymodels_conflicts() ──
## x purrr::discard()    masks scales::discard()
## x dplyr::filter()     masks stats::filter()
## x dplyr::lag()        masks stats::lag()
## x ggplot2::margin()   masks dials::margin()
## x recipes::step()     masks stats::step()
## x recipes::yj_trans() masks scales::yj_trans()
```


```r
lm_spec <- parsnip::linear_reg() %>%
  parsnip::set_engine("lm")
```


```r
ames_split <- rsample::initial_split(AmesHousing::make_ames(), prop = 0.75)
```


```r
bb_wf <- workflows::workflow() %>%
  workflows::add_formula(Sale_Price ~ Bedroom_AbvGr + Full_Bath + Half_Bath) %>%
  workflows::add_model(lm_spec)
```


```r
bb_wf
## ══ Workflow ═════════════════════════════════════════════════════════════════
## Preprocessor: Formula
## Model: linear_reg()
## 
## ── Preprocessor ─────────────────────────────────────────────────────────────
## Sale_Price ~ Bedroom_AbvGr + Full_Bath + Half_Bath
## 
## ── Model ────────────────────────────────────────────────────────────────────
## Linear Regression Model Specification (regression)
## 
## Computational engine: lm
```


```r
# fit the final best model to the training set and evaluate the test set
fit_split <- tune::last_fit(bb_wf, ames_split)
fit_split
## # # Monte Carlo cross-validation (0.75/0.25) with 1 resamples  
## # A tibble: 1 x 6
##   splits        id           .metrics      .notes      .predictions    .workflow
## * <list>        <chr>        <list>        <list>      <list>          <list>   
## 1 <split [2.2K… train/test … <tibble [2 ×… <tibble [0… <tibble [732 ×… <workflo…
```


```r
fit_split %>% tune::collect_metrics()
## # A tibble: 2 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard   58504.   
## 2 rsq     standard       0.354
```

## Update formula


```r
all_wf <- bb_wf %>%
  workflows::update_formula(Sale_Price ~ .)

all_wf %>%
  tune::last_fit(ames_split) %>%
  tune::collect_metrics()
## ! Resample1: model (predictions): prediction from a rank-deficient fit may be misleading
## # A tibble: 2 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard   38981.   
## 2 rsq     standard       0.758
```

## Update Model

Update to fit a regression decision tree


```r
rt_spec <- 
  parsnip::decision_tree() %>%
  parsnip::set_engine(engine = "rpart") %>% 
  parsnip::set_mode("regression")
```


```r
rt_wf <- 
  all_wf %>% 
  workflows::update_model(rt_spec)
```


```r
all_fitwf <- rt_wf %>%
  tune::last_fit(ames_split)

all_fitwf %>%
  tune::collect_metrics()
## # A tibble: 2 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard   39730.   
## 2 rsq     standard       0.701
```


```r
all_fitwf %>% tune::collect_predictions()
## # A tibble: 732 x 4
##    id                 .pred  .row Sale_Price
##    <chr>              <dbl> <int>      <int>
##  1 train/test split 107845.     2     105000
##  2 train/test split 137889.     3     172000
##  3 train/test split 167715.     8     191500
##  4 train/test split 168788.    10     189000
##  5 train/test split 167715.    14     171500
##  6 train/test split 344321.    16     538000
##  7 train/test split 194020.    17     164000
##  8 train/test split 168788.    21     190000
##  9 train/test split 137889.    25     149900
## 10 train/test split 107845.    27     126000
## # … with 722 more rows
```

## Get workflow components


```r
all_fitwf %>%
  purrr::pluck(".workflow", 1) %>%
  workflows::pull_workflow_fit() # return parsnip model fit
## parsnip model object
## 
## Fit time:  986ms 
## n= 2198 
## 
## node), split, n, deviance, yval
##       * denotes terminal node
## 
##  1) root 2198 1.487210e+13 182194.9  
##    2) Garage_Cars< 2.5 1897 5.662631e+12 161558.3  
##      4) Gr_Liv_Area< 1416.5 1015 1.286642e+12 134100.4  
##        8) Year_Built< 1976.5 739 6.375992e+11 121546.1  
##         16) Total_Bsmt_SF< 908.5 402 2.968270e+11 107845.4 *
##         17) Total_Bsmt_SF>=908.5 337 1.753004e+11 137889.3 *
##        9) Year_Built>=1976.5 276 2.207027e+11 167715.1 *
##      5) Gr_Liv_Area>=1416.5 882 2.730102e+12 193156.7  
##       10) Exter_QualTypical>=0.5 496 8.861079e+11 168788.4 *
##       11) Exter_QualTypical< 0.5 386 1.170994e+12 224469.4  
##         22) Total_Bsmt_SF< 1013.5 190 3.063697e+11 194020.5 *
##         23) Total_Bsmt_SF>=1013.5 196 5.177049e+11 253986.2 *
##    3) Garage_Cars>=2.5 301 3.310123e+12 312253.4  
##      6) Total_Bsmt_SF< 1732.5 210 1.186234e+12 273081.4  
##       12) Year_Remod_Add< 1990.5 24 4.891929e+10 149116.7 *
##       13) Year_Remod_Add>=1990.5 186 7.209114e+11 289076.8  
##         26) Gr_Liv_Area< 2323 125 2.147973e+11 262117.8 *
##         27) Gr_Liv_Area>=2323 61 2.290998e+11 344320.8 *
##      7) Total_Bsmt_SF>=1732.5 91 1.058039e+12 402650.4  
##       14) Gr_Liv_Area< 2217 59 2.127745e+11 356679.9 *
##       15) Gr_Liv_Area>=2217 32 4.906959e+11 487408.3 *
```


```r
all_fitwf %>%
  purrr::pluck(".workflow", 1) %>%
  workflows::pull_workflow_spec()
## Decision Tree Model Specification (regression)
## 
## Computational engine: rpart
```
