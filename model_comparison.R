# ========================================================
# Project 8: Model Comparison & Reporting
# Goal: Compare all models from Projects 1-7
# ========================================================

# Load libraries
library(tidyverse)
library(broom)
library(pROC)
library(caret)
library(glmnet)

# ========================================================
# PART 1: LINEAR REGRESSION MODELS (Insurance Dataset)
# ========================================================

# Read insurance data
insurance <- read_csv("insurance.csv")

# Prepare data
insurance <- insurance %>%
  mutate(
    sex = as.factor(sex),
    smoker = as.factor(smoker),
    region = as.factor(region)
  )

# Model 1: Simple Linear Regression (age → charges)
model_simple <- lm(charges ~ age, data = insurance)
glance_simple <- glance(model_simple)

# Model 2: Multiple Linear Regression
model_multiple <- lm(charges ~ age + bmi + smoker + region, data = insurance)
glance_multiple <- glance(model_multiple)

# Model 3: Polynomial Regression (age² + bmi²)
model_poly <- lm(charges ~ age + I(age^2) + bmi + I(bmi^2), data = insurance)
glance_poly <- glance(model_poly)

# Compare Linear Models
linear_comparison <- data.frame(
  Model = c("Simple Linear", "Multiple Linear", "Polynomial"),
  R_squared = c(glance_simple$r.squared, glance_multiple$r.squared, glance_poly$r.squared),
  Adj_R_squared = c(glance_simple$adj.r.squared, glance_multiple$adj.r.squared, glance_poly$adj.r.squared),
  AIC = c(AIC(model_simple), AIC(model_multiple), AIC(model_poly)),
  BIC = c(BIC(model_simple), BIC(model_multiple), BIC(model_poly))
)

print("=== LINEAR REGRESSION COMPARISON ===")
print(linear_comparison)

# Winner: Best model for linear regression
best_linear <- linear_comparison %>%
  arrange(desc(Adj_R_squared)) %>%
  slice(1)

print(paste("Best Linear Model:", best_linear$Model))

# ========================================================
# PART 2: LOGISTIC REGRESSION MODELS (Heart Disease)
# ========================================================

# Read heart disease data
heart <- read_csv("heart.csv")

# Prepare data
heart <- heart %>%
  mutate(
    target = as.factor(target),
    sex = as.factor(sex),
    cp = as.factor(cp),
    fbs = as.factor(fbs),
    restecg = as.factor(restecg),
    exang = as.factor(exang),
    slope = as.factor(slope),
    ca = as.factor(ca),
    thal = as.factor(thal)
  )

# Baseline: Intercept-only model
model_baseline <- glm(target ~ 1, data = heart, family = binomial)

# Clinical model
model_clinical <- glm(target ~ age + sex + cp + trestbps + chol + fbs + thalach,
                      data = heart, family = binomial)

# Full model
model_full <- glm(target ~ age + sex + cp + trestbps + chol + fbs + restecg +
                    thalach + exang + oldpeak + slope + ca + thal,
                  data = heart, family = binomial)

# Get predictions
pred_baseline <- predict(model_baseline, type = "response")
pred_clinical <- predict(model_clinical, type = "response")
pred_full <- predict(model_full, type = "response")

# Convert to classes
class_baseline <- ifelse(pred_baseline > 0.5, "1", "0")
class_clinical <- ifelse(pred_clinical > 0.5, "1", "0")
class_full <- ifelse(pred_full > 0.5, "1", "0")

# Calculate AUC
auc_baseline <- auc(roc(heart$target, pred_baseline))
auc_clinical <- auc(roc(heart$target, pred_clinical))
auc_full <- auc(roc(heart$target, pred_full))

# Confusion matrices
conf_baseline <- confusionMatrix(as.factor(class_baseline), heart$target, positive = "1")
conf_clinical <- confusionMatrix(as.factor(class_clinical), heart$target, positive = "1")
conf_full <- confusionMatrix(as.factor(class_full), heart$target, positive = "1")

# Compare Logistic Models
logistic_comparison <- data.frame(
  Model = c("Baseline", "Clinical", "Full"),
  Deviance = c(
    glance(model_baseline)$deviance,
    glance(model_clinical)$deviance,
    glance(model_full)$deviance
  ),
  AIC = c(AIC(model_baseline), AIC(model_clinical), AIC(model_full)),
  AUC = c(auc_baseline, auc_clinical, auc_full),
  Accuracy = c(
    conf_baseline$overall["Accuracy"],
    conf_clinical$overall["Accuracy"],
    conf_full$overall["Accuracy"]
  ),
  Sensitivity = c(
    conf_baseline$byClass["Sensitivity"],
    conf_clinical$byClass["Sensitivity"],
    conf_full$byClass["Sensitivity"]
  ),
  Specificity = c(
    conf_baseline$byClass["Specificity"],
    conf_clinical$byClass["Specificity"],
    conf_full$byClass["Specificity"]
  )
)

