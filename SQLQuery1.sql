--select *
--from CovidVaccinations
--where continent is not null
--order by 3,4

-- Looking at Total Cases vs Total Deaths
-- Likelihood of death from covid

SELECT location, date, total_cases, new_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Looking at total Cases vs Population

SELECT location, date, total_cases, total_deaths, population , (total_cases/population)*100 as InfectedPercentage
from PortfolioProject..CovidDeaths
where continent like 'Africa'
order by 1,2

-- Looking at countries with highest infection rate 

SELECT location, population , MAX(total_cases) as HighestInfectionCount, Max(total_cases/population)*100 as InfectedPercentage
from PortfolioProject..CovidDeaths
where continent is not null
Group by location, population
order by 4 desc

-- Countries with highest Deaths per Population

SELECT location, MAX(cast(total_deaths as int)) as TotalDeaths 
from PortfolioProject..CovidDeaths
where continent is not null
Group by location
order by 2 desc

--Checking in continents and whole would

SELECT continent, MAX(cast(total_deaths as int)) as TotalDeaths 
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by 2 desc


SELECT location, MAX(cast(total_deaths as int)) as TotalDeaths 
from PortfolioProject..CovidDeaths
where continent is null
Group by location
order by 2 desc


--showing the continent showing the death coutnt 

select continent, total_deaths 
from CovidDeaths
where continent like 'Africa'


--Global numbers

select SUM(new_cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths
, Sum(cast(new_deaths as int))/ SUM(new_cases) * 100 as DeathPercentage
from CovidDeaths
where continent is not null
--Group by date
order by 1,2


-- total population vs vaccinations

--SELECT *
--FROM CovidDeaths dea
--JOIN CovidVaccinations vac
--on dea.location = vac.location
--and dea.date = vac.date


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location order by dea.location,
dea.Date) as RollingPeopleVaccinated
FROM CovidDeaths dea
JOIN CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
) select *, (RollingPeopleVaccinated/Population)*100 
from PopvsVac