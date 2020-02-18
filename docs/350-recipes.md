
# Recipes

The pre-processing step

https://tidymodels.github.io/recipes/reference/index.html


```r
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
library(AmesHousing)
```


```r
ames <- AmesHousing::make_ames()
```


```r
rec <- recipes::recipe(Sale_Price ~ ., data = ames)
```


```r
rec %>% 
  step_novel(all_nominal()) %>%
  step_zv(all_predictors())
## Data Recipe
## 
## Inputs:
## 
##       role #variables
##    outcome          1
##  predictor         80
## 
## Operations:
## 
## Novel factor level assignment for all_nominal
## Zero variance filter on all_predictors
```

## PCA


```r
rec <- recipes::recipe(Sale_Price ~ .,
                       data = ames) %>%
  recipes::step_center(all_numeric()) %>% 
  recipes::step_scale(all_numeric())
```

### Prep/bake

- `prep`: trains a dataset
- `bake`: apply a trained model to new data

However, you do not need to do this since the `fit` functions do this for you too


```r
rec %>%
  recipes::prep(training = ames) %>%
  recipes::bake(new_data = ames)
## # A tibble: 2,930 x 81
##    MS_SubClass MS_Zoning Lot_Frontage Lot_Area Street Alley Lot_Shape
##    <fct>       <fct>            <dbl>    <dbl> <fct>  <fct> <fct>    
##  1 One_Story_… Resident…       2.49     2.74   Pave   No_A… Slightly…
##  2 One_Story_… Resident…       0.667    0.187  Pave   No_A… Regular  
##  3 One_Story_… Resident…       0.697    0.523  Pave   No_A… Slightly…
##  4 One_Story_… Resident…       1.06     0.128  Pave   No_A… Regular  
##  5 Two_Story_… Resident…       0.488    0.467  Pave   No_A… Slightly…
##  6 Two_Story_… Resident…       0.608   -0.0216 Pave   No_A… Slightly…
##  7 One_Story_… Resident…      -0.497   -0.663  Pave   No_A… Regular  
##  8 One_Story_… Resident…      -0.437   -0.653  Pave   No_A… Slightly…
##  9 One_Story_… Resident…      -0.557   -0.604  Pave   No_A… Slightly…
## 10 Two_Story_… Resident…       0.0702  -0.336  Pave   No_A… Regular  
## # … with 2,920 more rows, and 74 more variables: Land_Contour <fct>,
## #   Utilities <fct>, Lot_Config <fct>, Land_Slope <fct>, Neighborhood <fct>,
## #   Condition_1 <fct>, Condition_2 <fct>, Bldg_Type <fct>, House_Style <fct>,
## #   Overall_Qual <fct>, Overall_Cond <fct>, Year_Built <dbl>,
## #   Year_Remod_Add <dbl>, Roof_Style <fct>, Roof_Matl <fct>,
## #   Exterior_1st <fct>, Exterior_2nd <fct>, Mas_Vnr_Type <fct>,
## #   Mas_Vnr_Area <dbl>, Exter_Qual <fct>, Exter_Cond <fct>, Foundation <fct>,
## #   Bsmt_Qual <fct>, Bsmt_Cond <fct>, Bsmt_Exposure <fct>,
## #   BsmtFin_Type_1 <fct>, BsmtFin_SF_1 <dbl>, BsmtFin_Type_2 <fct>,
## #   BsmtFin_SF_2 <dbl>, Bsmt_Unf_SF <dbl>, Total_Bsmt_SF <dbl>, Heating <fct>,
## #   Heating_QC <fct>, Central_Air <fct>, Electrical <fct>, First_Flr_SF <dbl>,
## #   Second_Flr_SF <dbl>, Low_Qual_Fin_SF <dbl>, Gr_Liv_Area <dbl>,
## #   Bsmt_Full_Bath <dbl>, Bsmt_Half_Bath <dbl>, Full_Bath <dbl>,
## #   Half_Bath <dbl>, Bedroom_AbvGr <dbl>, Kitchen_AbvGr <dbl>,
## #   Kitchen_Qual <fct>, TotRms_AbvGrd <dbl>, Functional <fct>,
## #   Fireplaces <dbl>, Fireplace_Qu <fct>, Garage_Type <fct>,
## #   Garage_Finish <fct>, Garage_Cars <dbl>, Garage_Area <dbl>,
## #   Garage_Qual <fct>, Garage_Cond <fct>, Paved_Drive <fct>,
## #   Wood_Deck_SF <dbl>, Open_Porch_SF <dbl>, Enclosed_Porch <dbl>,
## #   Three_season_porch <dbl>, Screen_Porch <dbl>, Pool_Area <dbl>,
## #   Pool_QC <fct>, Fence <fct>, Misc_Feature <fct>, Misc_Val <dbl>,
## #   Mo_Sold <dbl>, Year_Sold <dbl>, Sale_Type <fct>, Sale_Condition <fct>,
## #   Longitude <dbl>, Latitude <dbl>, Sale_Price <dbl>
```

