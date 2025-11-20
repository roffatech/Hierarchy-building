-- when we ran the import wizard, this put data from an Excel file into a staging table
-- xlsx_projects. Most of the data in xlsx_projects is OK, but we have to format the 
-- dates for project start and end date into varchar(8) columns, because Excel may
-- have formatted the date columns on its own as integers

INSERT INTO projects
SELECT
	PROJECT_ID,
	PROJECT_DESC,
	CONVERT(varchar(8),CONVERT(int, PROJECT_START_DT)),
	CONVERT(varchar(8),CONVERT(int, PROJECT_END_DT)),
	PROJECT_ACTIVE, 
	PROJECT_END_REASON, 
	PARENT_PROJECT
FROM
	xlsx_projects


-- at this point our project hierearchy is like an oligarchy: we have multiple top-level projects, 
-- but the recursive cte lineage seems to work better if it is a monarchy with one top level project, 
-- so we will add such a project, even if it's only a placeholder

-- add the anchor row
INSERT INTO projects
(
	PROJECT_ID,
	PROJECT_DESC,
	PROJECT_START_DT,
	PROJECT_END_DT,
	PROJECT_ACTIVE,
	PROJECT_END_REASON,
	PARENT_PROJECT
)
SELECT
	'ANCH200001-001',
	'Anchor Project',
	'20000101',
	NULL,
	1,
	NULL,
	NULL

-- changing the parent project values so the "oligarch" projects are subordinate to the 
-- "king" project
UPDATE projects
SET
	PARENT_PROJECT = 'ANCH200001-001'
WHERE
	PARENT_PROJECT IS NULL AND			-- applies only to "oligarchs"
	PROJECT_ID <> 'ANCH200001-001'