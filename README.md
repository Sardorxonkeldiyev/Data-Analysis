# 📊 World Layoffs: SQL Data Cleaning & Exploration

## 📝 Project Overview
This project is a comprehensive data analysis study using a raw "World Layoffs" dataset. It is divided into two major phases: **Data Cleaning** (preparing the data) and **Exploratory Data Analysis** (extracting insights).

## 📂 Project Structure

### 1. Data Cleaning (`Data_Cleaning_Scripts.sql`)
In this phase, I transformed the raw dataset into a clean and reliable format. Key steps included:
* **Removing Duplicates:** Using `ROW_NUMBER()` and CTEs.
* **Standardization:** Fixing industry names, trimming spaces, and unifying country labels.
* **Date Conversion:** Formatting text dates into proper SQL `DATE` objects.
* **Handling Nulls:** Using **Self-Joins** to populate missing information.

### 2. Exploratory Data Analysis (`Exploratory_Data_Analysis.sql`)
In this phase, I conducted a deep dive into the data to find trends and patterns. 
* **Note:** This script includes professional comments in **English, Russian, and Uzbek**.
* **Key Metrics:** Total layoffs by company, industry, and country.
* **Time Series:** Layoffs trended by year and month.
* **Advanced Analytics:** Calculating **Rolling Totals** and **Company Rankings** (Top 5 per year) using Window Functions.

## 🛠️ Tools & Technologies
* **Database:** MySQL
* **Language:** SQL
* **Techniques:** CTEs, Window Functions (DENSE_RANK, SUM OVER), Joins, String Functions.

## 📌 Acknowledgments
This project was inspired by and follows the educational methodology of **Alex The Analyst**. The dataset and core concepts are based on his professional data analysis curriculum.

---
*Created by Sardor - Aspiring Data Analyst*
