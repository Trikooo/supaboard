-- Alter projects table
ALTER TABLE projects
RENAME COLUMN created_by TO creator_id;

-- Alter issues table
ALTER TABLE issues
RENAME COLUMN created_by TO creator_id;

ALTER TABLE issues
RENAME COLUMN assigned_to TO assignee_id;
