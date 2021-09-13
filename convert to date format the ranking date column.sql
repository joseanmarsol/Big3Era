ALTER TABLE atp_rankings ADD rank_date DATE;

UPDATE atp_rankings SET rank_date=TRY_CONVERT(DATE,ranking_date,102);

ALTER TABLE atp_rankings DROP COLUMN ranking_date;
