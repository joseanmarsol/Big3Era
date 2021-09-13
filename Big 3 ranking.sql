-- Big 3 ranking

select * into big3_ranking from (
select * from atp_rankings i
inner join (select * from atp_players
where (first_name = 'Roger' and last_name = 'Federer')
	or (first_name = 'Rafael' and last_name = 'Nadal')
	or (first_name = 'Novak' and last_name = 'Djokovic')) j
on i.player = j.id
) a

------------------------------------------------------------------
-- Another option to query the same

select * from atp_rankings i
inner join atp_players j
on i.player = j.id
where (first_name = 'Roger' and last_name = 'Federer')
	or (first_name = 'Rafael' and last_name = 'Nadal')
	or (first_name = 'Novak' and last_name = 'Djokovic')
------------------------------------------------------------------

-- Federer ranking

select * into federer_ranking from (
select * from atp_rankings i
inner join (select * from atp_players
			where (first_name = 'Roger' and last_name = 'Federer')) j
on i.player = j.id
) a

-- Nadal ranking

select * into nadal_ranking from (
select * from atp_rankings i
inner join (select * from atp_players
			where (first_name = 'Rafael' and last_name = 'Nadal')) j
on i.player = j.id
) a

-- Djokovic ranking

select * into djokovic_ranking from (
select * from atp_rankings i
inner join (select * from atp_players
			where (first_name = 'Novak' and last_name = 'Djokovic')) j
on i.player = j.id
) a