print("=== LOGISTIC REGRESSION COMPARISON ===")
print(logistic_comparison)

# Winner: Best model for logistic regression
best_logistic <- logistic_comparison %>%
  arrange(desc(AUC)) %>%
  slice(1)

print(paste("Best Logistic Model:", best_logistic$Model))

# ========================================================
# PART 3: REGULARIZED REGRESSION (Heart Disease)
# ========================================================

# Prepare data for glmnet
x <- model.matrix(target ~ ., data = heart)[, -1]
y <- as.numeric(as.character(heart$target))

# Ridge
set.seed(123)
cv_ridge <- cv.glmnet(x, y, family = "binomial", alpha = 0)
model_ridge <- glmnet(x, y, family = "binomial", alpha = 0, lambda = cv_ridge$lambda.min)
pred_ridge <- as.vector(predict(model_ridge, newx = x, type = "response"))
auc_ridge <- auc(roc(y, pred_ridge))

# Lasso
set.seed(123)
cv_lasso <- cv.glmnet(x, y, family = "binomial", alpha = 1)
model_lasso <- glmnet(x, y, family = "binomial", alpha = 1, lambda = cv_lasso$lambda.min)
pred_lasso <- as.vector(predict(model_lasso, newx = x, type = "response"))
auc_lasso <- auc(roc(y, pred_lasso))

# Elastic Net
set.seed(123)
cv_elastic <- cv.glmnet(x, y, family = "binomial", alpha = 0.5)
model_elastic <- glmnet(x, y, family = "binomial", alpha = 0.5, lambda = cv_elastic$lambda.min)
pred_elastic <- as.vector(predict(model_elastic, newx = x, type = "response"))
auc_elastic <- auc(roc(y, pred_elastic))

# Compare Regularized Models
regularized_comparison <- data.frame(
  Model = c("Ridge", "Lasso", "Elastic Net"),
  AUC = c(auc_ridge, auc_lasso, auc_elastic),
  N_Predictors = c(
    sum(coef(model_ridge) != 0) - 1,
    sum(coef(model_lasso) != 0) - 1,
    sum(coef(model_elastic) != 0) - 1
  )
)

print("=== REGULARIZED REGRESSION COMPARISON ===")
print(regularized_comparison)

# Winner: Best regularized model
best_regularized <- regularized_comparison %>%
  arrange(desc(AUC)) %>%
  slice(1)

print(paste("Best Regularized Model:", best_regularized$Model))

# ========================================================
# PART 4: OVERALL SUMMARY
# ========================================================

print("=== OVERALL SUMMARY ===")
print("")
print("LINEAR REGRESSION (Insurance Data):")
print(paste("  Best Model:", best_linear$Model))
print(paste("  R²:", round(best_linear$R_squared, 3)))
print(paste("  Adjusted R²:", round(best_linear$Adj_R_squared, 3)))
print("")
print("LOGISTIC REGRESSION (Heart Disease):")
print(paste("  Best Model:", best_logistic$Model))
print(paste("  AUC:", round(best_logistic$AUC, 3)))
print(paste("  Accuracy:", round(best_logistic$Accuracy, 3)))
print(paste("  Sensitivity:", round(best_logistic$Sensitivity, 3)))
print("")
print("REGULARIZED REGRESSION (Heart Disease):")
print(paste("  Best Model:", best_regularized$Model))
print(paste("  AUC:", round(best_regularized$AUC, 3)))

# ========================================================
# PART 5: VISUALIZATIONS
# ========================================================

# Plot 1: Linear Models R²
barplot(linear_comparison$R_squared,
        names.arg = linear_comparison$Model,
        main = "Linear Models: R² Comparison",
        ylab = "R²",
        col = "steelblue",
        ylim = c(0, 1))

# Plot 2: Logistic Models AUC
barplot(logistic_comparison$AUC,
        names.arg = logistic_comparison$Model,
        main = "Logistic Models: AUC Comparison",
        ylab = "AUC",
        col = "coral",
        ylim = c(0, 1))

# Plot 3: All Heart Disease Models AUC
all_heart_auc <- c(
  logistic_comparison$AUC,
  regularized_comparison$AUC
)
all_heart_names <- c(
  paste("Log:", logistic_comparison$Model),
  paste("Reg:", regularized_comparison$Model)
)

barplot(all_heart_auc,
        names.arg = all_heart_names,
        main = "Heart Disease: All Models AUC",
        ylab = "AUC",
        col = rainbow(length(all_heart_auc)),
        las = 2,
        cex.names = 0.8)

# ========================================================
# DONE!
# ========================================================

print("=== ANALYSIS COMPLETE ===")
