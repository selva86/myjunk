inputData <- read.csv("http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data", header=F)
names(inputData) <- c("AGE", "WORKCLASS", "FNLWGT", 
                      "EDUCATION", "EDUCATIONNUM", "MARITALSTATUS",
                      "OCCUPATION", "RELATIONSHIP", "RACE", "SEX",
                      "CAPITALGAIN", "CAPITALLOSS", "HOURSPERWEEK",
                      "NATIVECOUNTRY", "ABOVE50K")
responseVar <- ifelse(as.character(inputData$ABOVE50K) == " >50K", 1, 0)
inputData$ABOVE50K <- responseVar

# write.csv(inputData, "/Users/selvaprabhakaran/Documents/work/rwork/Logistic regression/adult.csv", row.names=F)
# Logistic regression
# 1. The purpose of logistic regression
# 2. Examples of cases where logistic regression can be used.
# 3. Define a example case we will solve
# 4. Write code for the logistic reg model.
#   - convert rank vars to factors
#   - convert n-level categorical var to 'n' discrete binary variables. => model.matrix
#   - check which variables are influential - wald.test and anova.
#   - check variable importance
#   - check iv
#   - glm with family = binomial
#   - model summary
#   - confidence interval for co-efficients. Both 2.5% and 97.5% should have same sign
# 5. How to interpret model summary results.
# 6. How to predict the class of response variable on new data using the model.
#   - code to get the probability scores.
#   - classify based in a threshold.
# 7. Model performance diagnostics
#   - Misclassification Error
#   - Confusion matrix
#   - Concordance and Discordance
#   - Sensitivity (True positive rate) - Improving click through rates. For capturing all positives even if it causes wrongly classifying the negatives  
#   - Specificity (False positive rate) - Spam detection. Its alright if some spam goes to inbox, but we dont want to wrongly classify a negative (a legit email) as positive (spam)
#   - Youden's J Index
#   - ROC curve
#   - Area under ROC curve
#   - Kappa

# 8. How to overcome class bias
# - WOE
# - IV
# - Optimising threshold
# - Convert continuous variables into factors (smbinning) 



# Setup
library(party)
library(smbinning)
library(ggplot2)
library(Boruta)
library(car)
# devtools::install_github("selva86/InformationValue")
library(InformationValue)

# Read data
# setwd("/Users/selvaprabhakaran/Documents/work/rwork/Logistic regression/")
# inputData <- read.csv ("/Users/selvaprabhakaran/Documents/work/rwork/Logistic regression/adult.csv")

# Exploratory Analysis -----------------------------------------------------

# summary
# summary(inputData)

# Distribution of response var: There is a class bias.
#     0     1 
# 24720  7841 
# Ratio of 1/0 is: 0.317

# Plot Interaction Effects 
education_effect <- aggregate(ABOVE50K ~ EDUCATION, FUN=mean, data=inputData)
ee <- as.data.frame(t(education_effect$ABOVE50K))
colnames(ee) <- education_effect$EDUCATION
ggplot(education_effect, aes(x=EDUCATION, y=ABOVE50K, fill=factor(EDUCATION))) + geom_bar(stat="identity") + labs(y="Proportion of ABOVE 50K Salary")


# Build logistic model the regular way ---------------------------------------
set.seed(100)
inputData$TRAININGFLAG <- character(nrow(inputData))
trainingRows <- sample(1:nrow(inputData), 0.7*nrow(inputData))
inputData$TRAININGFLAG[trainingRows] <- "train"
inputData$TRAININGFLAG[-trainingRows] <- "test"
trainingData <- inputData[trainingRows, ]
testData <- inputData[-trainingRows, ]


# Create WOEs
# workclass_smb <- smbinning.factor(trainingData, y="ABOVE50K", x="WORKCLASS")  # WOE table
# workclass_woemap <- data.frame(cuts=workclass_smb$cuts, woe=head(workclass_smb$ivtable$WoE, nrow(workclass_smb$ivtable)-2))  # create woe map
# workclass_woemap$woe <- ifelse(workclass_woemap$woe %in% c(Inf, -Inf), 0, workclass_woemap$woe)  # replace Inf with 0
# inputData$WORKCLASS_WOE <- workclass_woemap$woe[match(inputData$WORKCLASS, workclass_woemap$cuts)]



# IV Vector
iv_vector <- vector(length=ncol(inputData)-1, mode="list")
names(iv_vector) <- names(inputData)[-ncol(inputData)]

# Loop to create WOE for all factor variables
factor_vars <- c ("WORKCLASS", "EDUCATION", "MARITALSTATUS", "OCCUPATION", "RELATIONSHIP", "RACE", "SEX", "NATIVECOUNTRY")
continuous_vars <- c("AGE", "FNLWGT","EDUCATIONNUM", "HOURSPERWEEK", "CAPITALGAIN", "CAPITALLOSS")

