#  Section 4 Notes
#  Linear and Logistic Regression

#1 
#  The Purpose - When and how to use linear regression?
# 
#  Linear regression is the most important technique in predictive modeling. It is essential that you understand the concepts well. So this, is probably the most important section you want to learn if you are serious about a high paying career in data science and machine learning.
# 
#  Questions:
# - When and what kind of problems can be solved using linear regression?
#   Ans: Imagine you are a agronomist studying a certain crop yield. You are studying various 
#   factors such as the amount of rainfall, sunlight, soil type etc and how that affects the 
#   crop yield. So you gather lots of data from multiple farms at various locations. 
#   
#   Using this data, you want to predict the crop yield at a cerain farm, that received a 
#   given amount of rainfall, soil type and sunlight. In this case you can use linear regression 
#   to predict the crop yield. This is just one situation, but we can imagine numerous problem 
#   settings like this where we can use this technique. 

#   For instance consider the cars dataset. 
#   Imagine we have only 70% of these obserations. We can use linear regression on the known 70% 
#   of the data. Build a regression model on that (which we will see in a moment) and then use 
#   that model and the X variable (i.e. speed) to predict the Y variable (i.e. distance).
#   The important thing you need to remember is that the Y has to be a continuous numeric 
#   variable and whereas the X can be anything - either categorical or continuous.

#   IMPORTANT: State that, I am directly building a linear regression model here because 'cars' 
#   is a standard and popular dataset used for this purpose. In this video we will learn when 
#   to use linear regression, how to build a linear model and how to interpret the results. 
#   I am showing this to you first because, you will have a better understanding of the concepts 
#   and be able to appreciate why we do what we are doing. The full structured process 
#   of building a linear regression model will start from video 3 of this section, but I 
#   highly recommend you go in the sequence I have made this so things will fall in place perfectly.

# Show a very simple example using 'cars' dataset and show model summary. 

  trainingData <- cars[1:40, ]
  testData <- cars[41:50, ]
  mod <- lm(dist ~ speed, data=trainingData)
  summary(mod)
  predicteds <- predict(mod, testData)
  
#   So this is how we build a linear regression model and use it to predict a Y.
#   
# - So, What is happening here? What is the most important thing you need to understand about linear regression?
#   - So what really are we doing when we build a linear regression model? Ans: See below.
#   - Tell that, in linear regression we try to build a mathematical equation where we 
#     express the y variable as a sum of one or more x variables. 
#   - It is done be fitting a line of best fit that minimises the errors or residuals 
#     (explain that residuals is the error measured along the y-axis). 
#   - The problem is: an equation to represent the line of best fit can be created even if 
#     the Y and X variables are not actually related, which means the errors will be pretty 
#     large. So, we have to make sure that the relationship between the X and Y variables 
#     are what is called "statistically significant", by checking the p-values of each 
#     X term and also the model p-Value.
#   - Why is the p-Value important? Whats really happening here? Ans: The output of the model
#     summary actually shows the results of the hypothesis tests, where the null hypothesis 
#     is that the Beta value of X == 0. If the p-value is less than 0.05, then we reject 
#     the null hypothesis and uphold that the respective X is significant.
#   
#   - What is the p Value?
#     p value is the exact probability of committing a Type I error (like we learned in hypotheses testing). 
#     More technically, the p value is defined as the lowest significance level at which a 
#     null hypothesis can be rejected.
#   
#   - What is the R-Squared and adj-R Squared? 
#     Ans: R-Sq represents how much of variance in the Y variable is explained by the model. 
#     Remember that the value in a data is how much variance is contains. 
#     (Imagine a vector of 100 ones, it is also data, but there is no information 
#     to explain Y because it has no variance).
#     
#   - Show the actual values, fitted values and residuals
#   - Compute accuracy on training data. 
#     MAPE <- mean(abs(mod$residuals)/trainingData$dist)  # 0.4046
    
    library(DMwR)
#     trainingData <- cars[1:40, ]
#     testData <- cars[41:50, ]
#     mod <- lm(dist ~ speed, data=trainingData)
      # Calc training accuracy metrics
      regr.eval(trainingData$dist, mod$fitted.values)
#     mae         mse        rmse        mape 
#     10.7421466 201.8669303  14.2079883   0.4046376 
      
      # Calc test accuracy metrics
      regr.eval(testData$dist, predicteds)
#       mae         mse        rmse        mape 
#       14.1575771 419.6246293  20.4847414   0.1598415     

#     Does it stop here? No. There are many considerations that need to be addressed 
#     when you fit a linear regression model. Like:
      - All assumptions of linear regression should be satisfied, 
      - Your data may have missing values and outliers, that needs to be taken care of
      - There could be interactions between X variables and even derived variables that could improve
         the predictive power of your models, 
      - There could be overfitting of models that is evident when your R-sq is too high. 
        (Explain what is overfitting. Ans: When )
      - The model itself should remain statistically significant for subsets of the training data.
      - The predictions should be stable on cross validation of the model
      - The X variables should make business sense n explaining the Y.
    
      
    
#     In the next one we will learn about those 
#     with a linear regression model with multiple X values.
    
# Challenge: Build a simple regression model on mtcars
# Build a simple regression model to predict mpg as a function of drat from mtcars.
# Write the regression model in the form of a mathematical equation. Note: While showing solution, 
#     verify the equation using predict(myMod) and compare with calculator generated values.
# What proportion of variance of mpg was explained by the drat? 
# Is the model statistically significant?
    
#2. 
# Practice Exercise 1: Build a simple regression model on mtcars and predict.
# Split mtcars into training and test data (24 and 8 rows)
# Build a simple regression model to predict mpg as a function of drat from mtcars data.
# Is your model statiscally significant? What is the R-sq (%ge of variance explained)?
# Use the model and explanatory variables in test data to predict the Y (mpg) in test data.
# What are the mae, mse, mape and rmse on the test data predictions. 
# Compare the mae, mse, mape and rmse on fitted values on training data.
    
