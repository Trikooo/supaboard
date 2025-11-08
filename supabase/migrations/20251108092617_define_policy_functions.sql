-- 1. Check workspace access: users can see workspaces they belong to
CREATE OR REPLACE FUNCTION public.can_access_workspace(workspace_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM workspaces w
    WHERE w.id = workspace_id
      AND w.owner_id = (SELECT auth.uid())
  )
  OR EXISTS (
    SELECT 1
    FROM teams t
    JOIN team_members tm ON tm.team_id = t.id
    WHERE t.workspace_id = workspace_id
      AND tm.user_id = (SELECT auth.uid())
  );
$$;

-- 2. Check teams access: users can see teams they belong to or in workspaces they own
CREATE OR REPLACE FUNCTION public.can_access_teams(team_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS(
    SELECT 1
    FROM teams t
    INNER JOIN workspaces w ON w.id = t.workspace_id
    WHERE t.id = team_id
      AND w.owner_id = (SELECT auth.uid())
  )
  OR EXISTS(
    SELECT 1
    FROM team_members tm
    WHERE tm.team_id = team_id
      AND tm.user_id = (SELECT auth.uid())
  );
$$;

-- 3. team creation access: Workspace owners can create teams
CREATE OR REPLACE FUNCTION public.can_create_team(workspace_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM workspaces w
    WHERE w.id = workspace_id
      AND w.owner_id = (SELECT auth.uid())
  );
$$;

-- 4. Check team update access: users can update teams if they are workspace owners or team owners/admins
CREATE OR REPLACE FUNCTION public.can_update_team(team_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM teams t
    INNER JOIN workspaces w ON w.id = t.workspace_id
    WHERE t.id = team_id
      AND w.owner_id = (SELECT auth.uid())
  )
  OR EXISTS (
    SELECT 1
    FROM team_members tm
    WHERE tm.team_id = team_id
      AND tm.user_id = (SELECT auth.uid())
      AND tm.role IN ('owner', 'admin')
  );
$$;

-- 5. Check team delete access: users can delete teams if they are workspace owners
CREATE OR REPLACE FUNCTION public.can_delete_team(team_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM teams t
    INNER JOIN workspaces w ON w.id = t.workspace_id
    WHERE t.id = team_id
      AND w.owner_id = (SELECT auth.uid())
  );
$$;

-- 6. Check team members access: users can view members of teams they belong to or in workspaces they own
CREATE OR REPLACE FUNCTION public.can_view_team_members(team_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM teams t
    INNER JOIN workspaces w ON w.id = t.workspace_id
    WHERE t.id = team_id
      AND w.owner_id = (SELECT auth.uid())
  )
  OR EXISTS (
    SELECT 1
    FROM team_members tm
    WHERE tm.team_id = team_id
      AND tm.user_id = (SELECT auth.uid())
  );
$$;

-- 7. Check team members insert access: users can add members if they are team owners/admins or workspace owners
CREATE OR REPLACE FUNCTION public.can_add_team_member(team_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM teams t
    INNER JOIN workspaces w ON w.id = t.workspace_id
    WHERE t.id = team_id
      AND w.owner_id = (SELECT auth.uid())
  )
  OR EXISTS (
    SELECT 1
    FROM team_members tm
    WHERE tm.team_id = team_id
      AND tm.user_id = (SELECT auth.uid())
      AND tm.role IN ('owner', 'admin')
  );
$$;

-- 8. Check team members update access: users can update members if they are team owners/admins or workspace owners
CREATE OR REPLACE FUNCTION public.can_update_team_member(team_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM teams t
    INNER JOIN workspaces w ON w.id = t.workspace_id
    WHERE t.id = team_id
      AND w.owner_id = (SELECT auth.uid())
  )
  OR EXISTS (
    SELECT 1
    FROM team_members tm
    WHERE tm.team_id = team_id
      AND tm.user_id = (SELECT auth.uid())
      AND tm.role IN ('owner', 'admin')
  );
$$;

-- 9. Check team members delete access: users can remove members if they are team owners/admins or workspace owners
CREATE OR REPLACE FUNCTION public.can_remove_team_member(team_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM teams t
    INNER JOIN workspaces w ON w.id = t.workspace_id
    WHERE t.id = team_id
      AND w.owner_id = (SELECT auth.uid())
  )
  OR EXISTS (
    SELECT 1
    FROM team_members tm
    WHERE tm.team_id = team_id
      AND tm.user_id = (SELECT auth.uid())
      AND tm.role IN ('owner', 'admin')
  );
$$;

-- 10. Check project access: users can view projects if they belong to the team
CREATE OR REPLACE FUNCTION public.can_view_project(project_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM projects p
    INNER JOIN team_members tm ON tm.team_id = p.team_id
    WHERE p.id = project_id
      AND tm.user_id = (SELECT auth.uid())
  );
$$;

-- 11. Check project insert access: users can create projects if they belong to the team
CREATE OR REPLACE FUNCTION public.can_create_project(team_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM team_members tm
    WHERE tm.team_id = team_id
      AND tm.user_id = (SELECT auth.uid())
  );
$$;

-- 12. Check project update access: users can update projects if they are the creator or a team owner/admin
CREATE OR REPLACE FUNCTION public.can_update_project(project_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM projects p
    WHERE p.id = project_id
      AND p.creator_id = (SELECT auth.uid())
  )
  OR EXISTS (
    SELECT 1
    FROM projects p
    INNER JOIN team_members tm ON tm.team_id = p.team_id
    WHERE p.id = project_id
      AND tm.user_id = (SELECT auth.uid())
      AND tm.role IN ('owner', 'admin')
  );
$$;

-- 13. Check project delete access: users can delete projects if they are the creator or a team owner/admin
CREATE OR REPLACE FUNCTION public.can_delete_project(project_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM projects p
    WHERE p.id = project_id
      AND p.creator_id = (SELECT auth.uid())
  )
  OR EXISTS (
    SELECT 1
    FROM projects p
    INNER JOIN team_members tm ON tm.team_id = p.team_id
    WHERE p.id = project_id
      AND tm.user_id = (SELECT auth.uid())
      AND tm.role IN ('owner', 'admin')
  );
$$;

-- 14. Check issue access: users can view issues if they belong to the team of the project
CREATE OR REPLACE FUNCTION public.can_view_issue(issue_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM issues i
    INNER JOIN projects p ON p.id = i.project_id
    INNER JOIN team_members tm ON tm.team_id = p.team_id
    WHERE i.id = issue_id
      AND tm.user_id = (SELECT auth.uid())
  );
$$;

-- 15. Check issue insert access: users can create issues if they belong to the team of the project
CREATE OR REPLACE FUNCTION public.can_create_issue(project_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM projects p
    INNER JOIN team_members tm ON tm.team_id = p.team_id
    WHERE p.id = project_id
      AND tm.user_id = (SELECT auth.uid())
  );
$$;

-- 16. Check issue update access: users can update issues if they are the creator or a team owner/admin
CREATE OR REPLACE FUNCTION public.can_update_issue(issue_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM issues i
    WHERE i.id = issue_id
      AND i.creator_id = (SELECT auth.uid())
  )
  OR EXISTS (
    SELECT 1
    FROM issues i
    INNER JOIN projects p ON p.id = i.project_id
    INNER JOIN team_members tm ON tm.team_id = p.team_id
    WHERE i.id = issue_id
      AND tm.user_id = (SELECT auth.uid())
      AND tm.role IN ('owner', 'admin')
  );
$$;

-- 17. Check issue delete access: users can delete issues if they are the creator or a team owner/admin
CREATE OR REPLACE FUNCTION public.can_delete_issue(issue_id uuid)
RETURNS boolean
LANGUAGE sql
SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM issues i
    WHERE i.id = issue_id
      AND i.creator_id = (SELECT auth.uid())
  )
  OR EXISTS (
    SELECT 1
    FROM issues i
    INNER JOIN projects p ON p.id = i.project_id
    INNER JOIN team_members tm ON tm.team_id = p.team_id
    WHERE i.id = issue_id
      AND tm.user_id = (SELECT auth.uid())
      AND tm.role IN ('owner', 'admin')
  );
$$;
