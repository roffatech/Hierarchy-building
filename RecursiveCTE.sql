-- this will build a project lineage


DROP TABLE IF EXISTS recursive_cte_copy
GO

WITH recursive_cte AS
(
	SELECT 
		PROJECT_ID,
		PROJECT_DESC, 
		CAST(NULL AS varchar(20)) AS ANCESTOR,
		0 AS HIER_LEVEL,
		CAST(projects.PROJECT_ID AS varchar(MAX)) AS LINEAGE
	FROM 
		projects
	WHERE
		PARENT_PROJECT IS NULL

	UNION ALL 

	SELECT 
		projects.PROJECT_ID,
		projects.PROJECT_DESC, 
		PARENT_PROJECT AS ANCESTOR,
		HIER_LEVEL + 1,
		recursive_cte.LINEAGE + ' > ' + projects.PROJECT_ID
	FROM 
		PROJECTS
	INNER JOIN 
		recursive_cte 
	ON 
		recursive_cte.PROJECT_ID = projects.PARENT_PROJECT
)
-- run this statement immediately after the WITH/UNION ALL or recursive_cte goes out of scope
-- use the INTO clause to save its contents to a table that won't go out of scope immediately
SELECT
	PROJECT_ID,
	PROJECT_DESC, 
	ANCESTOR,
	HIER_LEVEL,
	LINEAGE
INTO 
	recursive_cte_copy
FROM 
	recursive_cte



-- The following statement would cause an error if not commented out, 
-- because recursive_cte is now out of scope

-- SELECT * FROM recursive_cte


-- This is why we had an INTO clause above
SELECT * FROM recursive_cte_copy