select substring(`date`,1,7) AS `Month`, sum(total_laid_off)
from layoffs_staging2
Where substring(`date`,1,7) IS NOT NULL
group by `Month`
order by 1;

With Rolling_total AS
(
select substring(`date`,1,7) AS `Month`, sum(total_laid_off) As total_off
from layoffs_staging2
Where substring(`date`,1,7) IS NOT NULL
group by `Month`
order by 1
)
Select `Month`, total_off, sum(total_off) Over(order by `Month`) AS rolling_total
From Rolling_total;

select company, YEAR(`date`), sum(total_laid_off)
From layoffs_staging2
group by company, YEAR(`date`)
order by company;


WITH Company_year ( Company, years, total_laid_off) AS
(
select company, YEAR(`date`), sum(total_laid_off)
From layoffs_staging2
group by company, YEAR(`date`)
order by company
), Company_year_rank AS 
(Select *, dense_rank() over ( partition by years order by total_laid_off DESC) AS Ranking
From company_year
where years IS NOT NULL)

select *
From Company_year_rank
Where Ranking <= 5;