for(factor_var in factor_vars){
  smb <- smbinning.factor(trainingData, y="ABOVE50K", x=factor_var)  # WOE table
  if(class(smb) != "character"){ # some error while calculating scores.
    woemap <- data.frame(cuts=smb$cuts, woe=head(smb$ivtable$WoE, nrow(smb$ivtable)-2))  # create woe map
    woemap$woe <- ifelse(woemap$woe %in% c(Inf, -Inf), 0, woemap$woe)  # replace Inf with 0
    inputData[paste0(factor_var, "_WOE")] <- woemap$woe[match(inputData[[factor_var]], woemap$cuts)]
    iv_vector[[factor_var]] <- smb$iv
  }
}

for(continuous_var in continuous_vars){
  smb <- smbinning(trainingData, y="ABOVE50K", x=continuous_var)  # WOE table
  if(class(smb) != "character"){  # any error while calculating scores.
    woemap <- data.frame(cuts=c(smb$cuts, max(trainingData[[continuous_var]])), woe=head(smb$ivtable$WoE, nrow(smb$ivtable)-2))  # create woe map
    woemap$woe <- ifelse(woemap$woe %in% c(Inf, -Inf), 0, woemap$woe)  # replace Inf with 0
    inputData[[continuous_var]][1] < woemap$cuts
    inputData[paste0(continuous_var, "_WOE")] <- woemap$woe[(findInterval(inputData[[continuous_var]], woemap$cuts, rightmost.closed = T)+1)]
    iv_vector[[continuous_var]] <- smb$iv
  }
}

ivs <- data.frame(VARNAME=names(unlist(iv_vector)), IV=unlist(iv_vector))
ivs <- ivs[order(-ivs$IV), ]
# IV < 0.03 ??? Not Predictive
# 0.03 <= IV < 0.1 ??? Slightly Predictive 
# IV > 0.1 ??? Highly Predictive

# Create all model combinations for important predictors
returnModelObjs <- TRUE
max_model_size <- 7
combos_matrix <- matrix(ncol=max_model_size)  # initialise final output
imp_vars <- as.character(head(ivs$VARNAME, max_model_size))
for (n in 1:length(imp_vars)){
  combs_mat <- t(combn(imp_vars, n))  # all combinations of variable
  nrow_out <- nrow(combs_mat)
  ncol_out <- length(imp_vars)
  nrow_na <- nrow_out
  ncol_na <- ncol_out-ncol(combs_mat)
  na_mat <- matrix(rep(NA, nrow_na*ncol_na), nrow=nrow_na, ncol=ncol_na)
  out <- cbind(combs_mat, na_mat)
  combos_matrix <- rbind(combos_matrix, out)
}
combos_matrix <- combos_matrix[-1, ]  # remove the first row that has all NA

Final_Output <- data.frame()  # initialise the final output dataframe

if(returnModelObjs){
  modelObjs <- vector(nrow(combos_matrix), mode="list")
}

# init progressbar
pb <- txtProgressBar(min=0, max=nrow(combos_matrix), initial=0, char=">", style=3)

for (rownum in 1:nrow(combos_matrix)){
  setTxtProgressBar(pb, rownum)  # update progressbar
  ## Build model for current formula from combos_matrix-
  preds <- na.omit(combos_matrix[rownum, ])  # get the predictor names
  form <- paste ("ABOVE50K ~ ", paste (preds, collapse=" + "), sep="")  # model formula
  currMod <- glm(as.formula(form), data=inputData[inputData$TRAININGFLAG == "train", ], family="binomial")  # build the linear model
  currSumm <- summary(currMod)  # model summary
  
  # update modelObjs
  if(returnModelObjs){
    names(modelObjs)[rownum] <- form
    modelObjs[[form]] <- currMod
  }
  
  # In sample results
  actuals <-  inputData[inputData$TRAININGFLAG == "train", "ABOVE50K"]
  preds <- plogis(predict(currMod))  # prediction probability scores
  
  ## Diagnostic parameters-
  aic <- AIC(currMod)  # AIC
  bic <- BIC(currMod)  # BIC
  optCutOff <- optimalCutoff(actuals, preds)
  auroc.tr <- AUROC(actuals, preds)
  sens.tr <- sensitivity(actuals, preds, threshold = optCutOff)
  spec.tr <- specificity(actuals, preds, threshold = optCutOff)
  misclasserror.tr <- misClassError(actuals, preds, threshold = optCutOff)
  concordance.tr <- Concordance(actuals, preds)$Concordance
  
  # Out-of-Sample results.
  actuals <-  inputData[inputData$TRAININGFLAG == "test", "ABOVE50K"]
  preds <- plogis(predict(currMod, inputData[inputData$TRAININGFLAG == "test", ]))  # prediction probability scores
  
  ## Diagnostic parameters-
  aic <- AIC(currMod)  # AIC
  bic <- BIC(currMod)  # BIC
  optCutOff <- optimalCutoff(actuals, preds)
  auroc.te <- AUROC(actuals, preds)
  sens.te <- sensitivity(actuals, preds, threshold = optCutOff)
  spec.te <- specificity(actuals, preds, threshold = optCutOff)
  misclasserror.te <- misClassError(actuals, preds, threshold = optCutOff)
  concordance.te <- Concordance(actuals, preds)$Concordance
  
  ## Collect all stats for Final Output-
  currOutput <- data.frame(formula=form, AIC=aic, BIC=bic, optCutOff=optCutOff, AUROC.in=auroc.tr,
                           sensitivity.in=sens.tr, specificity.in=spec.tr, misclasserror.in=misclasserror.tr, 
                           concordance.in=concordance.tr, AUROC.out=auroc.te,
                           sensitivity.out=sens.te, specificity.out=spec.te, misclasserror.out=misclasserror.te, 
                           concordance.out=concordance.te)
  
  # Final Output
  Final_Output <- rbind(Final_Output, currOutput)
}

