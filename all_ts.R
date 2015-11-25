# Generalised code for all time series methods.
# Install latest version of forecast
rm(list=ls())
library(forecast)

# Setup ------------------------------------------------
myTS <- AirPassengers
len <- length(myTS)
train_end <- floor(len*0.7)
train <- window(myTS, time(myTS)[1], time(myTS)[len*0.7])
test <- window(myTS, time(myTS)[train_end+1], time(myTS)[len])
fc_period <- length(test)

# auto.arima
autoarima_mod <- auto.arima(train)
autoarima_fc <- forecast(autoarima_mod, fc_period)$mean

# auto.arima with external regressors: Fourier transform
tryCatch(autoarima_fouriermod <- auto.arima(train, xreg=fourier(train, 4)), 
         error=function(err){
           cat("Fourier mod could not be fit, so running auto.arima instead.")
           autoarima_fouriermod <- auto.arima(train); 
         })

autoarima_fourierfc <- forecast(autoarima_fouriermod, fc_period, xreg=fourierf(train, 4, fc_period))$mean

# auto.arima with external regressors: seasonal dummy
tryCatch(autoarima_seasonaldummymod <- auto.arima(train, xreg=seasonaldummy(train)), 
         error=function(err){
           cat("Seasonaldummy mod could not be fit, so running auto.arima instead.")
           autoarima_seasonaldummymod <- auto.arima(train); 
         })

autoarima_seasonaldummyfc <- forecast(autoarima_seasonaldummymod, fc_period, xreg=seasonaldummyf(train, fc_period))$mean

# hw: holt winters
hw_additivefc <- hw(train, fc_period, seasonal="additive", damped=F)$mean
hw_additivedampedfc <- hw(train, fc_period, seasonal="additive", damped=T)$mean
hw_multiplicativefc <- hw(train, fc_period, seasonal="multiplicative", damped=F)$mean
hw_multiplicativedampedfc <- hw(train, fc_period, seasonal="multiplicative", damped=T)$mean

# naive
naive_fc <- naive(train, fc_period)$mean

# snaive: seasonal naive
snaive_fc <- snaive(train, fc_period)

# rwf: random walk forecasts
rwf_fc <- rwf(train, fc_period)$mean

# nnet: neural network
nnetar_mod <- nnetar(train)
nnetar_fc <- forecast(nnetar_mod, fc_period)$mean

# splinef with generalised cross validation
splinef_gcvfc <- splinef(train, fc_period, method="gcv")$mean

# splinef with maximum likelihood 
splinef_mlefc <- splinef(train, fc_period, method="mle")$mean

# bats: Exponential smoothing state space model with Box-Cox transformation, ARMA errors, Trend and Seasonal components
bats_mod <- bats(train)
bats_fc <- forecast(bats_mod, fc_period)$mean

# tbats: Exponential smoothing state space model with Box-Cox transformation, ARMA errors, Trend and Seasonal components
tbats_mod <- tbats(train)
tbats_fc <- forecast(tbats_mod, fc_period)$mean

# sindexf: seasonal index forecast
holt_fc <- holt(train, fc_period)
sindex_mod <- sindexf(stl(train, robust = T, s.window = "periodic"), fc_period)
sindex_fc <- holt_fc$mean + sindex_mod

# meanf
mean_fc <- meanf(train, fc_period)$mean

# thetaf: equivalent to simple exponential smoothing with drift
thetaf_fc <- thetaf(train, fc_period)$mean

# msts: multi seasonal time series
msts_mod <- msts(train, seasonal.periods = findfrequency(train))  # findfrequency computed the most dominant seasonal period.
msts_fc <- forecast(msts_mod, fc_period)$mean

# ses: Simple exponential smoothing
ses_fc <- ses(train, fc_period)$mean

# ma: Moving average smoothing
ma_mod <- ma(train, order=3)
ma_fc <- forecast(ma_mod, fc_period)$mean

# tslm: linear model with seaonal and trend components.
tslm_mod <- tslm(train ~ season + trend)
tslm_fc <- forecast(tslm_mod, h=fc_period)$mean


# Collect all forecasts and Compute Accuracy ------------------------------

all_fcs <- data.frame(autoarima_fc, autoarima_fourierfc, autoarima_seasonaldummyfc, 
                      hw_additivefc, hw_additivedampedfc, hw_multiplicativefc, 
                      hw_multiplicativedampedfc, naive_fc, rwf_fc, nnetar_fc, 
                      splinef_gcvfc=splinef_gcvfc, splinef_mlefc=splinef_mlefc, 
                      bats_fc, tbats_fc, sindex_fc, 
                      mean_fc, thetaf_fc, msts_fc, ses_fc, ma_fc, tslm_fc)

all_accuracy <- as.data.frame(apply(all_fcs, 2, FUN = function(x, y=test){return(accuracy(y, x))}))
rownames(all_accuracy) <- c( "ME", "RMSE", "MAE", "MPE", "MAPE")