# --------------------------------------------------------------------------------------------------  
#3.
# Assumptions of linear regression and how to check - part 1
  - Build a multiple linear regression model using the 'mtcars' dataset. Show the summary and lm plot.
  - Tell about the assumptions and how we can check if each of them is satisfied? - gvlma pkg?
  - - 1. Relation between response and predictors is linear and additive.
  - - 2. Residuals should follow a normal distribution. This is also called RESIDUAL ANALYSIS
  - - 3. No heteroscedasticity. Constant variance of residual. This is because, we need to ensure that the errors are completely random. If there was a pattern in the errors, it means some part of the response var can still be explained and a better model that gives higher R-Sq and accuracy could probably be built.
  - - 4. The predictors are independent of each there. Thats is, there is on multicollinearity. Can be verified by checking the VIF, where, VIF of a variable = 1/1-(Rsq), where Rsq is the R-Sq of the linear model built with that X variable as Y and all other remaining predictors as Xs.

#       trainingData <- cars[1:40, ]
#       testData <- cars[41:50, ]
      mod <- lm(dist ~ speed, data=cars)
      errors <- mod$residuals

  - - 1. The regression model is linear in parameters
          Y = a + b1X1 + (b2)*(X2^2)
          Y = a + b1X1 + (b2^2)*X2

  - - 2. The mean of errors is zero and the errors are normally distributed.
          # How to check? Ans:
          mean(mod$residuals)
          par(mfrow=c(2,2,)); plot(mod);
          # The points in top-right evaluates this assumption. If points lie
          # exactly on the line, it follows a normal distribution.

  - - 3. Homoscedasticity of errors or (equal variance)
          How to check: Ans:
            par(mfrow=c(2,2))
            plot(mod)
            From the first plot (topleft), as the fitted values along x increase, the residuals also increase.
            So, there is heterscedasticity.

  - - 4. No autocorrelation of errors.
            To understand what is autocorrelation, you must understand what is a lag and lead. (explain lags)
            Explain what is autocorrelation. Autocorrelation is the condition when
            the numeric vector is correlated with the lags.
            This is applicable in case of time series data.
            
            library(ggplot2)
            data(economics)
            mod1 <- lm(pce ~ pop, data=economics)
            acf(mod1$residuals)  # highly autocorrelated from the picture.
            
            # Method 2
            library(lawstat)
            runs.test(mod1$residuals)  # p-value < 2.2e-16. Reject null hyp that it is random.
            
            # Method 3
            lmtest::dwtest(mod1$residuals)

            
            How to rectify?
            Add lag1 of residual as an X to the original model.
            library(DataCombine)
            econ_data <- data.frame(economics, resid_mod1=mod1$residuals)
            econ_data_1 <- slide(econ_data, Var="resid_mod1", NewVar = "lag1", slideBy = -1)
            # econ_data_2 <- slide(econ_data_1, Var="resid_mod1", NewVar = "lag2", slideBy = -2)
            econ_data_2 <- na.omit(econ_data_1)
            mod2 <- lm(pce ~ pop + lag1, data=econ_data_2)
            acf(mod2$residuals)
            
            # Method 2:
            runs.test(mod2$residuals)  # p-value = 0.3362. Can't reject null hyp that it is random.
            
            # Method 3: 
            lmtest::dwtest(mod2$residuals)
            
# Challenge: Check if Assumption 3: Homoskedasticity of errors is satisfied.
mod.lm <- lm(mpg ~ drat, data=mtcars)
par(mfrow=c(2,2))
plot(mod.lm)

# Ans: In top-left plot, the line is fairly flat, though there are points on the extremes.
# To verify it numerically if the errors are random, we can do a runs test after arranging the residuals in the order of increasing fitted values.

lawstat::runs.test(mod.lm$residuals[order(mod.lm$fitted.values)], plot.it = T)  
# INFERENCE: p-value = 1 therefore, the null hypothesis that it is random cannot be rejected.




# --------------------------------------------------------------------------------------------------          
#4.
# Assumptions of linear regression and how to check - part 2            
  - - 5. The X variables and Errors are uncorrelated.
          
            How to check? Ans:
            mod.lm <- lm(mpg ~ drat, data=mtcars)
            cor.test(mtcars$drat, mod.lm$residuals)  # corr= -1.066192e-16, p-value is high, so null hyp that true correlation in 0 cant be rejected.. 
          
            
  - - 6. The number of observations 'n' must be greater than number of Xs
            
  - - 7. The variablility in X values is positive. The X values in a given sample must not all be the same.
            
            How to check? Ans:
            var(trainingData$speed)
            
  - - 8. The regression model is correctly specified.
            # Refer gujarati. Show that pic and explain.
  
  - - 9. No perfect multicollinearity. There is no perfect linear relationship between explanatory variables.
          
            How to check? Ans: Using VIF (Variance Inflation factor)
            What is VIF? VIF is a metric computed for every X variable that goes into a linear model.
            VIF for a X var is calculated as: 1/(1-Rsq), where,
            Rsq is the R-sq term for the model that X against all other Xs that went into the model.
            Practically, if two of the Xs habe high correlation, they will likely have high VIFs.
            
            library(car)
            mod2 <- lm(mpg ~ ., data=mtcars)
            vif(mod2)
