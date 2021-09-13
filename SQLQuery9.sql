select * 
from ranking_gaps
order by Gaps

select * 
from ranking_update_dates

select * 
from federer_ranking

select * into prev 
from (
	select * 
	from ranking_update_dates a
	left outer join federer_ranking b
	on (a.DATE = b.rank_date)
	order by a.DATE
) c

select * from prev
order by DATE


