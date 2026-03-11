# Project 3 — Model Comparison & Final Report

## 📌 Project Goal

This project provides a **comprehensive comparison of all regression models developed across the portfolio (Projects 1–7).**

The goal is to evaluate how different regression techniques perform across two datasets and identify the best models for each task.

The analysis demonstrates:

- Linear regression modeling
- Logistic regression classification
- Regularized regression techniques
- Model comparison using multiple evaluation metrics

This project serves as the **final summary of the regression modeling portfolio**.

---

# 📊 Datasets

### Insurance Dataset
- **Sample size:** 1,338 individuals  
- **Outcome:** Medical insurance charges (continuous variable)

Goal: Predict healthcare costs using demographic and lifestyle variables.

---

### Heart Disease Dataset
- **Sample size:** 1,025 patients  
- **Outcome:** Presence of heart disease (binary outcome)

Goal: Predict disease presence using clinical and diagnostic variables.

---

# 🧪 Part 1 — Linear Regression Models

Three models were compared for predicting insurance charges.

### 1️⃣ Simple Linear Regression
Predictor:
- Age only

Performance:
- Limited explanatory power
- Useful mainly as a baseline model

---

### 2️⃣ Multiple Linear Regression
Predictors:
- Age
- BMI
- Smoking status
- Region

Performance:
- **Best performing linear model**
- Explains approximately **75% of variance in medical charges**

Smoking status emerged as the strongest predictor of insurance costs.

---

### 3️⃣ Polynomial Regression
Includes quadratic terms for age and BMI.

Performance:
- Slight increase in model complexity
- No meaningful improvement in predictive performance

---

### 🏆 Best Linear Model

**Multiple Linear Regression**

- **R² ≈ 0.75**

This model provides strong explanatory power while remaining interpretable.

---

# 🧪 Part 2 — Logistic Regression Models

Three logistic models were developed for heart disease prediction.

---

### 1️⃣ Baseline Model
Intercept-only model.

Performance:
- No predictive ability
- Serves as a reference point.

---

### 2️⃣ Clinical Model
Predictors include basic clinical measurements:

- Age
- Sex
- Chest pain type
- Blood pressure
- Cholesterol
- Fasting blood sugar
- Maximum heart rate

Performance:
- **AUC ≈ 0.88**
- Good discrimination for disease detection
- Uses easily available clinical data.

---

### 3️⃣ Full Logistic Model
Includes all diagnostic variables such as:

- ECG findings
- Exercise test results
- Angiography variables
- Clinical measurements

Performance:
- **AUC ≈ 0.95**
- Excellent predictive accuracy
- Highest sensitivity and specificity.

---

### 🏆 Best Logistic Model

**Full Logistic Regression Model**

- **AUC ≈ 0.95**

This model provides the strongest ability to distinguish between healthy and diseased patients.

---

# 🧪 Part 3 — Regularized Regression

Three regularization techniques were evaluated:

- Ridge Regression
- Lasso Regression
- Elastic Net

All models used:

- Logistic regression framework
- 10-fold cross-validation for λ selection
- ROC/AUC for evaluation.

---

### Ridge Regression
- Shrinks coefficients
- Keeps all predictors

Performance:

- **AUC ≈ 0.92**

---

### Lasso Regression
- Performs automatic feature selection
- Removes less important predictors

Performance:

- **AUC ≈ 0.92**

---

### Elastic Net
- Combines Ridge and Lasso penalties
- Balances shrinkage and variable selection

Performance:

- **AUC ≈ 0.92**

---

### 🏆 Best Regularized Model

All regularization methods performed **nearly identically**.

This indicates that the dataset does not suffer from:

- severe multicollinearity
- high dimensionality
- excessive model complexity.

---

# 📊 Overall Model Comparison

| Task | Best Model | Performance |
|-----|-----|-----|
| Insurance Cost Prediction | Multiple Linear Regression | R² ≈ 0.75 |
| Heart Disease Prediction | Full Logistic Regression | AUC ≈ 0.95 |
| Regularized Models | Ridge / Lasso / Elastic Net | AUC ≈ 0.92 |

---

# 🧠 Key Insights

### Linear Regression
Multiple regression significantly improved performance compared to simple regression by incorporating important predictors such as smoking status.

---

### Logistic Regression
Including full diagnostic information substantially improved disease prediction accuracy.

---

### Regularization
Regularization methods performed similarly because the dataset is relatively well-behaved and not highly dimensional.

However, these techniques become essential when dealing with:

- high-dimensional data
- multicollinearity
- small sample sizes.

---

# ⚠️ Limitations

- Models evaluated on the full dataset (no train/test split)
- Results may not generalize to other datasets
- No external validation

This analysis is intended for **educational demonstration of statistical modeling techniques**.

---

# 🎯 Conclusion

This portfolio demonstrates a complete workflow for regression analysis:

- Linear regression for continuous outcomes
- Logistic regression for binary classification
- Regularization methods for complex datasets
- Model comparison using statistical and predictive metrics

The progression from simple models to advanced techniques provides a strong foundation in applied regression modeling.

---

## 📚 Educational Value

This project reinforces key concepts in statistical modeling:

- Model building and interpretation
- Performance evaluation
- Model comparison
- Handling complex datasets

These techniques are widely used in **data science, epidemiology, and applied research**.
