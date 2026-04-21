-- ==========================================================================================
-- PROJECT: EXPLORATORY DATA ANALYSIS (EDA) 
-- DATASET: World Layoffs
-- LANGUAGES: English (EN), Russian (RU), Uzbek (UZ)
-- ==========================================================================================

-- 1. Initial Overview / Начальный обзор / Dastlabki ko'zdan kechirish
-- EN: View the entire cleaned dataset to understand the structure.
-- RU: Просмотр всего очищенного набора данных для понимания структуры.
-- UZ: Strukturani tushunish uchun barcha tozalangan ma'lumotlarni ko'rish.
SELECT * FROM layoffs_staging2;


-- 2. Basic Aggregations / Базовые агрегации / Asosiy agregat funksiyalar
-- EN: Find the maximum number of layoffs and the highest percentage of company reductions.
-- RU: Нахождение максимального количества увольнений и самого высокого процента сокращений.
-- UZ: Eng ko'p ishdan bo'shatish sonini va kompaniya qisqarishining eng yuqori foizini topish.
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;


-- 3. Companies with 100% Layoffs / Компании со 100% увольнением / 100% ishdan bo'shatgan kompaniyalar
-- EN: Identify companies that completely shut down or laid off everyone.
-- RU: Идентификация компаний, которые полностью закрылись или уволили всех сотрудников.
-- UZ: To'liq yopilgan yoki hamma xodimlarni bo'shatgan kompaniyalarni aniqlash.
SELECT * FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;


-- 4. Grouping by Categories / Группировка по категориям / Kategoriyalar bo'yicha guruhlash
-- EN: Analyzing total layoffs by Company, Industry, and Country.
-- RU: Анализ общего количества увольнений по компаниям, отраслям и странам.
-- UZ: Kompaniya, soha va davlatlar bo'yicha jami ishdan bo'shatishlarni tahlil qilish.

-- By Company
SELECT company, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- By Industry
SELECT industry, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- By Country
SELECT country, SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;


-- 5. Time Series Analysis / Анализ временных рядов / Vaqt bo'yicha tahlil
-- EN: Looking at layoffs over years and months to find trends.
-- RU: Просмотр увольнений по годам и месяцам для поиска тенденций.
-- UZ: Trendlarni topish uchun yillar va oylar bo'yicha bo'shatishlarni ko'rib chiqish.

-- Layoffs by Year
SELECT YEAR(`date`), SUM(total_laid_off) 
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Layoffs by Month (Rolling Period)
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;


-- 6. Rolling Total Calculation / Расчет накопительного итога / O'sib boruvchi jami hisob-kitobi
-- EN: Using a CTE and Window Function to calculate cumulative layoffs over time.
-- RU: Использование CTE и оконной функции для расчета кумулятивных увольнений с течением времени.
-- UZ: Vaqt o'tishi bilan o'sib boruvchi (kumulyativ) jami bo'shatishlarni hisoblash uchun CTE va Window Functiondan foydalanish.
WITH Rolling_Total AS 
(
    SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`,1,7) IS NOT NULL
    GROUP BY `MONTH`
    ORDER BY 1 ASC
) 
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


-- 7. Advanced Ranking (Top 5 per Year) / Продвинутый рейтинг (Топ-5 в год) / Murakkab reyting (Yillik Top-5)
-- EN: Ranking the top 5 companies with most layoffs for each specific year.
-- RU: Рейтинг топ-5 компаний с наибольшим количеством увольнений за каждый конкретный год.
-- UZ: Har bir yil uchun eng ko'p ishdan bo'shatgan kuchli 5 ta kompaniyani reytingga solish.
WITH Company_Year (company, years, total_laid_off) AS 
(
    SELECT company, YEAR(`date`), SUM(total_laid_off) 
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
), Company_rank AS
(
    SELECT *, 
    DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
    FROM Company_Year
    WHERE years IS NOT NULL
)
SELECT * FROM Company_rank
WHERE Ranking <= 5;