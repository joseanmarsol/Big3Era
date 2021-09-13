SELECT *
  INTO  [dbo].[atp_rankings]
FROM
(
        SELECT     *
    FROM         atp_rankings_90s
    UNION
    SELECT     *
    FROM         atp_rankings_00s
    UNION
    SELECT     *
    FROM         atp_rankings_10s
    UNION
    SELECT     *
    FROM         atp_rankings_20s
    UNION
    SELECT     *
    FROM         atp_rankings_current
) a