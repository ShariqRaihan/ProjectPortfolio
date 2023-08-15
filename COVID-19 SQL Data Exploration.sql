--display both tables

select *
from dbo.CovidDeaths$
order by 3, 4

select *
from dbo.CovidVaccinations$
order by 3, 4



--data to be used for CovidDeaths table

select Location, date, total_cases, new_cases, total_deaths, new_deaths, population
from [dbo].[CovidDeaths$]
order by 1,2



--total cases and total deaths per country

select Location AS Country, sum(cast(new_cases as int)) as 'Total Cases', sum(cast(new_deaths as int)) as 'Total Deaths'
from dbo.CovidDeaths$
Where continent is not Null
group by location
order by [Total Cases] desc



--total cases and deaths per continent

select continent AS Continent, sum(cast(new_cases as int)) as 'Total Cases', sum(cast(new_deaths as int)) as 'Total Deaths'
from dbo.CovidDeaths$
Where continent is not Null
group by continent
order by [Total Cases] desc



--total cases vs population to find percent of infected

select location as Country, sum(cast(new_cases as int)) as 'Total Cases', max(population) as Population, sum(cast(new_cases as int))/max(population)*100 as 'Percent Infected'
from dbo.CovidDeaths$
where continent is not null
group by location
order by [Percent Infected] desc



--percentage of death from infected per country

select location as Country, max(population) as Population, sum(cast(new_cases as int)) as 'Total Cases', sum(cast(new_deaths as int)) as 'Total Deaths', sum(cast(new_deaths as float))/sum(cast(new_cases as float))*100 as 'Percent Dead of Infected'
from dbo.CovidDeaths$
where continent is not null
group by location
order by [Percent Dead of Infected] desc



--join deaths table and vaccination table

select * from [Portfolio Project]..	CovidDeaths$ dea join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null
	order by 3, 4



--total cases vs total vaccinated

select dea.location as Country, max(dea.population) as Population, max(dea.total_cases) as 'Total Cases', max(cast(vac.total_vaccinations as int)) as 'Total Vaccinations' 
from [Portfolio Project]..	CovidDeaths$ dea join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null
	group by dea.location
	order by [Total Vaccinations] desc



--percentage of population vaccinated atleast once

select dea.location as Country, max(dea.population) as Population, max(cast(vac.people_vaccinated as int)) as 'People Vaccinated', max(cast(vac.people_vaccinated as int))/max(dea.population) * 100 as 'Percentage of Population Vaccinated'
from [Portfolio Project]..	CovidDeaths$ dea join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null and dea.location not in ('Gibraltar')
	group by dea.location
	order by [Percentage of Population Vaccinated] desc



--percentage of population fully vaccinated

select dea.location as Country, max(dea.population) as Population, max(cast(vac.people_fully_vaccinated as int)) as 'People Fully Vaccinations', max(cast(vac.people_fully_vaccinated as int))/max(dea.population) * 100 as 'Percentage of Fully Population Vaccinated'
from [Portfolio Project]..	CovidDeaths$ dea join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null and dea.location not in ('Gibraltar')
	group by dea.location
	order by [Percentage of Fully Population Vaccinated] desc



--total vaccinations per continent

select dea.continent as Continent, sum(cast(vac.total_vaccinations as bigint)) as 'Total Vaccinations'
from [Portfolio Project]..	CovidDeaths$ dea join [Portfolio Project]..CovidVaccinations$ vac
	on dea.location = vac.location and dea.date = vac.date
	where dea.continent is not null
	group by dea.continent
	order by [Total Vaccinations] desc