-------------------
--------1----------
-------------------

---Populate tables for countries ranks---

DROP TABLE IF EXISTS nation.countryRank;

CREATE TABLE nation.countryRank AS
SELECT 
RANK() OVER (PARTITION BY continent, region
			 order by area desc
			 ) rank,
cnt.name as continent, 
reg.name as region, 
cntr.name, 
cntr.area, 
cntr.country_code3, 
(case 
	when cntr.national_day is null then 'no data'
	when cntr.national_day > CURDATE() then CURDATE()
	else cntr.national_day
end) as nday
FROM nation.countries cntr
join nation.regions reg on cntr.region_id = reg.region_id 
join nation.continents cnt on reg.continent_id = cnt.continent_id 
group by cnt.name, reg.name, cntr.name, cntr.area, cntr.country_code3
order by continent, region, area desc

---Select all fron populated table---

select * from nation.countryRank

---Check that there are no duplicates in the table---

select continent,region,name,area,country_code3,nday,count(*) from nation.countryRank
group by continent,region,name,area,country_code3,nday 
having count(*)>1

-------------------
--------2----------
-------------------

--Answer the question – what can be done on a database level to avoid problems with duplicates and Null values?
--To avoid problems with duplicates a unique key can be used (e.g. a set of fields like continent, region, name, area, nday and country_code3, which were used in GROUP BY clause above). 
--To avoid problems with nulls NOT_NULL column type can be used.