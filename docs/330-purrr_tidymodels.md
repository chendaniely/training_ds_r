
# Purrr + tidymodel objects


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


## Exercise: Train on split data


```r
ames <- AmesHousing::make_ames()
```


```r
ames_split <- rsample::initial_split(ames,
                                    strata = Sale_Price,
                                    breaks = 4)
```


```r
ames_train  <- training(ames_split)
ames_test   <- testing(ames_split)
```


```r
lm_spec <- parsnip::linear_reg() %>%
  parsnip::set_engine("lm")

lm_fit <- workflows::workflow() %>%
  workflows::add_formula(Sale_Price ~ Gr_Liv_Area) %>%
  workflows::add_model(lm_spec) %>%
  parsnip::fit(data = ames_train)
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
## 1 rmse    standard      53810.
```
## Pass the split object


```r
lm_split <- workflows::workflow() %>%
  workflows::add_formula(Sale_Price ~ Gr_Liv_Area) %>%
  workflows::add_model(lm_spec) %>%
  tune::last_fit(ames_split)
  
```


```r
lm_split
## # # Monte Carlo cross-validation (0.75/0.25) with 1 resamples  
## # A tibble: 1 x 6
##   splits        id           .metrics      .notes      .predictions    .workflow
## * <list>        <chr>        <list>        <list>      <list>          <list>   
## 1 <split [2.2K… train/test … <tibble [2 ×… <tibble [0… <tibble [731 ×… <workflo…
```

## Question

1. What does the `splits` column contain


```r
simple_split <- lm_split %>%
  dplyr::select(splits, id)
```


```r
simple_split
## # # Monte Carlo cross-validation (0.75/0.25) with 1 resamples  
## # A tibble: 1 x 2
##   splits             id              
## * <list>             <chr>           
## 1 <split [2.2K/731]> train/test split
```

## Exercise

1. How can you just return the contents of the first cell in splits?


```r
simple_split[["splits"]][[1]]
## <2199/731/2930>
simple_split[[1, 1]]
## <2199/731/2930>
simple_split %>% magrittr::extract2("splits") %>% 
  magrittr::extract2(1)
## <2199/731/2930>
simple_split %>% purrr::pluck("splits", 1)
## <2199/731/2930>
```

2. What's the difference between the output of these 2 results?


```r
simple_split %>%
  pluck("splits")
## [[1]]
## <2199/731/2930>
```


```r
simple_split %>%
  pluck("splits", 1)
## <2199/731/2930>
```

## `map` functions


