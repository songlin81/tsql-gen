-- group by to eliminate duplicates from name,
-- but still show other columns like id

SELECT id,name 
FROM t1
WHERE id IN (
    SELECT MAX(id) 
    FROM t1 
    GROUP BY name
) order by id desc
