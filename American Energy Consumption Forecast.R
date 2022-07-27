library(prophet)
library(ggplot)


# Data:
setwd("G:/My Drive/R Projects/American Energy Consumption/")
data <- read.csv("AEP_hourly.csv")
data <- data[(order(data$Datetime)),]
plot(data$AEP_MW, type='l')

# Prohpet requiring specific naming scheme:
data.prophet <- data.frame(ds = data$Datetime, y = data$AEP_MW)


# Forecasting 14 days ahead (336 hours)
# Train and test set:
data.prophet.train <- data.prophet[1:(length(data.prophet$ds)-336),]
data.prophet.test <- data.prophet[120938:121273,]

# Chose multiplicative seasonality as that seemed to perform better than additive
# With the default changepoint=0.05, the model was overfitting, so reducing it reduced the overfit:
# Following the Prophet guide, I set the overfit to the minimum recommended value
model <- prophet(data.prophet.train, seasonality.mode = 'multiplicative', changepoint.prior.scale = 0.0001)


# Constructed the future dates to forecast:
future <- make_future_dataframe(model, periods = 336, freq = 3600, include_history=FALSE)
forecast <- predict(model, future)


# Constructing the dataframe with forecasts:
data.prophet.test$yhat <- forecast$yhat
data.prophet.test$yhat_lower <- forecast$yhat_lower
data.prophet.test$yhat_upper <- forecast$yhat_upper
# Figuring out the mean absolute error:
data.prophet.test$errors <- data.prophet.test$y-data.prophet.test$yhat
mean(abs(data.prophet.test$errors))


# Plotting:
colors <- c("True Values" = 'black', "Fitted Values" = "steelblue", 'Confidence Interval' = 'lightblue')
ggplot(data.prophet.test, aes(x=ds, group=1), alpha=1) +
  geom_line(aes(y=y, col='True Values'), size=1) +
  geom_line(aes(y = yhat, col='Fitted Values'), size=1) + 
  geom_ribbon(aes(ymin=yhat_lower, ymax=yhat_upper), fill='lightblue', alpha=0.4) +
  labs(x="Date",
       y="Electricity Consumption (MW)") +
  ggtitle("Prophet Forecast of Hourly Electricity Consumption in America") +
  scale_x_discrete(guide=guide_axis(check.overlap=TRUE)) +
  scale_color_manual(values = colors) +
  theme(legend.title=element_blank()) +
  theme(axis.line.x=element_line(color='black', size=0.75, linetype='solid'),
        axis.line.y=element_line(color='black', size=0.75, linetype='solid'),
        panel.background=element_rect('white', 'white', size=0.5),
        legend.key=element_rect(fill='transparent', color='transparent'))


# Understanding seasonalities and trends:
prophet_plot_components(model, forecast)
# Decomposing we see that saturday and sunday actually have lowest energy consumption. Perhaps businesses shutdown?
# Day of the year has some seasonality. Appears to be highest in Jan/Feb, peak again in summer around August, and climbs back up
# In terms of hour of day, seems to make sense. Early morning hours are low, and from about 8am to 8pm consumption is high.


# Plotting the change points to see if model is overfitting
# There is basically a change point after every cycle, which may be overfitting.
plot(model, forecast) + add_changepoints_to_plot(model)