### Dummy variables

- aka one-hot encoding
- You don't need this for decision trees or ensembles of trees


```r
rec %>%
  recipes::step_dummy(all_nominal())
## Data Recipe
## 
## Inputs:
## 
##       role #variables
##    outcome          1
##  predictor         80
## 
## Operations:
## 
## Centering for all_numeric
## Scaling for all_numeric
## Dummy variables from all_nominal
```

### Step novel

- A catch all for new categories that the model may not have trained on
- Do this before dummy encoding


```r
rec %>%
  recipes::step_novel(all_nominal()) %>%
  recipes::step_dummy(all_nominal())
## Data Recipe
## 
## Inputs:
## 
##       role #variables
##    outcome          1
##  predictor         80
## 
## Operations:
## 
## Centering for all_numeric
## Scaling for all_numeric
## Novel factor level assignment for all_nominal
## Dummy variables from all_nominal
```

### remove 0 variance

- Remove columns where there is only 1 value in it


```r
rec %>%
  recipes::step_novel(all_nominal()) %>%
  recipes::step_dummy(all_nominal()) %>%
  recipes::step_zv(all_predictors())
## Data Recipe
## 
## Inputs:
## 
##       role #variables
##    outcome          1
##  predictor         80
## 
## Operations:
## 
## Centering for all_numeric
## Scaling for all_numeric
## Novel factor level assignment for all_nominal
## Dummy variables from all_nominal
## Zero variance filter on all_predictors
```

### PCA


```r
rec %>%
  recipes::step_novel(all_nominal()) %>%
  recipes::step_dummy(all_nominal()) %>%
  recipes::step_zv(all_predictors()) %>%
  recipes::step_pca(all_numeric(), num_comp = 5)
## Data Recipe
## 
## Inputs:
## 
##       role #variables
##    outcome          1
##  predictor         80
## 
## Operations:
## 
## Centering for all_numeric
## Scaling for all_numeric
## Novel factor level assignment for all_nominal
## Dummy variables from all_nominal
## Zero variance filter on all_predictors
## No PCA components were extracted.
```

## Exercise

Write a recipe for the `Sale_Price ~ .` variables that:

1. Adds a novel level to all factors
2. Converts all factors to dummy variables
3. Catches any zero variance variables
4. Centers all of the predictors
5. Scales all of the predictors
6. Computes the first 5 principal components

Save the result as `pca_rec`

### Solution


```r
pca_rec <-
  recipe(Sale_Price ~ ., data = ames) %>%
  step_novel(all_nominal()) %>%
  step_dummy(all_nominal()) %>%
  step_zv(all_predictors()) %>%
  step_center(all_predictors()) %>%
  step_scale(all_predictors()) %>%
  step_pca(all_predictors(), num_comp = 5)
```

## Put it all together

1. Split the ames data (rsample)
2. Create a `lm_spec` (parsnip)
3. Create a `pca_rec` recipe (recipe)
4. Create a workflow (workflows)
5. Fit model (tune)

### Solution


```r
ames_split <- rsample::initial_split(ames)
ames_train <- rsample::training(ames_split)
ames_test <- rsample::testing(ames_split)
```



```r
lm_spec <- parsnip::linear_reg() %>%
  parsnip::set_engine("lm")
```


```r
pca_rec <-
  recipe(Sale_Price ~ ., data = ames_train) %>%
  step_novel(all_nominal()) %>%
  step_dummy(all_nominal()) %>%
  step_zv(all_predictors()) %>%
  step_center(all_predictors()) %>%
  step_scale(all_predictors()) %>%
  step_pca(all_predictors(), num_comp = 5)
```


```r
pca_wf <- workflows::workflow() %>%
  workflows::add_recipe(pca_rec) %>%
  workflows::add_model(lm_spec)
pca_wf
## ══ Workflow ═════════════════════════════════════════════════════════════════
## Preprocessor: Recipe
## Model: linear_reg()
## 
## ── Preprocessor ─────────────────────────────────────────────────────────────
## 6 Recipe Steps
## 
## ● step_novel()
## ● step_dummy()
## ● step_zv()
## ● step_center()
## ● step_scale()
## ● step_pca()
## 
## ── Model ────────────────────────────────────────────────────────────────────
## Linear Regression Model Specification (regression)
## 
## Computational engine: lm
```

```r
pca_wf %>%
  tune::last_fit(ames_split) %>%
  tune::collect_metrics()
## # A tibble: 2 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard   40883.   
## 2 rsq     standard       0.710
```
