# Forecasting Hourly American Energy Consumption Using Facebook's Prophet Model
## Overview:
The data is an hourly series of energy consumption (in MW), from an eastern seaboard energy provider, PJM. Due to the hourly nature of the data, the complex seasonality is sure to present a problem for traditional ARIMA/ETS models. Therefore, I leverage Facebook's Prophet model, which is specifically designed to handle high frequency data with complex seasonality (daily, monthly, yearly, holidays, etc). 

The resulting model is **highly accurate**.

## Results:
I use the last 14 days (336 hours) of data as a testing set; to compare forecasted values to actual values. The figure below plots fitted and actual values, along with confidence intervals.

![forecast](https://user-images.githubusercontent.com/52394699/181165620-c63f9f82-a414-46c1-9b48-c11ebf0c24cb.png)

The model had a Mean Absolute Error **(MAE) of 1218**, and a Mean Absolute Percent Error **(MAPE) of 8.68**. For MAPE, this means that on average, predictions are about 8.7% off. Standard convention suggests models with MAPE < 10 are "highly accurate." In particular, having such a low MAPE on a large forecast horizon of 336 (14 days) is especially impressive.

## Trends and Seasonality:
![components](https://user-images.githubusercontent.com/52394699/181166590-45197bf5-d8f7-43f0-ac96-9e30cbb02138.png)

Looking at weekly seasonality, the lowest consumption is on saturdays and sundays, perhaps due to businesses not being open. Yearly seasonality looks a bit complex, with peaks in Janruary/February and over the summer months. This may be due to heat needed in the winter, and AC in the summer, with neither in the spring/fall. Finally, looking at daily seasonality, we clearly see a pattern of higher usage between waking hours of ~6am to 10pm. 

## Tuning Parameters:
The Prophet model has few tuning parameters. I only changed the seasonality mode from the default additive to multiplicative. The default mode assumes that each seasonality (say christmas for instance) adds X units of consumption, everytime. Multiplicative instead assumes that christmas time adds X% instead.

The next parameter to tune was the changepoints parameter. The Prophet model searches for points in the model where the data generating process may change (changepoints). If the model picks up lots of changepoints and they don't exist, then this may lead to overfitting. With the high cyclical nature of the data, the default level led to a lot of changepoints and so I reduced the changepoint threshold and this led to less overfitting and lower MAE. 

## Note on Speed:
One of the main benefits of the Prophet model is its speed. With 121,273 observations, most time series models would grind to a halt. However this script only takes about 1-2 minutes to run on an Intel i7-8700k. 

The ability of Prophet to be lightning fast and output a model with such high accuracy is remarkable, and Prophet should be in any forecaster's toolbelt for forecasting data with a frequency below monthly. 
