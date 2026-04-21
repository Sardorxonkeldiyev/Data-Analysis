-- 1. Remove duplicates

-- 2. Standardize the Data

-- 3. Null Values or Blank values

-- 4. Remove Any Columns

-- 1. Asl jadval strukturasini ko'chirib, yangi 'layoffs_staging' yaratish
CREATE TABLE world_layoffs.layoffs_staging
LIKE world_layoffs.layoffs;

-- 2. Ma'lumotlarni nusxalash
INSERT world_layoffs.layoffs_staging
SELECT * FROM world_layoffs.layoffs;

# 📌 2-bosqich: Takrorlangan qatorlarni (Duplicates) o'chirish
-- 'layoffs_staging2' jadvalini yaratish (row_num ustuni bilan)
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT 
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Row_number orqali nusxalarni aniqlab, yangi jadvalga ko'chirish
INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM world_layoffs.layoffs_staging;

-- 'row_num' 1 dan katta bo'lgan (nusxa) qatorlarni o'chirish
SET SQL_SAFE_UPDATES = 0;
DELETE FROM layoffs_staging2
WHERE row_num > 1;

# 3-bosqich: Ma'lumotlarni standartlashtirish (Standardizing)

-- 1. Kompaniya nomlaridagi ortiqcha bo'sh joylarni olib tashlash
UPDATE layoffs_staging2
SET company = TRIM(company);

-- 2. Bir xil sohalarni guruhlash (masalan: Crypto, CryptoCurrency -> Crypto)
UPDATE layoffs_staging2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- 3. Davlat nomlaridagi nuqta yoki xatolarni tozalash
UPDATE layoffs_staging2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- 4. Matn ko'rinishidagi sanani 'DATE' formatiga o'tkazish
UPDATE layoffs_staging2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Ustun turini matndan sanaga o'zgartirish
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

# 4-bosqich: Bo'sh va NULL qiymatlar bilan ishlash

-- 1. Bo'sh kataklarni (empty strings) NULL ga o'tkazish (ishni osonlashtirish uchun)
UPDATE layoffs_staging2
SET industry = NULL
WHERE industry = '';

-- 2. Self-Join orqali: Agar kompaniyaning bir qatorida 'industry' bo'lsa, 
-- o'sha kompaniyaning NULL qatorlarini o'sha ma'lumot bilan to'ldirish.
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

# 5-bosqich: Keraksiz qator va ustunlarni o'chirish

-- 1. Ham 'total_laid_off', ham 'percentage' bo'lmagan qatorlarni o'chirish
DELETE FROM layoffs_staging2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- 2. Tozalash uchun ishlatilgan vaqtinchalik 'row_num' ustunini o'chirib tashlash
ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

-- Yakuniy natijani ko'rish
SELECT * FROM layoffs_staging2;

# Bu World Layoffs: Data Cleaning Project
# Ushbu loyihaning maqsadi — dunyodagi ishdan bo'shatishlar (layoffs) bo'yicha xom ma'lumotlarni tahlilga tayyor holatga keltirish.