```r
simple_split %>%
  pluck("splits") %>%
  map(rsample::testing)
## [[1]]
## # A tibble: 731 x 81
##    MS_SubClass MS_Zoning Lot_Frontage Lot_Area Street Alley Lot_Shape
##    <fct>       <fct>            <dbl>    <int> <fct>  <fct> <fct>    
##  1 One_Story_… Resident…          141    31770 Pave   No_A… Slightly…
##  2 Two_Story_… Resident…           78     9978 Pave   No_A… Slightly…
##  3 One_Story_… Resident…            0     7980 Pave   No_A… Slightly…
##  4 One_Story_… Resident…            0     6820 Pave   No_A… Slightly…
##  5 One_Story_… Resident…           85    13175 Pave   No_A… Regular  
##  6 One_Story_… Resident…            0    12537 Pave   No_A… Slightly…
##  7 One_Story_… Resident…           70     8400 Pave   No_A… Regular  
##  8 One_Story_… Resident…           70    10500 Pave   No_A… Regular  
##  9 One_Story_… Resident…           94    12883 Pave   No_A… Slightly…
## 10 One_Story_… Resident…           95    12182 Pave   No_A… Regular  
## # … with 721 more rows, and 74 more variables: Land_Contour <fct>,
## #   Utilities <fct>, Lot_Config <fct>, Land_Slope <fct>, Neighborhood <fct>,
## #   Condition_1 <fct>, Condition_2 <fct>, Bldg_Type <fct>, House_Style <fct>,
## #   Overall_Qual <fct>, Overall_Cond <fct>, Year_Built <int>,
## #   Year_Remod_Add <int>, Roof_Style <fct>, Roof_Matl <fct>,
## #   Exterior_1st <fct>, Exterior_2nd <fct>, Mas_Vnr_Type <fct>,
## #   Mas_Vnr_Area <dbl>, Exter_Qual <fct>, Exter_Cond <fct>, Foundation <fct>,
## #   Bsmt_Qual <fct>, Bsmt_Cond <fct>, Bsmt_Exposure <fct>,
## #   BsmtFin_Type_1 <fct>, BsmtFin_SF_1 <dbl>, BsmtFin_Type_2 <fct>,
## #   BsmtFin_SF_2 <dbl>, Bsmt_Unf_SF <dbl>, Total_Bsmt_SF <dbl>, Heating <fct>,
## #   Heating_QC <fct>, Central_Air <fct>, Electrical <fct>, First_Flr_SF <int>,
## #   Second_Flr_SF <int>, Low_Qual_Fin_SF <int>, Gr_Liv_Area <int>,
## #   Bsmt_Full_Bath <dbl>, Bsmt_Half_Bath <dbl>, Full_Bath <int>,
## #   Half_Bath <int>, Bedroom_AbvGr <int>, Kitchen_AbvGr <int>,
## #   Kitchen_Qual <fct>, TotRms_AbvGrd <int>, Functional <fct>,
## #   Fireplaces <int>, Fireplace_Qu <fct>, Garage_Type <fct>,
## #   Garage_Finish <fct>, Garage_Cars <dbl>, Garage_Area <dbl>,
## #   Garage_Qual <fct>, Garage_Cond <fct>, Paved_Drive <fct>,
## #   Wood_Deck_SF <int>, Open_Porch_SF <int>, Enclosed_Porch <int>,
## #   Three_season_porch <int>, Screen_Porch <int>, Pool_Area <int>,
## #   Pool_QC <fct>, Fence <fct>, Misc_Feature <fct>, Misc_Val <int>,
## #   Mo_Sold <int>, Year_Sold <int>, Sale_Type <fct>, Sale_Condition <fct>,
## #   Sale_Price <int>, Longitude <dbl>, Latitude <dbl>
```

## Exercise

Create a column in `simple_split` that contains
the training set data frame. Name the column `train_set`.


```r
simple_split %>%
  dplyr::mutate(train_set = purrr::map(splits, training))
## # # Monte Carlo cross-validation (0.75/0.25) with 1 resamples  
## # A tibble: 1 x 3
##   splits             id               train_set            
## * <list>             <chr>            <list>               
## 1 <split [2.2K/731]> train/test split <tibble [2,199 × 81]>
```

## `unnest`

Expanding a list column


