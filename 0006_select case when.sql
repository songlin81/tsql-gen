CASE WHEN condition THEN result
[WHEN ...]
[ELSE result]
END

例子：
SELECT * FROM test;

a
---
1
2
3

SELECT
    a,
    CASE    WHEN a=1 THEN 'one'
            WHEN a=2 THEN 'two'
            ELSE 'other'
    END
FROM test;

a | case
---+-------
1 | one
2 | two
3 | other