write.csv(Final_Output, "Final_Regression_Output.csv", row.names=F)  # Export


## Note:
# Convert to probability scores
# 1)    exp(z)/(1+exp(z)) (or) plogis(z)
# 2)    1 /  (1 + exp(z))

# Build Model
mod2 <- glm(ABOVE50K ~ MARITALSTATUS + AGE + OCCUPATION + EDUCATION, data=trainingData, family = "binomial")
summary(mod2)
vif(mod2)


mod3 <- glm(ABOVE50K ~ MARITALSTATUS_WOE + AGE + OCCUPATION_WOE + EDUCATION_WOE, data=inputData[inputData$TRAININGFLAG == "train", ], family = "binomial")
summary(mod3)
vif(mod3) # 0.1760672


# fitted
modObj <- mod3
fitted_scores <- predict(modObj)
fitted_probs <- exp(fitted_scores)/(1 + exp(fitted_scores))
# optCutoff <- optimalCutoff(actuals=trainingData$ABOVE50K, predictedScores=fitted_probs, returnDiagnostics = T)
optCutoff <- optimalCutoff(actuals=inputData[inputData$TRAININGFLAG == "train", "ABOVE50K"], predictedScores=fitted_probs, returnDiagnostics = T)


# predict
# pred_scores <- predict(modObj, testData)
pred_scores <- predict(modObj, inputData[inputData$TRAININGFLAG == "test", ])
pred_probs <- exp(pred_scores)/ (1 + exp(pred_scores))

predicted_class <- ifelse(pred_probs > optCutoff$optimalCutoff, 1, 0)
mean(predicted_class != testData$ABOVE50K)  # 0.1760672
plotROC(actuals=inputData[inputData$TRAININGFLAG == "train", ], predictedScores=fitted_probs)



# predict
predicted_mod3 <- predict(mod3, inputData[inputData$TRAININGFLAG == "test", ])
predicted_class <- ifelse(predicted_mod3 > 0.5, 1, 0)
predicted_class <- ifelse(predicted_mod2 > 0.00864, 1, 0)
mean(predicted_class != testData$ABOVE50K)  # 0.1751459

# Optimise probability cutoff
predScores <- predict(mod3, trainingData)
ctoff <- optimalCutoff(trainingData$ABOVE50K, predScores)
ctoff_all <- optimalCutoff(trainingData$ABOVE50K, predScores, returnDiagnostics=TRUE)


# Check significance: Categorical
workclass.chisq <- chisq.test(table(inputData$ABOVE50K, inputData$WORKCLASS), correct = FALSE)
education.chisq <- chisq.test(table(inputData$ABOVE50K, inputData$EDUCATION), correct = FALSE)
maritalstatus.chisq <- chisq.test(table(inputData$ABOVE50K, inputData$MARITALSTATUS), correct = FALSE)
occupation.chisq <- chisq.test(table(inputData$ABOVE50K, inputData$OCCUPATION), correct = FALSE)
relationship.chisq <- chisq.test(table(inputData$ABOVE50K, inputData$RELATIONSHIP), correct = FALSE)
race.chisq <- chisq.test(table(inputData$ABOVE50K, inputData$RACE), correct = FALSE)
sex.chisq <- chisq.test(table(inputData$ABOVE50K, inputData$SEX), correct = FALSE)
nativecountry.chisq <- chisq.test(table(inputData$ABOVE50K, inputData$NATIVECOUNTRY), correct = FALSE)

