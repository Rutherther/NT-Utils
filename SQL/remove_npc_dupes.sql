-- remove all npcs with same VNum that are on the same location

CREATE TABLE ##npc_dupes(MapNpcId INT);

WITH cte AS (
SELECT MapNpcId, ROW_NUMBER() OVER ( PARTITION BY NpcVNum, MapId, MapX, MapY ORDER BY NpcVNum ) AS row_num FROM MapNpc
)
INSERT INTO ##npc_dupes SELECT MapNpcId FROM cte WHERE row_num > 1;

DELETE rl FROM RecipeList rl
	INNER JOIN ##npc_dupes d ON rl.MapNpcId = d.MapNpcId;

DELETE si FROM ShopItem si
	INNER JOIN Shop s ON s.ShopId = si.ShopId
	INNER JOIN ##npc_dupes d ON s.MapNpcId = d.MapNpcId;

DELETE t FROM Teleporter t
	INNER JOIN ##npc_dupes d ON d.MapNpcId = t.MapNpcId;
	
DELETE s FROM Shop s
	INNER JOIN ##npc_dupes d ON s.MapNpcId = d.MapNpcId;

DELETE mn FROM MapNpc mn
	INNER JOIN ##npc_dupes d ON mn.MapNpcId = d.MapNpcId;

DROP TABLE ##npc_dupes;