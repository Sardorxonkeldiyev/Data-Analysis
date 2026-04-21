# 📊 World Layoffs Data Cleaning Project

## 📝 Project Overview
This project involves a comprehensive data cleaning process of a raw "World Layoffs" dataset using **MySQL**. The goal was to transform messy, inconsistent data into a structured and reliable format suitable for further Exploratory Data Analysis (EDA).

## 🛠️ Tools & Technologies Used
* **Database:** MySQL
* **Language:** SQL
* **Key Concepts:** CTEs, Window Functions (ROW_NUMBER), Joins, Data Standardization, Handling Null Values.

## 🚀 Key Steps Performed

### 1. Remove Duplicates
Identified and removed duplicate entries using the `ROW_NUMBER()` window function partitioned by all columns to ensure data uniqueness.

### 2. Standardize the Data
* **Trimming:** Removed unnecessary leading/trailing spaces from company names.
* **Consistency:** Unified industry names (e.g., merging all variations of 'Crypto' into one standard label).
* **Country Cleanup:** Fixed trailing punctuation in country names (e.g., "United States.").

### 3. Date Formatting
Converted the `date` column from a `text` format into a proper `DATE` format (`YYYY-MM-DD`) to allow for time-series analysis.

### 4. Handling Null and Blank Values
* Populated missing `industry` data by performing a **Self-Join** on companies with existing records.
* Removed rows where both `total_laid_off` and `percentage_laid_off` were null, as they provided no analytical value.

### 5. Final Schema Optimization
Dropped technical columns (like `row_num`) used during the cleaning process to keep the final table clean and efficient.

## 📂 Project Structure
* `data_cleaning_script.sql`: The main SQL script containing all cleaning steps.
* `layoffs.csv`: The raw dataset used for this project.

---
*Created by Sardor - Aspiring Data Analyst*

