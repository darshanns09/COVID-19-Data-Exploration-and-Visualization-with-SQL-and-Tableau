
-- *** Covid 19 Data Exploration ***


select *
from Practicesql..CovidDeaths$
where continent is not null
order by 3,4



-- Selected Data

Select Location, date, total_cases, new_cases, total_deaths, population
from Practicesql..CovidDeaths$
where continent is not null
order by date 



-- Total Cases vs Total Deaths

Select Location, date, total_cases,total_deaths,round((total_deaths/total_cases)*100,2) as deathspercentage
from Practicesql..CovidDeaths$
where continent is not null
and location like '%india%'
order by 1,2



-- Total Cases vs Population percentage infected  Table -4

Select Location,population, date, total_cases,round((total_cases/population)*100,2) as populationinfected
from Practicesql..CovidDeaths$
--where continent is not null
--where location like '%india%'
order by populationinfected desc



-- Countries with Highest Infection Table -3

Select Location,population, max(total_cases) as highinfection,round(max(total_cases/population)*100,2) as populationinfected
from Practicesql..CovidDeaths$
-- where continent is not null
--where location like '%india%'
group by location ,population
order by populationinfected desc



-- Countries with Highest Death Count

Select Location, sum(cast(total_deaths as int )) as hightotaldeaths
from Practicesql..CovidDeaths$
where continent is not null
--where location like '%india%'
group by location
order by hightotaldeaths desc



-- Showing contintents with the highest death count  Table -2


Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
from Practicesql..CovidDeaths$
--Where location like '%india%'
Where continent is null 
and location not in ('World', 'European Union', 'International')
Group by location
order by TotalDeathCount desc



-- Global number of DeathPercentage Table -1


Select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from Practicesql..CovidDeaths$
where continent is not null
--where location like '%india%'
--group by date
order by 1,2



-- Shows Percentage of Population received vacinations


Select deth.continent, deth.location, deth.date,deth.population,vacc.new_vaccinations,
sum(convert(int,vacc.new_vaccinations)) over(partition by deth.location order by deth.location,deth.date) as Rollingpeoplevaccinated
from Practicesql..CovidDeaths$ as deth
join Practicesql..CovidVaccinations$ as vacc
on deth.location = vacc.location and deth.date = vacc.date
where deth.continent is not null
order by 2,3



-- Using CTE - with


 with popvsvac as
 (
 Select deth.continent, deth.location, deth.date,deth.population,vacc.new_vaccinations,
sum(convert(int,vacc.new_vaccinations)) over(partition by deth.location order by deth.location,deth.date) as Rollingpeoplevaccinated
from Practicesql..CovidDeaths$ as deth
join Practicesql..CovidVaccinations$ as vacc
on deth.location = vacc.location and deth.date = vacc.date
where deth.continent is not null
-- order by 2,3
)
select *,(Rollingpeoplevaccinated/population)*100
FROM popvsvac



-- Using Temp Table


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
peoplevaccinated numeric
)

insert into #PercentPopulationVaccinated
 Select deth.continent, deth.location, deth.date,deth.population,vacc.new_vaccinations,
sum(convert(int,vacc.new_vaccinations)) over(partition by deth.location order by deth.location,deth.date) as peoplevaccinated
from Practicesql..CovidDeaths$ as deth
join Practicesql..CovidVaccinations$ as vacc
on deth.location = vacc.location and deth.date = vacc.date
-- where deth.continent is not null
-- order by 2,3

select *,(peoplevaccinated/population)*100
FROM #PercentPopulationVaccinated



-- Creating View to store data for later visualizations


create view PercentPopulationVaccinated as
 Select deth.continent, deth.location, deth.date,deth.population,vacc.new_vaccinations,
sum(convert(int,vacc.new_vaccinations)) over(partition by deth.location order by deth.location,deth.date) as peoplevaccinated
from Practicesql..CovidDeaths$ as deth
join Practicesql..CovidVaccinations$ as vacc
on deth.location = vacc.location and deth.date = vacc.date
where deth.continent is not null


select *
FROM PercentPopulationVaccinated


--Table 1,2,3,4 is used for Tableau Visualization

------------------------------------------------------------------------------