#             cyl      disp        hp      drat        wt      qsec        vs        am      gear      carb 
#             15.373833 21.620241  9.832037  3.374620 15.164887  7.527958  4.965873  4.648487  5.357452  7.908747 
            
            How to rectify?
            2 ways: 
              1. Either iteratively remove the var with the highest VIF or,
              2. See correlation between all variables and keep only one of all highly correlated pairs.
            library(corrplot)
            corrplot(cor(mtcars[, -1]))
            # Correlated pairs: 
            # - disp, cyl, hp, wt
            # - gear, am
            # - hp, carb
            
            mod2 <- lm(mpg ~ cyl + gear, data=mtcars)
            vif(mod2)
          
            # The convention is, the VIF should not go more than 4 for any of the X variables. 
            # That means we are not letting the R-Sq of any of the Xs to go more than 
            # 75%. => 1/(1-0.75)
            
            NOTE: What about normailty of Xs and errors?
            
# Challenge: Check if X variable and Errors are uncorrelated.
  mod.lm <- lm(dist ~ speed, data=cars)
  cor.test(cars$speed, mod.lm$residuals)  # corr: 2.669186e-17, p-value is high, so null hyp that true correlation in 0 cant be rejected.. 

  
# --------------------------------------------------------------------------------------------------  
#5.
# Regression modeling part 1: Univariate and Bivariate analysis
Now that we know the assumptions of linear regression, lets take the 'Ozone' df from {mlbench}
and walk through the procedure of building regression models.

# Data prep: Run this directly, giving a 1 line explanation.

# data (Ozone, package="mlbench")  # initialize the data
# inputData <- Ozone  # data from mlbench
# names(inputData) <- c("Month", "Day_of_month", "Day_of_week", "ozone_reading", "pressure_height", "Wind_speed", "Humidity", "Temperature_Sandburg", "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient", "Inversion_temperature", "Visibility")  # assign names

This dataset is derived from "mlbench::Ozone"
url:"http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv"
inputData <- read.csv("http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv")

# Segregate all continuous and categorical variables
# Place all continuous vars in inputData_cont
inputData_cont <- inputData[, c("pressure_height", "Wind_speed", "Humidity", "Temperature_Sandburg", "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient", "Inversion_temperature", "Visibility")]

# Place all categorical variables in inputData_cat
inputData_cat <- inputData[, c("Month", "Day_of_month", "Day_of_week")]

# create the response data frame
inputData_response <- data.frame(ozone_reading=inputData[, "ozone_reading"])
response_name <- "ozone_reading"  # name of response variable
response <- inputData[, response_name]  # response variable as a vector

# Summary Statistics
inputData_cont
sapply(inputData_cont, summary)

## Graphical analysis: Create box, scatter and density plot
setwd("/Users/selvaprabhakaran/Documents/work/rwork/TCRPC")
library(e1071)
for (k in names(inputData_cont)){
  png(file=paste(k,"_dens_scatter_box" ,".png", sep=""), width=900, height=550)
  x <- as.numeric (inputData_cont[, k])
  Skewness <- round(skewness(x), 2)  # calc skewness
  dens <- density(x, na.rm=T)  # density func
  par(mfrow=c(1, 3))  # setup plot-area in 3 columns
  
  # Density plot
  plot(dens, type="l", col="red", ylab="Frequency", xlab = k, main = paste(k, ": Density Plot"), sub=paste("Skewness: ", Skewness))
  polygon(dens, col="red")
  
  # scatterplot
  plot(x, response, col="blue", ylab="Response", xlab = k, main = paste(k, ": Scatterplot"), pch=20)
  abline(response ~ x)
  
  # boxplot
  boxplot(x, main=paste(k, ": Box Plot"), sub=paste("Outliers: ", paste(boxplot.stats(x)$out, collapse=" ")))
  dev.off()
}

# Correlation Analysis
data <- cbind(oz=inputData$ozone_reading, inputData_cont)
myCorrelation <- cor(data, use="pairwise.complete.obs")  # NA's wont be included.
corrplot(myCorrelation)

# All in one chart
PerformanceAnalytics::chart.Correlation(inputData)

# Which variables are highly correlated with oz?
# Positive
# - pressure_height
# - Temperature_Sandburg
# - Temperature_ElMonte
# - Inversion_temperature

# Negative
# - Inversion_base_height
# - Visibility

### Bivariate Box plot ----------------
#   - - visualise in box-plot of the X and Y, for categorical X's
options(scipen=999)
# For categorical variable
boxplot(ozone_reading ~ Month, data=inputData)  # clear pattern is noticeable.
boxplot(ozone_reading ~ Day_of_week, data=inputData)  # this may not be significant, as day of week variable is a subset of the month var.

# For continuous variable (convert to categorical if needed.)
boxplot(ozone_reading ~ pressure_height, data=inputData)
boxplot(ozone_reading ~ cut(pressure_height, pretty(inputData$pressure_height)), data=inputData)



# Advanced EDA ------------------------
# Interaction Plot
interaction.plot(inputData$Temperature_Sandburg, inputData$Month, inputData$ozone_reading)


### Create Interaction plots for all combinations of continuous and categorical variables.
# If a categorical var is important, the points of same in the plot will cluster in one region.. else it will be scattered allover the plot.
# If a continuous var is important, the mean of Y, will either increase or decrease, as X increases.
# IMPORTANT NOTE: After plots are created, browse through each of them and make inferences from the interactions.
library(ggplot2)
# y_var <- "ozone_reading"
# x_var <- "Temperature_Sandburg"
# group_var <- "Month"
x_vars <- names(inputData_cont)
group_vars <- names(inputData_cat)
for(group_var in group_vars){
  for(x_var in x_vars){
    # Convert the continuous X into buckets.
    binned <- cut(inputData[[x_var]], pretty(inputData[[x_var]]))
    aggData <- aggregate(inputData[[y_var]], by=list(binned, inputData[[group_var]]), FUN=mean)
    
    # Keep the continuous X as continuous.
    # aggData <- aggregate(inputData[[y_var]], by=list(inputData[[x_var]], inputData[[group_var]]), FUN=mean)
    assign_labels <- labs(x=x_var, y=paste("Mean of", y_var), title="Interaction Plot")
    
#     png(paste(group_var, x_var, "bar.png",sep="_"))
#      ggplot(aggData, aes(x=Group.1, y=x)) + geom_bar(aes(fill=Group.2), stat="identity") + assign_labels + scale_fill_discrete(name=element_text(group_var))
#     dev.off()
     
    png(paste(file.path("interaction plots", paste(group_var, x_var, "point.png",sep="_"))))
     print(ggplot(aggData, aes(x=Group.1, y=x)) + geom_point(aes(color=Group.2)) + assign_labels + scale_color_discrete(name=element_text(group_var)))
    dev.off()
  }
}

