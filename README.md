# 🎧 Spotify Dataset Analysis

This repository contains a comprehensive **Exploratory Data Analysis (EDA)** of a Spotify dataset. The analysis aims to uncover insights related to track characteristics, popularity, genre differences, and statistical relationships using R.

## 📁 Dataset

The dataset contains various audio features and metadata for tracks available on Spotify, including:
- Acousticness
- Energy
- Speechiness
- Valence
- Tempo
- Key
- Mode
- Popularity
- Genre and subgenre

## 📌 Objectives

- Clean and preprocess the Spotify dataset.
- Perform EDA to identify patterns and outliers.
- Test statistical hypotheses related to song attributes.
- Evaluate relationships using correlation and regression analysis.

---

## 🔧 Data Cleaning

- **Missing Value Check**:
  Used `sapply()` and `is.na()` to identify columns with missing values.
- **Remove NA Rows**:
  Applied `na.omit()` to remove rows containing `NA` values.
- **Outlier Detection**:
  Used the **IQR method** to detect and remove outliers from key numerical variables.
- **Feature Reduction**:
  Removed less informative columns like `playlist_subgenre`, `acousticness`, `instrumentalness`, and `liveness` using the `subset()` function.

---

## 🧪 Hypothesis Testing

### 📊 Question 1: Is the mean speechiness of all songs ≠ 0.2?
- **H₀**: μ = 0.2
- **H₁**: μ ≠ 0.2
- **Result**: **Reject H₀** (p-value < 2.2e-16)
- **Insight**: Speechiness is significantly different from 0.2. Most songs have low speechiness (0.0–0.1 range).

### 📊 Question 2: Is the mean valence ≠ 0.5?
- **H₀**: μ = 0.5
- **H₁**: μ ≠ 0.5
- **Result**: **Reject H₀** (p-value = 2.427e-16)
- **Insight**: Songs cluster around moderate valence but are statistically different from 0.5.

### 📊 Question 3: Is there a difference in energy between Rock and Pop genres?
- **H₀**: μ_Rock = μ_Pop
- **H₁**: μ_Rock ≠ μ_Pop
- **Result**: **Reject H₀** (p-value = 2.427e-16)
- **Insight**: Rock songs have significantly higher energy on average.

---

## 📈 Correlation Analysis

- Selected Variables: `track_popularity`, `key`, `mode`, `duration_ms`, `tempo`
- **Method**: Used `cor()` and `corrplot()` for visual representation.
- **Findings**:
  - Weak positive correlation between popularity and duration_ms.
  - No strong correlation between tempo and popularity.

---

## 📊 Regression Analysis

### 📌 Model 1: Predicting `track_popularity` using `key`, `energy`, and `speechiness`
- **Significant Predictor**: `energy` (p < 0.0001)
- **Interpretation**: High energy negatively impacts popularity.
- **R²**: 0.0118 (Model explains ~1.2% of variance)

### 📌 Model 2: Popularity ~ Duration
- **Result**: Statistically significant (p < 0.0001)
- **Insight**: Longer songs tend to be slightly less popular.

### 📌 Model 3: Popularity ~ Tempo
- **Result**: Not significant (p = 0.3157)
- **Insight**: Tempo does not have a significant effect on popularity.

## ✅ Key Takeaways

- Rock music tends to be more energetic than Pop.
- Speechiness and valence are not uniformly distributed across tracks.
- Energy negatively impacts popularity significantly.
- Duration and tempo have minimal to no practical impact on popularity.
- The Spotify dataset is rich for exploring trends across genres and features.

---

## 💡 Future Work

- Include genre-based clustering using K-means or PCA.
- Build a predictive model using more features (e.g., Random Forest).
- Analyze temporal trends (song characteristics by year).

---

## 📚 Tools & Libraries

- `R`, `ggplot2`, `corrplot`, `dplyr`, `t.test`, `lm`

---

## 📊 Visualizations

- Histograms for distribution of speechiness and valence.
- Boxplots comparing energy by genre.
- Correlation heatmap using `corrplot`.
- Scatterplots for regression models.
