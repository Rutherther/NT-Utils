-- remove monsters with same VNum that are on the same location
-- this won't remove all the dupes, because the monsters could have moved since the last map entry

CREATE TABLE ##monster_dupes(MapMonsterId INT);

WITH cte AS (
SELECT MapMonsterId, ROW_NUMBER() OVER ( PARTITION BY MonsterVNum, MapId, MapX, MapY ORDER BY MonsterVNum) AS row_num FROM MapMonster
)
INSERT INTO ##monster_dupes SELECT MapMonsterId FROM cte WHERE row_num > 1;

DELETE mm FROM MapMonster mm
	INNER JOIN ##monster_dupes md ON mm.MapMonsterId = md.MapMonsterId;

DROP TABLE ##monster_dupes;