### ----------------------------------------------------------------------------------------------

#6. Practice Exercise 2: Univariate and Bi-Variate analysis
# Do a univariate and bi-variate analysis on the mtcars dataset with Y as 'mpg'.
# Part 1: Try to come up with the steps for univariate and bi-variate analysis yourself and write down your action plan
# Compare your action plan with mine, that I show in part 2. If you have any ideas I have not written, let us know in the comment section for everyone's benefit.

# Part 2: 
# Univariate Analysis:
# - Create density plot with skewness to understand how close the Xs are to normality.
# - Get the univariate statistics - mean, median, sd, co-eff of variation, range, quartiles, IQR
# - Get the individual boxplots and make inferences. 
# - Make frequency tables for categorical variables.

# Bi-Variate Analysis
# For Continuous variables
# - Get the correlation values for Y vs all Xs and note which are the highy correlated variables.
# - Get the correlation values between all X's
# - Draw a scatterplot for all Xs vs Y and draw a line of best fit

# For Categorical variables
# - Draw box plot for Y against each level of X.

# Use the PerformanceAnalytics package to create chart.correlation() - make inferences.
# Try making interaction plot, whereever you suspect there could be a strong relationship.



# 7.
# Regression modeling part 2: Dealing with Outliers: Identification - Part 1
What is outlier treatment? And: Once outliers are identified, the values of the outliers are
modified to reduce their impact on the model

Why is outlier treatment important? Ans: Because, it can drastically bias/change the fit estimates and predictions.
# Effect of Outliers: Cars Example
cars1 <- cars[1:30, ]
cars_outliers <- data.frame(speed=c(19,19,20,20,20), dist=c(190, 186, 210, 220, 218))  # introduce outliers.
cars2 <- rbind(cars1, cars_outliers)  # data with outliers.

par(mfrow=c(1, 2))
plot(cars2$speed, cars2$dist, xlim=c(0, 28), ylim=c(0, 230), main="With Outliers", xlab="speed", ylab="dist", pch="*", col="red")
abline(lm(dist ~ speed, data=cars2), col="blue", lwd=3, lty=2)

plot(cars1$speed, cars1$dist, xlim=c(0, 28), ylim=c(0, 230), main="Outliers removed \n Gives better fit!", xlab="speed", ylab="dist", pch="*", col="red")
abline(lm(dist ~ speed, data=cars1), col="blue", lwd=3, lty=2)


## Identification Approaches
# - Univariate approach
#  - - Those that lie beyond 1.5%IQR
boxplot(inputData$pressure_height, main="Pressure Height")
boxplot.stats(inputData$pressure_height)  # outlier stats
boxplot.stats(inputData$pressure_height)$out  # outlier values.


### - Bivariate approach
#     - - visualise in box-plot of the X and Y, for categorical X's
options(scipen=999)
# For categorical variable
boxplot(ozone_reading ~ Month, data=inputData)  # clear pattern is noticeable.
boxplot(ozone_reading ~ Day_of_week, data=inputData)  # this may not be significant, as day of week variable is a subset of the month var.

# For continuous variable (convert to categorical if needed.)
boxplot(ozone_reading ~ pressure_height, data=inputData)
boxplot(ozone_reading ~ cut(pressure_height, pretty(inputData$pressure_height)), data=inputData)


# Challenges:
Identify outliers in the "Visibility" variable using a box plot and get the values of the outliers.
Consider using boxplot.stats() to get the values of outliers.

# 8.
# Regression modeling part 2: Dealing with Outliers: Cooks distance - Part 2
### - Multivariate - Model based approach
#     Explain what is cooks distance and how it is calculated.
#     - - Build the model and those that have cook's distance > 4/n are considered outliers.
#      influence.measures()
mod <- lm(ozone_reading ~ ., data=inputData)
info <- influence.measures(mod)
infoMat <- info[[1]]
cooksd <- infoMat[, "cook.d"]
influential_obs <- which(cooksd > 4/length(cooksd))  # influential observations row nums

infoMat[influential_obs, ]
inputData[influential_obs, ]

plot(mod$fitted.values, na.omit(inputData)[, "ozone_reading"], main="Actuals vs Fitted for 'ozone_reading'", xlab="fitted", ylab="Actuals")
points(mod$fitted.values[influential_obs], na.omit(inputData)[influential_obs, "ozone_reading"], col="red", pch=16)

# Challenge:
Find the value of cooks distance and identify the most influential observations in 
myMod <- lm(dist ~ speed, data=cars)

Ans: influence.measures(mod)


# 9.
# Regression modeling part 2: Dealing with Outliers - Treatment - Part 3
## Treatment Approaches
# Imputation
# - Replace the outliers with mean, median, mode etc.
x <- inputData$pressure_height
outliers <- boxplot.stats(x)$out
x[x %in% outliers] <- mean(x, na.rm = T)


