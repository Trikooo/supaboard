-- Enable RLS
ALTER TABLE public.workspaces ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.team_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.projects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.issues ENABLE ROW LEVEL SECURITY;

-- ===================================
-- RLS POLICIES
-- ===================================

-- Workspaces: users can only see workspaces they own, or are members of
CREATE POLICY "Users can view their workspaces"
ON public.workspaces FOR SELECT
USING (
  owner_id = auth.uid()
  OR id IN (
    SELECT DISTINCT w.id
    FROM workspaces w
    JOIN teams t ON t.workspace_id = w.id
    JOIN team_members tm ON tm.team_id = t.id
    WHERE tm.user_id = auth.uid()
  )
);

CREATE POLICY "Users can create workspaces"
ON public.workspaces FOR INSERT
WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Owners can update their workspaces"
ON public.workspaces FOR UPDATE
USING (owner_id = auth.uid());

CREATE POLICY "Owners can delete their workspaces"
ON public.workspaces FOR DELETE
USING (owner_id = auth.uid());

-- Teams: Users can see teams in workspaces they belong to
CREATE POLICY "Users can view teams they belong to"
ON public.teams FOR SELECT
USING (
  workspace_id IN (
    SELECT id FROM workspaces WHERE owner_id = auth.uid()
  )
  OR id IN (
    SELECT team_id FROM team_members WHERE user_id = auth.uid()
  )
);

CREATE POLICY "Workspace owners can create teams"
ON public.teams FOR INSERT
WITH CHECK (
  workspace_id IN (
    SELECT id FROM workspaces WHERE owner_id = auth.uid()  -- Fixed workspace to workspaces, auth.id() to auth.uid()
  )
);

CREATE POLICY "Workspace owners and admins can update teams"
ON public.teams FOR UPDATE
USING (
  workspace_id IN (
    SELECT id FROM workspaces WHERE owner_id = auth.uid()
  )
  OR id IN (
    SELECT team_id FROM team_members
    WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
  )
);

CREATE POLICY "Workspace owners can delete teams"
ON public.teams FOR DELETE
USING (  -- Changed WITH CHECK to USING for DELETE
  workspace_id IN (
    SELECT id FROM workspaces WHERE owner_id = auth.uid()
  )
);

-- Team members: can see members of teams they belong to
CREATE POLICY "Users can view their team members"
ON public.team_members FOR SELECT
USING (
  team_id IN (
    SELECT team_id FROM team_members WHERE user_id = auth.uid()
  )
  OR team_id IN (
    SELECT t.id FROM teams t
    JOIN workspaces w ON w.id = t.workspace_id
    WHERE w.owner_id = auth.uid()
  )
);

CREATE POLICY "Admins and owners can add team members"
ON public.team_members FOR INSERT
WITH CHECK (
  team_id IN (
    SELECT team_id FROM team_members
    WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
  )
  OR team_id IN (
    SELECT t.id FROM teams t
    JOIN workspaces w ON w.id = t.workspace_id
    WHERE w.owner_id = auth.uid()
  )
);

CREATE POLICY "Admins and owners can remove team members"
ON public.team_members FOR DELETE
USING (
  team_id IN (
    SELECT team_id FROM team_members
    WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
  )
  OR team_id IN (
    SELECT t.id FROM teams t  -- Fixed team to teams
    JOIN workspaces w ON w.id = t.workspace_id
    WHERE w.owner_id = auth.uid()
  )
);

-- Projects: teams can see projects
CREATE POLICY "team members can view projects"
ON public.projects FOR SELECT
USING (
  team_id IN (
    SELECT team_id FROM team_members WHERE user_id = auth.uid()
  )
);

CREATE POLICY "Team members can create projects"
ON public.projects FOR INSERT
WITH CHECK (
  team_id IN (
    SELECT team_id FROM team_members WHERE user_id = auth.uid()
  )
);

CREATE POLICY "Team members can update projects"
ON public.projects FOR UPDATE
USING (
  team_id IN (
    SELECT team_id FROM team_members WHERE user_id = auth.uid()
  )
);

CREATE POLICY "Team admins can delete projects"
ON public.projects FOR DELETE
USING (
  team_id IN (
    SELECT team_id FROM team_members
    WHERE user_id = auth.uid() AND role IN ('owner', 'admin')
  )
);

-- Issues: Team members can see and manage issues
CREATE POLICY "Team members can view issues"
ON public.issues FOR SELECT
USING (
  project_id IN (
    SELECT p.id FROM projects p
    JOIN team_members tm ON tm.team_id = p.team_id
    WHERE tm.user_id = auth.uid()
  )
);

CREATE POLICY "Team members can create issues"
ON public.issues FOR INSERT
WITH CHECK (
  project_id IN (
    SELECT p.id FROM projects p
    JOIN team_members tm ON tm.team_id = p.team_id
    WHERE tm.user_id = auth.uid()
  )
);

CREATE POLICY "Team members can update issues"
ON public.issues FOR UPDATE
USING (
  project_id IN (
    SELECT p.id FROM projects p
    JOIN team_members tm ON tm.team_id = p.team_id
    WHERE tm.user_id = auth.uid()
  )
);

CREATE POLICY "Team members can delete issues"
ON public.issues FOR DELETE
USING (
  project_id IN (
    SELECT p.id FROM projects p
    JOIN team_members tm ON tm.team_id = p.team_id
    WHERE tm.user_id = auth.uid()
  )
);
