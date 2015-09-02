# Section 4 Notes
# Linear and Logistic Regression

#1 
The Purpose - When and how to use linear regression?

Notes

Questions:
- When and what kind of problems can be solved using linear regression?
  Ans: The Y has to be a continuous numeric variable and is linearly dependent upon 1 or more X     values.
- What is the most important thing you need to understand about linear regression?
  - Show a very simple example using 'cars' dataset and show model summary. 
  - IMPORTANT: State that, I am directly building a linear regression model here because 'cars' is     a standard and popular dataset used for this purpose. In this video we will learn when to use     linear regression, how to build a linear model and how to interpret the results. I am showing     this to you first because, you will have a better understanding of the concepts and why we do     what we are doing. The full structured process of building a linear regression model will         start from video 3 of this section, but I highly recommend you go in the sequence I have made     this so things will fall in place perfectly.
  - So what really are we doing when we build a linear regression model? Ans: See below.
  - Show a very simple example using 'cars' dataset and show model summary. 
  - Tell that, in linear regression we try to build a mathematical equation where we express the y     variable as a sum of one or more x variables. 
  - It is done be fitting a line of best fit that minimises the errors or residuals (explain that     residuals is the error measured along the y-axis). 
  - The problem is: an equation to represent the line of best fit can be created even if the Y and     X variables are not actually related, which means the errors will be pretty large. So, we have     to make sure that the relationship between the X and Y variables are significant, by checking     the p-values of each X term and also the model p-Value.
  - Why is the p-Value important? Whats really happening here? Ans: The output of the model           summary actually shows the results of the hypothesis tests, where the null hypothesis is that     the Beta value of X's == 0. If the p-value is less than 0.05, then we reject the null             hypothesis and uphold that the respective X is significant.
  - What is the R-Squared and adj-R Squared. Ans: R-Sq represents how much of variance in the Y       variable is explained by the model. Remember that the value in a data is how much variance is     contains.
  - Does it stop here? No. There are few more considerations that need to be addressed after you      fit a linear regression model. In the next one we will learn about those with a linear            regression model with multiple X values.
  
#2.
Assumptions of linear regression and other considerations.
  - Build a multiple linear regression model using the 'mtcars' dataset. Show the summary and lm plot.
  - Tell about the assumptions and how we can check if each of them is satisfied? - gvlma pkg?
  - - 1. Relation between response and predictors is linear and additive.
  - - 2. Residuals should follow a normal distribution. This is also called RESIDUAL ANALYSIS
  - - 3. No heteroscedasticity. Constant variance of residual. This is because, we need to ensure that the errors are completely random. If there was a pattern in the errors, it means some part of the response var can still be explained and a better model that gives higher R-Sq and accuracy could probably be built.
  - - 4. The predictors are independent of each there. Thats is, there is on multicollinearity. Can be verified by checking the VIF, where, VIF of a variable = 1/1-(Rsq), where Rsq is the R-Sq of the linear model built with that X variable as Y and all other remaining predictors as X's.
The convention is, the VIF should not go more than 4 for any of the X variables. That means we are not letting the R-Sq of any of the X's to go more than 75%. => 1/(1-0.75)

# 3.
# Regression modeling part 1: Univariate and Bivariate analysis

#4. 
# Regression modeling part 2: Outlier Treatment approaches

#5. 
# Regression modeling part 3: Missing Value treatment approaches

#6. 
# Regression modeling part 4: Fitting the linear regression model, independent variable interactions, diagnostics

 - Create multiple lm models - raw variables, interactions, subset models (for anova). etc

#7.
# Regression modeling part 5: Accuracy measures, anova

#8.
# Regression modeling part 6: Residual analysis, Heteroscedasticity and Box Cox Transformation

#9.
# Regression modeling part 7: Model validation - Training and Testing

#10.
# Regression modeling part 8: k-Fold Cross validation - Checking Model stability

#11.
# Regression modeling part 9: Importance of predictors

#12.
# Regression modeling part 10: Selecting best variables - stepwise regression

#13.
# Regression modeling part 11: Finding best models - Best subsets, leaps, finding all possible models (after filtering vifs)

#14.
Project Case Study: Linear regression (mtcars)