# - Capping: Replace the outliers above 95%ile to the 95th %ile value, likewise for those below 5%ile.
x <- inputData$pressure_height
qnt <- quantile(x, probs=c(.25, .75), na.rm = T)
caps <- quantile(x, probs=c(.05, .95), na.rm = T)
H <- 1.5 * IQR(x, na.rm = T)
x[x < (qnt[1] - H)] <- caps[1]
x[x > (qnt[2] + H)] <- caps[2]

# Imitate the nearest neighbours
# - Find observations (rows) that are most similar to the outlier value and replace with the nearest neighbour. 
# - This is same as that done for missing value treatment.
# Replace outliers with NAs and then apply knnImputation
replace_outlier_with_missing <- function(x, na.rm = TRUE, ...) {
  qnt <- quantile(x, probs=c(.25, .75), na.rm = na.rm, ...)  # get %iles
  H <- 1.5 * IQR(x, na.rm = na.rm)  # outlier limit threshold
  y <- x
  y[x < (qnt[1] - H)] <- NA  # replace values below lower bounds
  y[x > (qnt[2] + H)] <- NA  # replace values above higher bound
  return(y)  # returns treated variable
}

inputData_cont <- as.data.frame (sapply(inputData_cont, replace_outlier_with_missing))  # this will make outliers as NA

# Delete the observations
# - Ideally done if known to be a data entry errors.

# Challenge: Do 1%ile and 99%ile capping on inputData$visibility
x <- inputData$Visibility
qnt <- quantile(x, probs=c(.25, .75), na.rm = T)
caps <- quantile(x, probs=c(.01, .99), na.rm = T)
H <- 1.5 * IQR(x, na.rm = T)
x[x < (qnt[1] - H)] <- caps[1]
x[x > (qnt[2] + H)] <- caps[2]




# ------------------------------------------------------------------------
# 10.
# Regression modeling part 3: Missing Value treatment approaches
# Approaches:
- replace with mean or median
- replace with mid range: (min + max)/2
- Predict the missing values, by considering that X as a Y response variable, and other Xs as predictors.
- Identify the nearest neighbur and substitute.

# Apply kNN
The concept behind kNN is it will indentify the most similar points near that observation and use that information to make the prediction.
It will be dealt in greater detail in a later section.

inputData_cont_noOutliers <- knnImputation(inputData_cont)  # replace all mising values with nearest neighbours.


# Challenge:
Replace all missings in continuous variable with the mean 
myData <- inputData_cont
replaceWithMean <- function(x){x[is.na(x)] <- mean(x, na.rm=T); return(x);}
missings_replaced <- sapply(inputData_cont, FUN=replaceWithMean)



# ------------------------------------------------------------------
# 11.
# Regression modeling part 4: Significant variables
cont_vars <- names(inputData_cont)
signif_cont <- character()
for(cont_var in cont_vars){
  myfrmla <- as.formula(paste("ozone_reading ~ ", cont_var))
  mod <- summary(lm(myfrmla, data=inputData))
  pvalue <- mod[[4]][, 4][2]
  if(pvalue < 0.05){
    signif_cont <- c(signif_cont, cont_var)
  }
}
# Inference: Except "Wind_speed", all others are significant.

cat_vars <- names(inputData_cat)
signif_cat <- character()
for(cat_var in cat_vars){
  myfrmla <- as.formula(paste("ozone_reading ~ ", cat_var))
  mod <- summary(aov(myfrmla, data=inputData))
  pvalue <- unlist(mod)[9]
  if(pvalue < 0.05){
    signif_cat <- c(signif_cat, cat_var)
  }
}

# Inference: Only 'Month' is significant.

signif_all <- c(signif_cont, signif_cat)  # Collect all significant variables.
# [1] "pressure_height"       "Humidity"              "Temperature_Sandburg" 
# [4] "Temperature_ElMonte"   "Inversion_base_height" "Pressure_gradient"    
# [7] "Inversion_temperature" "Visibility"            "Month"

# signif_all <- c("pressure_height", "Humidity", "Temperature_Sandburg",  
# "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient"    
# "Inversion_temperature", "Visibility", "Month")

# Challenge: Do the same exercise as done above, but only on the first 70% of the data.


# ---------------------------------------------------------------------------------------------
# 12. Practice Exercise 3: Get all the significant X variables in mtcars, where Y is mtcars$mpg




# ---------------------------------------------------------------------------------------------
# 13.
# Regression modeling part 5: Fitting the linear regression model and adding interactions terms
# Now we have 9 significant variables: 8 continuous and 1 categorical.

# - Create multiple lm models - raw variables, interactions, subset models (for anova). etc
inputData <- inputData[, names(inputData) %in% c("ozone_reading", signif_all)]

# How to make a regression model with multiple variables?
baseMod <- lm(ozone_reading ~ Inversion_base_height + Temperature_Sandburg + Month, data=inputData)
vif(baseMod)
summary(baseMod)

# How to make a regression model without intercept ?
# - what is meant by no-intercept model? Ans: A no-intercept 
#   model will make the line of best fit pass through the origin.
baseMod <- lm(ozone_reading ~ 0 + Inversion_base_height + Temperature_Sandburg + Month, data=inputData)
summary(baseMod)

# How to include powers of a variable in a regression model?
baseMod <- lm(ozone_reading ~ 0 + I(Inversion_base_height^2) + Temperature_Sandburg + Month, data=inputData)
summary(baseMod)

# How to add interaction terms in a model?
# - How to add product of two variables
baseMod <- lm(ozone_reading ~ 0 + Inversion_base_height:Temperature_Sandburg + Inversion_base_height + Temperature_Sandburg + Month, data=inputData)
summary(baseMod)

baseMod <- lm(ozone_reading ~ 0 + Inversion_base_height:Temperature_Sandburg:Month + Inversion_base_height + Temperature_Sandburg + Month, data=inputData)
summary(baseMod)