```r
simple_split %>%
  dplyr::mutate(train_set = purrr::map(splits, training)) %>%
  tidyr::unnest(train_set)
## # A tibble: 2,199 x 83
##    splits id    MS_SubClass MS_Zoning Lot_Frontage Lot_Area Street Alley
##    <list> <chr> <fct>       <fct>            <dbl>    <int> <fct>  <fct>
##  1 <spli… trai… One_Story_… Resident…           80    11622 Pave   No_A…
##  2 <spli… trai… One_Story_… Resident…           81    14267 Pave   No_A…
##  3 <spli… trai… One_Story_… Resident…           93    11160 Pave   No_A…
##  4 <spli… trai… Two_Story_… Resident…           74    13830 Pave   No_A…
##  5 <spli… trai… One_Story_… Resident…           41     4920 Pave   No_A…
##  6 <spli… trai… One_Story_… Resident…           43     5005 Pave   No_A…
##  7 <spli… trai… One_Story_… Resident…           39     5389 Pave   No_A…
##  8 <spli… trai… Two_Story_… Resident…           60     7500 Pave   No_A…
##  9 <spli… trai… Two_Story_… Resident…           75    10000 Pave   No_A…
## 10 <spli… trai… Two_Story_… Resident…           63     8402 Pave   No_A…
## # … with 2,189 more rows, and 75 more variables: Lot_Shape <fct>,
## #   Land_Contour <fct>, Utilities <fct>, Lot_Config <fct>, Land_Slope <fct>,
## #   Neighborhood <fct>, Condition_1 <fct>, Condition_2 <fct>, Bldg_Type <fct>,
## #   House_Style <fct>, Overall_Qual <fct>, Overall_Cond <fct>,
## #   Year_Built <int>, Year_Remod_Add <int>, Roof_Style <fct>, Roof_Matl <fct>,
## #   Exterior_1st <fct>, Exterior_2nd <fct>, Mas_Vnr_Type <fct>,
## #   Mas_Vnr_Area <dbl>, Exter_Qual <fct>, Exter_Cond <fct>, Foundation <fct>,
## #   Bsmt_Qual <fct>, Bsmt_Cond <fct>, Bsmt_Exposure <fct>,
## #   BsmtFin_Type_1 <fct>, BsmtFin_SF_1 <dbl>, BsmtFin_Type_2 <fct>,
## #   BsmtFin_SF_2 <dbl>, Bsmt_Unf_SF <dbl>, Total_Bsmt_SF <dbl>, Heating <fct>,
## #   Heating_QC <fct>, Central_Air <fct>, Electrical <fct>, First_Flr_SF <int>,
## #   Second_Flr_SF <int>, Low_Qual_Fin_SF <int>, Gr_Liv_Area <int>,
## #   Bsmt_Full_Bath <dbl>, Bsmt_Half_Bath <dbl>, Full_Bath <int>,
## #   Half_Bath <int>, Bedroom_AbvGr <int>, Kitchen_AbvGr <int>,
## #   Kitchen_Qual <fct>, TotRms_AbvGrd <int>, Functional <fct>,
## #   Fireplaces <int>, Fireplace_Qu <fct>, Garage_Type <fct>,
## #   Garage_Finish <fct>, Garage_Cars <dbl>, Garage_Area <dbl>,
## #   Garage_Qual <fct>, Garage_Cond <fct>, Paved_Drive <fct>,
## #   Wood_Deck_SF <int>, Open_Porch_SF <int>, Enclosed_Porch <int>,
## #   Three_season_porch <int>, Screen_Porch <int>, Pool_Area <int>,
## #   Pool_QC <fct>, Fence <fct>, Misc_Feature <fct>, Misc_Val <int>,
## #   Mo_Sold <int>, Year_Sold <int>, Sale_Type <fct>, Sale_Condition <fct>,
## #   Sale_Price <int>, Longitude <dbl>, Latitude <dbl>
```


```r
lm_split
## # # Monte Carlo cross-validation (0.75/0.25) with 1 resamples  
## # A tibble: 1 x 6
##   splits        id           .metrics      .notes      .predictions    .workflow
## * <list>        <chr>        <list>        <list>      <list>          <list>   
## 1 <split [2.2K… train/test … <tibble [2 ×… <tibble [0… <tibble [731 ×… <workflo…
```


```r
lm_split %>%
  tidyr::unnest(.metrics)
## # A tibble: 2 x 8
##   splits    id      .metric .estimator .estimate .notes  .predictions  .workflow
##   <list>    <chr>   <chr>   <chr>          <dbl> <list>  <list>        <list>   
## 1 <split [… train/… rmse    standard   53810.    <tibbl… <tibble [731… <workflo…
## 2 <split [… train/… rsq     standard       0.529 <tibbl… <tibble [731… <workflo…
```

`collect_metrics` is a shortcut.


```r
lm_split %>% tune::collect_metrics()
## # A tibble: 2 x 3
##   .metric .estimator .estimate
##   <chr>   <chr>          <dbl>
## 1 rmse    standard   53810.   
## 2 rsq     standard       0.529
```
