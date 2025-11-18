SELECT * FROM sql_projects.layoffs_staging2;

-- years included in the study --

Select  DISTINCT YEAR(date)
From layoffs_staging2;

-- industries included in the study -- 

Select DISTINCT industry
From layoffs_staging2
;

Select COUNT(DISTINCT industry)
From layoffs_staging2
;

-- locations included in the study --

Select DISTINCT location
From layoffs_staging2
;

Select COUNT(DISTINCT location)
From layoffs_staging2
;

 -- Countries in the study --
 
 Select DISTINCT country
From layoffs_staging2
;

Select COUNT(DISTINCT country)
From layoffs_staging2
;

-- Companies in the study --

Select DISTINCT company
From layoffs_staging2
;

Select COUNT(DISTINCT company)
From layoffs_staging2
;

-- Countries with the most layoffs

Select country, SUM(total_laid_off)
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
Group by country
Order by SUM(total_laid_off) DESC
LIMIT 15
;

-- Countries with the least layoffs --

Select country, SUM(total_laid_off)
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
Group by country
Order by SUM(total_laid_off)
LIMIT 15
;

-- cities with the most layoffs -- 

Select location, SUM(total_laid_off)
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
Group by location
Order by SUM(total_laid_off) DESC
LIMIT 15
;

-- Cities with the least layoffs -- 

Select location, SUM(total_laid_off)
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
Group by location
Order by SUM(total_laid_off)
LIMIT 15
;

-- Industries with the most layoffs -- 

Select industry, SUM(total_laid_off)
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
Group by industry
Order by SUM(total_laid_off) DESC
LIMIT 5
;

-- industries with the least layoffs

Select industry, SUM(total_laid_off)
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
Group by industry
Order by SUM(total_laid_off)
LIMIT 5
;

-- companies with the most layoffs -- 

Select company,industry, SUM(total_laid_off)
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
Group by company, industry
Order by SUM(total_laid_off) DESC
LIMIT 20
;

-- Companies with the least layoffs -- 

Select company, industry, SUM(total_laid_off)
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
Group by company, industry
Order by SUM(total_laid_off)
LIMIT 20
;

-- Percent laid off by industry

Select industry, AVG(percentage_laid_off)
From layoffs_staging2
Group by industry
Order by AVG(percentage_laid_off) DESC
;employees

-- Companies with the most layoffs broken up by industry --

Select DISTINCT company, industry, SUM(total_laid_off) OVER(PARTITION BY industry,company) AS layoffs 
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
Order by industry, layoffs DESC
;

-- Industries with the most layoffs broken up by country -- 

Select DISTINCT country, industry, SUM(total_laid_off) OVER(PARTITION BY Country,Industry) AS layoffs 
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
Order by Country, layoffs DESC
;

-- Industries with the most layoffs broken up by city (US Based) -- 

Select DISTINCT location AS City, industry, SUM(total_laid_off) OVER(PARTITION BY location,Industry) AS layoffs 
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
AND Country = 'United States'
Order by City, layoffs DESC
;

-- Industries with the most layoffs within SF and NYC-- 

Select DISTINCT location AS City, industry, SUM(total_laid_off) OVER(PARTITION BY location,Industry) AS layoffs 
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
AND Location IN ('New York City', 'SF Bay Area')
Order by layoffs DESC
;

 -- Companies with the most layoffs in each City --
 
 Select DISTINCT Location AS city,Company, industry, SUM(total_laid_off) OVER(PARTITION BY company,Industry) AS layoffs 
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
AND Country = 'United States'
Order by location, layoffs DESC;

-- Just NYC and SF -- 

 Select DISTINCT Location AS city,Company, industry, SUM(total_laid_off) OVER(PARTITION BY company,Industry) AS layoffs 
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
AND Location IN ('New York City', 'SF Bay Area')
Order by location, layoffs DESC;

-- layoffs by year --

Select YEAR(`date`), SUM(total_laid_off)
From layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
Group by YEAR(`date`)
ORDER BY YEAR(`date`)
;

--  Months with the most layoffs   --

Select MONTH(`date`), YEAR(`date`), SUM(total_laid_off)
From layoffs_staging2
GROUP BY MONTH(`date`), YEAR(`date`)
ORDER BY SUM(total_laid_off) DESC
;

Select MONTH(`date`), YEAR(`date`), SUM(total_laid_off)
From layoffs_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY MONTH(`date`), YEAR(`date`)
ORDER BY MONTH(`date`), YEAR(`date`)
;

-- Months with the most layoffs by industry --

Select  DISTINCT industry,MONTH(`date`), YEAR(`date`), SUM(total_laid_off) OVER(PARTITION BY industry, MONTH(`date`), YEAR(`date`)) AS total_layoffs
From layoffs_staging2
WHERE industry IS NOT NULL AND total_laid_off IS NOT NULL
ORDER BY total_layoffs DESC
;

-- Months with the most layoffs by Company -- 

Select  DISTINCT company,MONTH(`date`), YEAR(`date`), SUM(total_laid_off) OVER(PARTITION BY company, MONTH(`date`), YEAR(`date`)) AS total_layoffs
From layoffs_staging2
WHERE Company IS NOT NULL AND total_laid_off IS NOT NULL
ORDER BY total_layoffs DESC
;

-- months with the most layoffs by location -- 

Select  DISTINCT location,MONTH(`date`), YEAR(`date`), SUM(total_laid_off) OVER(PARTITION BY location, MONTH(`date`), YEAR(`date`)) AS total_layoffs
From layoffs_staging2
WHERE location IS NOT NULL AND total_laid_off IS NOT NULL
ORDER BY total_layoffs DESC
;