# - What does adding a real product of three variables is interpreted by lm?
baseMod <- lm(ozone_reading ~ 0 + Inversion_base_height*Temperature_Sandburg*Month + Inversion_base_height + Temperature_Sandburg + Month, data=inputData)
summary(baseMod)


# Challenge: 
# 1. Make a model that contains the squared terms for all 3 variables: Inversion_base_height, Temperature_Sandburg, Month
mod <- lm(ozone_reading ~ I(Inversion_base_height^2) + I(Temperature_Sandburg^2) + I(Month^2),data=inputData)
summary(mod)


# ---------------------------------------------------------------------------------------------
#14. 
# Regression modeling part 6: How to manually build a good regression model
# Now we have 9 significant variables: 8 continuous and 1 categorical.
inputData <- read.csv("http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv")
signif_all <- c("pressure_height", "Humidity", "Temperature_Sandburg",  
                "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient"    
                "Inversion_temperature", "Visibility", "Month")
inputData <- inputData[, names(inputData) %in% c("ozone_reading", signif_all)]

corrplot(cor(inputData[, -1], use="pairwise.complete.obs"))  # see the correlation plot and select

# Build Base model
baseMod <- lm(ozone_reading ~ pressure_height + Temperature_Sandburg + Temperature_ElMonte + Inversion_base_height + Inversion_temperature + Visibility + Humidity + Month, data=inputData)
vif(baseMod)

# Remove Inversion_temperature
baseMod <- lm(ozone_reading ~ pressure_height + Temperature_Sandburg + Temperature_ElMonte + Inversion_base_height +  Visibility + Humidity + Month, data=inputData)
vif(baseMod)  # Inversion_temperature has vif > 15

# Remove Temperature_ElMonte
baseMod <- lm(ozone_reading ~ pressure_height + Temperature_Sandburg + Inversion_base_height + Visibility + Humidity + Month, data=inputData)
vif(baseMod)  # all VIF < 4
summary(baseMod)  # pressure height is not significant

# Important Note: Even though pressure_height was significant in the 1-variable model, it 
# loses its significance in the presence of other variables. In order for a lin reg model 
# to be statistically significant, all the 

# Remove pressure_height
baseMod <- lm(ozone_reading ~ Temperature_Sandburg + Inversion_base_height + Visibility + Humidity + Month, data=inputData)
vif(baseMod)  # all VIF < 4
summary(baseMod)  # all variables are significant.

# IMPORTANT: Next Check
# Check the correlation (from corrplot) with the sign of the beta estimates.
# All signs seem to be ok.


# Challenge:
# 1. Build two statistically significant regression model with 3 explanatory vars. Compare VIFs and R-sq
baseMod <- lm(ozone_reading ~ Temperature_Sandburg + Inversion_base_height + Visibility, data=inputData)
summary(baseMod)
car::vif(baseMod)

baseMod <- lm(ozone_reading ~ Temperature_Sandburg + Inversion_base_height + Humidity, data=inputData)
summary(baseMod)
car::vif(baseMod)



# ---------------------------------------------------------------------------------------------
#15.
# Regression modeling part 5: Accuracy measures, anova
inputData <- read.csv("http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv")
signif_all <- c("pressure_height", "Humidity", "Temperature_Sandburg",  
                "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient"    
                "Inversion_temperature", "Visibility", "Month")
inputData <- inputData[, names(inputData) %in% c("ozone_reading", signif_all)]

# Build some subsets
baseMod <- lm(ozone_reading ~ Temperature_Sandburg + Inversion_base_height + Visibility + Humidity + Month, data=na.omit(inputData))
subMod1 <- lm(ozone_reading ~ Temperature_Sandburg + Inversion_base_height + Visibility + Humidity, data=na.omit(inputData))
subMod2 <- lm(ozone_reading ~ Temperature_Sandburg + Inversion_base_height + Visibility, data=na.omit(inputData))
subMod3 <- lm(ozone_reading ~ Temperature_Sandburg + Inversion_base_height, data=na.omit(inputData))

# The anova() function performs a hypothesis test comparing the two models. 
# The null hypothesis is that the two models fit the data equally well, and the 
# alternative hypothesis is that the full model is superior.

anova(subMod3, subMod2, subMod1, baseMod)  # The base model is not redundant.
# Inference: BaseMod1 does not fit the data any better compared to baseMod.

# Accuracy Measures
# The most common accuracy measures are: MAPE, MAE, MSE, RMSE
DMwR::regr.eval(na.omit(inputData)$ozone_reading, baseMod$fitted.values)

# Measure goodness of fit using AIC. The lower the AIC, the better the model.
AIC(baseMod)

# Challenge:
# Does adding pressure_height to the baseMod provide more explanatory power?
baseMod1 <- lm(ozone_reading ~ Temperature_Sandburg + pressure_height + Inversion_base_height + Visibility + Humidity + Month, data=na.omit(inputData))
anova(subMod3, subMod2, subMod1, baseMod, baseMod1)  # The baseMod1 is redundant, since pValue > 0.05
# Ans: NO


# ---------------------------------------------------------------------------------------------
#16.
# Regression modeling part 6: Residual analysis
inputData <- read.csv("http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv")
signif_all <- c("pressure_height", "Humidity", "Temperature_Sandburg",  
                "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient"    
                "Inversion_temperature", "Visibility", "Month")
inputData <- inputData[, names(inputData) %in% c("ozone_reading", signif_all)]
baseMod <- lm(ozone_reading ~ Temperature_Sandburg + Inversion_base_height + Visibility + Humidity + Month, data=na.omit(inputData))

