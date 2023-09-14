select *
from PortfolioProject..nbaplayers
order by season;

select *
from PortfolioProject..nbaplayers
where pts > 20 and ts_pct > 0.6 and usg_pct > 0.25
and player_name like '%james%'
order by season;

-- looking at LeBron's best seasons

select player_name, team_abbreviation, age, gp, pts, reb, ast, net_rating, oreb_pct, dreb_pct, usg_pct, ts_pct, ast_pct, season
from PortfolioProject..nbaplayers
where player_name like '%lebron%' or player_name like '%kobe%'
order by net_rating desc;

-- looking at two of this generation's best players' best seasons. 


select distinct player_name, team_abbreviation, age, college, country, draft_year, draft_round, draft_number, gp, pts, reb, ast, net_rating, usg_pct, ts_pct, ast_pct, season
from PortfolioProject..nbaplayers
order by pts desc

select college, count(*) as players_drafted
from PortfolioProject..nbaplayers
group by college
order by players_drafted desc;

-- looking at which college has sent the most players to the NBA

with PlayerRanked as (
    select player_name, team_abbreviation, age, college, country, draft_year, draft_round, draft_number, gp, pts, reb, ast, net_rating, usg_pct, ts_pct, ast_pct, season,
    row_number() over (partition by player_name order by pts desc) as SeasonRank
    from PortfolioProject..nbaplayers
    where country != 'USA' AND try_cast(substring(season, 1, 4) as int) < 2010
)

select player_name, team_abbreviation, age, college, country, draft_year, draft_round, draft_number, gp, pts, reb, ast, net_rating, usg_pct, ts_pct, ast_pct,season
from PlayerRanked
where SeasonRank = 1
order by pts desc;

-- looking at highest pts season for international players before 2010

with PlayerRanked as (
    select player_name, team_abbreviation, age, college, country, draft_year, draft_round, draft_number, gp, pts, reb, ast, net_rating, usg_pct, ts_pct, ast_pct, season,
    row_number() over (partition by player_name order by pts desc) as SeasonRank
    from PortfolioProject..nbaplayers
    where country != 'USA' AND try_cast(substring(season, 1, 4) as int) > 2010
)

select player_name, team_abbreviation, age, college, country, draft_year, draft_round, draft_number, gp, pts, reb, ast, net_rating, usg_pct, ts_pct, ast_pct,season
from PlayerRanked
where SeasonRank = 1
order by pts desc;

-- looking at highest pts season for international players after 2010

with HighestScorers as (
select season, max(cast(pts as decimal(10,2))) as max_points
from PortfolioProject..nbaplayers
group by season
)
select p.season, p.player_name, cast(p.pts as decimal(10,2)) as max_points
from PortfolioProject..nbaplayers as p
join HighestScorers as hs on p.season = hs.season
and cast(p.pts as decimal(10,2)) = hs.max_points
order by p.season;

-- looking at highest scorers by seasons


select college, count(distinct player_name) as number_of_number_1_picks
from PortfolioProject..nbaplayers
where draft_number = 1
group by college
order by number_of_number_1_picks desc;

-- looking at which school produced the most #1 draft picks

select top 10 player_name, pts
FROM PortfolioProject..nbaplayers
where season = '2021-22'
order by pts desc;

-- looking at the top 10 scorers from the 2021-22 season