# p-value
pValue_vector <- vector(length=ncol(inputData)-1, mode="list")
names(pValue_vector) <- names(inputData)[-ncol(inputData)]

pValue_vector$WORKCLASS <- chisq.test(table(inputData$ABOVE50K, inputData$WORKCLASS), correct = FALSE)$p.value
pValue_vector$EDUCATION <- chisq.test(table(inputData$ABOVE50K, inputData$EDUCATION), correct = FALSE)$p.value
pValue_vector$MARITALSTATUS <- chisq.test(table(inputData$ABOVE50K, inputData$MARITALSTATUS), correct = FALSE)$p.value
pValue_vector$OCCUPATION <- chisq.test(table(inputData$ABOVE50K, inputData$OCCUPATION), correct = FALSE)$p.value
pValue_vector$RELATIONSHIP <- chisq.test(table(inputData$ABOVE50K, inputData$RELATIONSHIP), correct = FALSE)$p.value
pValue_vector$RACE <- chisq.test(table(inputData$ABOVE50K, inputData$RACE), correct = FALSE)$p.value
pValue_vector$SEX <- chisq.test(table(inputData$ABOVE50K, inputData$SEX), correct = FALSE)$p.value
pValue_vector$NATIVECOUNTRY <- chisq.test(table(inputData$ABOVE50K, inputData$NATIVECOUNTRY), correct = FALSE)$p.value




# Check signficance: Continuous
age.aov <- summary(aov(AGE ~ ABOVE50K, inputData))
hoursperweek.aov <- aov(HOURSPERWEEK ~ ABOVE50K, inputData)
capitalloss.aov <- aov(CAPITALLOSS ~ ABOVE50K, inputData)
capitalgain.aov <- aov(CAPITALGAIN ~ ABOVE50K, inputData)


# Check importance
borutaImp <- Boruta(ABOVE50K ~ ., data=testData)

rfMod <- cforest(ABOVE50K ~ ., data=inputData)
varimp(rfMod)

# Check information Value


# Build logistic model with WOE, class bias, variable selection etc ----------





















# AGE                    WORKCLASS         FNLWGT                EDUCATION    
# Min.   :17.00    Private         :22696   Min.   :  12285    HS-grad     :10501  
# 1st Qu.:28.00    Self-emp-not-inc: 2541   1st Qu.: 117827    Some-college: 7291  
# Median :37.00    Local-gov       : 2093   Median : 178356    Bachelors   : 5355  
# Mean   :38.58    ?               : 1836   Mean   : 189778    Masters     : 1723  
# 3rd Qu.:48.00    State-gov       : 1298   3rd Qu.: 237051    Assoc-voc   : 1382  
# Max.   :90.00    Self-emp-inc    : 1116   Max.   :1484705    11th        : 1175  
# (Other)          :  981                     (Other)      : 5134  
# EDUCATIONNUM                  MARITALSTATUS              OCCUPATION  
# Min.   : 1.00    Divorced             : 4443    Prof-specialty :4140  
# 1st Qu.: 9.00    Married-AF-spouse    :   23    Craft-repair   :4099  
# Median :10.00    Married-civ-spouse   :14976    Exec-managerial:4066  
# Mean   :10.08    Married-spouse-absent:  418    Adm-clerical   :3770  
# 3rd Qu.:12.00    Never-married        :10683    Sales          :3650  
# Max.   :16.00    Separated            : 1025    Other-service  :3295  
# Widowed              :  993   (Other)         :9541  
# RELATIONSHIP                    RACE            SEX         CAPITALGAIN   
# Husband       :13193    Amer-Indian-Eskimo:  311    Female:10771   Min.   :    0  
# Not-in-family : 8305    Asian-Pac-Islander: 1039    Male  :21790   1st Qu.:    0  
# Other-relative:  981    Black             : 3124                   Median :    0  
# Own-child     : 5068    Other             :  271                   Mean   : 1078  
# Unmarried     : 3446    White             :27816                   3rd Qu.:    0  
# Wife          : 1568                                               Max.   :99999  
# 
# CAPITALLOSS      HOURSPERWEEK          NATIVECOUNTRY      ABOVE50K     
# 1st Qu.:   0.0   1st Qu.:40.00    Mexico       :  643   1st Qu.:0.0000  
# Min.   :   0.0   Min.   : 1.00    United-States:29170   Min.   :0.0000  
# Median :   0.0   Median :40.00    ?            :  583   Median :0.0000  
# Mean   :  87.3   Mean   :40.44    Philippines  :  198   Mean   :0.2408  
# 3rd Qu.:   0.0   3rd Qu.:45.00    Germany      :  137   3rd Qu.:0.0000  
# Max.   :4356.0   Max.   :99.00    Canada       :  121   Max.   :1.0000  
# (Other)       : 1709                   