# Explain top-left plot. The errors should be random. If some pattern is present 
#     check bottom left plot.
# Bottom left plot: Standardised residuals is Residual/standard deviation. 
#   - This plot gets rid of the sign unlike top-left plot. If some pattern is 
#     present, ie, the red line has sharp trend/pattern, it indicates 
#     heteroscedasticity.
# Top-right: How close is the residuals to a normal distribution. If it is a perfect 
#    normal disbn, all points must lie along the line.
# Bottom right: Leverage is a measure of how much each data point influences 
#     the regression. Because the regression must pass through the centroid, 
#     points that lie far from the centroid have greater leverage, and their 
#     leverage increases if there are fewer points nearby. As a result, leverage 
#     reflects both the distance from the centroid and the isolation of a point.
#     The plot also contours values of Cook’s distance, which measures how much 
#     the regression would change if a point was deleted. Cook’s distance is 
#     increased by leverage and by large residuals: a point far from the centroid 
#     with a large residual can severely distort the regression. On this plot, 
#     you want to see that the red smoothed line stays close to the horizontal 
#     gray dashed line and that no points have a large Cook’s distance (i.e, >0.5).
#     IN OUR CASE, it lies fairly in the center along with dashed gray line, so, 
#     no point exerts too much influence on our model.

par(mar=c(5,4,4,1))
par(mfrow=c(2,2))
plot(baseMod)

# Challenge:
# Do a residual analysis on 
mod <-lm(dist ~ speed, data=cars)
par(mfrow=c(2,2))
plot(mod)



# ---------------------------------------------------------------------------------------------
#17.
# Regression modeling part 7: Model validation - Training and Testing
inputData <- read.csv("http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv")
signif_all <- c("pressure_height", "Humidity", "Temperature_Sandburg",  
                "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient"    
                "Inversion_temperature", "Visibility", "Month")
inputData <- inputData[, names(inputData) %in% c("ozone_reading", signif_all)]

# Create the training and test data.
trainingRowIndex <- 1:(nrow(inputData)*0.8)
trainingData <- na.omit(inputData[trainingRowIndex, ])
testingData <- na.omit(inputData[-trainingRowIndex, ])

# Build the model
baseMod <- lm(ozone_reading ~ Temperature_Sandburg + Inversion_base_height + Visibility + Humidity + Month, data=trainingData)

# Predict
# - the beta estimates from baseMod is applied on test data. It is important to understand that
#   eventhough testData df may contain the actual Y values, only the X's needed by the model object 
#   is used by predict func.
predicteds <- predict(baseMod, testingData)

# Calculate test accuracy. Earlier, we had calculated the accuracy measures on 
# the training data. Here we will test the predicting capability of the model on 
# unknown test data.
DMwR::regr.eval(testingData$ozone_reading, predicteds)
#       mae        mse       rmse       mape 
# 3.5085254 19.4452188  4.4096733  0.9136689


# Challenge:
# Do the same on cars dataset.
lm(dist ~ speed, data=cars)

# --------------------------------------------------------------------------
#18.
# Regression modeling part 8: k-Fold Cross validation - Checking Model stability
inputData <- read.csv("http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv")
signif_all <- c("pressure_height", "Humidity", "Temperature_Sandburg",  
                "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient"    
                "Inversion_temperature", "Visibility", "Month")
inputData <- na.omit(inputData[, names(inputData) %in% c("ozone_reading", signif_all)])

# Build the model on full data
baseMod <- lm(ozone_reading ~ Temperature_Sandburg + Inversion_base_height + Visibility + Humidity + Month, data=inputData)

# Explain how to interpret CV plots.
library(DAAG)
par(mfrow=c(1,1))
cv.lm(df=inputData, form.lm=baseMod, m=5, dots = F, seed=29, legend.pos="topleft",  printit=FALSE)

# Not working!
library(boot)
cv.glm(inputData, baseMod)$delta


# Challenge:
# Do the same crossvalidation on cars dataset

# --------------------------------------------------------------------------


#19.
# Regression modeling part 9: Relative importance of predictors and stepwise regression
library(relaimpo)
calc.relimp(baseMod, rela = T)

#                              lmg
# Temperature_Sandburg  0.54954550
# Inversion_base_height 0.18323460
# Visibility            0.11309341
# Humidity              0.14293453
# Month                 0.01119196

# Stepwise regression: 
# What is stepwise regression? Why is it used? Ans: Regression performed on subsets of predictors in a sequence. To find out smaller and simpler models and also to collect good predictors.
# What is forward and backward stepwise regression? 
# What is the disadvantage of forward and backward stepwise regression? Ans: Interaction effects not captured. Not exhaustive.
inputData <- read.csv("http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv")
signif_all <- c("pressure_height", "Humidity", "Temperature_Sandburg",  
                "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient"    
                "Inversion_temperature", "Visibility", "Month")
inputData <- na.omit(inputData[, names(inputData) %in% c("ozone_reading", signif_all)])

base.mod <- lm(ozone_reading ~ 1 , data= inputData)  # base intercept only model
all.mod <- lm(ozone_reading ~ . , data= inputData) # full model with all predictors
stepMod <- step(base.mod, scope = list(lower = base.mod, upper = all.mod), direction = "both", trace = 1, steps = 1000)  # perform step-wise algorithm
shortlistedVars <- names(unlist(stepMod[[1]])) # get the shortlisted variable.
shortlistedVars <- shortlistedVars[!shortlistedVars %in% "(Intercept)"]  # remove intercept 

# Challenge:
Do a stepwise on mtcars, accumulate the significant vars and find relative importance on the final model.


# ---------------------------------------------------------------------------

#20.
# Regression modeling part 11: Finding best models - Best subsets, leaps, finding all possible models (after filtering vifs)
#Prep
inputData <- read.csv("http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv")
signif_all <- c("pressure_height", "Humidity", "Temperature_Sandburg",  
                "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient",    
                "Inversion_temperature", "Visibility", "Month")
