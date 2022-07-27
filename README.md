# Forecasting Hourly American Energy Consumption Using Facebook's Prophet Model
## Overview:
The data is an hourly series of energy consumption (in MW), from an eastern seaboard energy provider, PJM. Due to the hourly nature of the data, the complex seasonality is sure to present a problem for traditional ARIMA/ETS models. Therefore, I leverage Facebook's Prophet model, which is specifically designed to handle high frequency data with complex seasonality (daily, monthly, yearly, holidays, etc). 

## Results:
I use the last 14 days (336 hours) of data as a testing set; to compare forecasted values to actual values. The figure below plots fitted and actual values, along with confidence intervals.

![forecast](https://user-images.githubusercontent.com/52394699/181165620-c63f9f82-a414-46c1-9b48-c11ebf0c24cb.png)

With an mean absolute error of 1218, the forecast does pretty well. The model clearly struggles to capture the sharp daily downtrend, but on other parts of the data does fairly well. 

## Trends and Seasonality:
![components](https://user-images.githubusercontent.com/52394699/181166590-45197bf5-d8f7-43f0-ac96-9e30cbb02138.png)

The trend appears to go down with time, perhaps due to higher efficiency appliances offsetting higher population levels.

Looking at weekly seasonality, the lowest consumption is on saturdays and sundays, perhaps due to businesses not being open. Yearly seasonality looks a bit complex, with peaks in Janruary/February and over the summer months. This may be due to heat needed in the winter, and AC in the summer, with neither in the spring/fall. Finally, looking at daily seasonality, we clearly see a pattern of higher usage between waking hours of ~8am to 8pm. 
## Tuning Parameters:
The Prophet model has few tuning parameters. I only changed the seasonality mode from the default additive to multiplicative. The default mode assumes that each seasonality (say christmas for instance) adds X units of consumption, everytime. Multiplicative instead assumes that christmas time adds X% instead.

The next parameter to tune was the changepoints parameter. The Prophet model searches for points in the model where the data generating process may change (changepoints). If the model picks up lots of changepoints and they don't exist, then this may lead to overfitting. With the high cyclical nature of the data, the default level led to a lot of changepoints and so I reduced the changepoint threshold and this led to less overfitting and lower MAE. 