inputData <- na.omit(inputData[, names(inputData) %in% c("ozone_reading", signif_all)])
trainingRowIndex <- 1:(nrow(inputData)*0.8)
trainingData <- na.omit(inputData[trainingRowIndex, ])
testingData <- na.omit(inputData[-trainingRowIndex, ])


# Best Subsets
library(leaps)
regsubsetsObj <- regsubsets(x=inputData[, !names(inputData) %in% "ozone_reading"] ,y=inputData[, "ozone_reading"], nbest = 2, really.big = T)
plot(regsubsetsObj, scale = "adjr2")

# Leaps
library(leaps)
leapSet <- leaps(x= inputData[, !names(inputData) %in% "ozone_reading"], y=inputData[, "ozone_reading"], nbest = 5 ,method = "adjr2") # criterion could be one of "Cp", "adjr2", "r2". Works for max of 32 predictors.

# Vif filtering
full_form <- as.formula(paste("ozone_reading ~ ", paste(signif_all, collapse="+")))
myMod <- lm(full_form, data=inputData)
all_vifs <- vif(myMod)

while(any(all_vifs > 4)){
 var_with_max_vif <- names(which(all_vifs == max(all_vifs)))  # get the var with max vif
 signif_all <- signif_all[!(signif_all) %in% var_with_max_vif]  # remove
 myForm <- as.formula(paste("ozone_reading ~ ", paste (signif_all, collapse=" + "), sep=""))  # new formula
 myMod <- lm(myForm, data=inputData)  # re-build model with new formula
 all_vifs <- vif(myMod)
}

# The best model will be stored in myMod. If Any of the X'x is insignificant, reove it and build the model agn.
summary(myMod)

# Challenge:
# Do the same on mtcars dataset.



#21.
# Practice Exercise - 4
# Build an algo that would iteratively remove the Xs that is not significant one by one.

# Start with this base code that creates 'myMod'
inputData <- read.csv("http://rstatistics.net/wp-content/uploads/2015/09/ozone.csv")
signif_all <- c("pressure_height", "Humidity", "Temperature_Sandburg",  
                "Temperature_ElMonte", "Inversion_base_height", "Pressure_gradient",    
                "Inversion_temperature", "Visibility", "Month")
inputData <- na.omit(inputData[, names(inputData) %in% c("ozone_reading", signif_all)])
trainingRowIndex <- 1:(nrow(inputData)*0.8)
trainingData <- na.omit(inputData[trainingRowIndex, ])
testingData <- na.omit(inputData[-trainingRowIndex, ])

# Vif filtering
full_form <- as.formula(paste("ozone_reading ~ ", paste(signif_all, collapse="+")))
myMod <- lm(full_form, data=inputData)
all_vifs <- vif(myMod)

while(any(all_vifs > 4)){
  var_with_max_vif <- names(which(all_vifs == max(all_vifs)))  # get the var with max vif
  signif_all <- signif_all[!(signif_all) %in% var_with_max_vif]  # remove
  myForm <- as.formula(paste("ozone_reading ~ ", paste (signif_all, collapse=" + "), sep=""))  # new formula
  myMod <- lm(myForm, data=inputData)  # re-build model with new formula
  all_vifs <- vif(myMod)
}

# Challenge starts here: 
# Build an algo that would iteratively remove the Xs that is not significant one by one.
all_vars <- names(myMod[[1]])[-1]
summ <- summary(myMod)
pvals <- summ[[4]][, 4]
not_significant <- character()
not_significant <- names(which(pvals > 0.1))
not_significant <- not_significant[!not_significant %in% "(Intercept)"]

while(length(not_significant) > 0){
  all_vars <- all_vars[!all_vars %in% not_significant]
  myForm <- as.formula(paste("ozone_reading ~ ", paste (all_vars, collapse=" + "), sep=""))  # new formula
  myMod <- lm(myForm, data=inputData)  # re-build model with new formula
  
  # Get the non-significant var.
  summ <- summary(myMod)
  pvals <- summ[[4]][, 4]
  not_significant <- character()
  not_significant <- names(which(pvals > 0.1))
  not_significant <- not_significant[!not_significant %in% "(Intercept)"]
}


# 22.
Project Case Study: Linear regression 
ISLR::Carseats  # predict unit sales
ISLR::Hitters  # predict salary of baseball hitters
ISLR::College  # predict number of applications received.
ISLR::Wage  # predict wage of workers.

################################################################################
# 23.
Logistic regression: When to use and how to build model?
# When to use logistic regression and in what kind of problems can it be used ?
# Why can we use linear regression to predict? And: In logistic we want to constrain the Y variable 
#  between 0 and 1. So, we model the log(odds of the outcome) instead.

# Show a full example: Build a logit model, estimate the prediction probability scores, 
#  make the predictions using a default cutoff, calc misclassification error and confusion matrix.
#  compute the vif. 

# What are the other considerations?  
# - What if there is a class bias, like in credit card default, predicting if an ad will be clickwed or not?
# - What if our problem had a different objective, like it spam detection, its ok if a spam gets into the inbox 
#    but a legit message should never be classified as spam.
# - What is the ROC curve, how to interpret it and what purpose does it serve?
# - What a are the other performance diagnostic metrics available ? Cohen Kappa, Youden's index, Specificity, Sensitivity, FPR, Prevalence etc.


Model diagnostics, confusion matrix, misclassification error
Weight of Evidence and Information Value
Concordance, discordance, Somers D, Kappa
Sensitivity, Specificity, Recall and Precision
ROC curve
Project Case Study: Logistic Regression (mlbench, OJ)

# Project Case Study: Logistic Regression 
ISLR::College  # Wheter Private or Govt
ISLR::OJ  # Which brand of OJ was purchased.
ISLR::Default  # Whether defaulted or not?

