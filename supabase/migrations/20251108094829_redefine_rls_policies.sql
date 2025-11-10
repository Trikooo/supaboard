-- 1. Check workspace view access: users can see workspaces they own or belong to
CREATE POLICY "Users can view their workspaces"
ON public.workspaces FOR SELECT
USING (
  owner_id = auth.uid()
  OR public.can_access_workspace(id)
);


-- 2. Check workspace creation access: any authenticated user can create a workspace for themselves
CREATE POLICY "Users can create workspaces"
ON public.workspaces
FOR INSERT
WITH CHECK (owner_id = auth.uid());

-- 3. Check workspace update access: only owners can update their workspaces
CREATE POLICY "Owners can update their workspaces"
ON public.workspaces FOR UPDATE
USING (owner_id = auth.uid());

-- 4. Check workspace delete access: only owners can delete their workspaces
CREATE POLICY "Owners can delete their workspaces"
ON public.workspaces FOR DELETE
USING (owner_id = auth.uid());


-- 5. Check team view access: users can see teams they belong to or in workspaces they own
CREATE POLICY "Users can view teams they belong to"
ON public.teams FOR SELECT
USING (
  public.can_access_teams(id)
);

-- 6. Check team creation access: users can create teams in workspaces they own
CREATE POLICY "Workspace owners can create teams"
ON public.teams FOR INSERT
WITH CHECK (
  public.can_create_team(workspace_id)
);

-- 7. Check team update access: users can update teams if they are workspace owners or team owners/admins
CREATE POLICY "Workspace owners and admins can update teams"
ON public.teams FOR UPDATE
USING (
  public.can_update_team(id)
);

-- 8. Check team delete access: users can delete teams if they are workspace owners
CREATE POLICY "Workspace owners can delete teams"
ON public.teams FOR DELETE
USING (
  public.can_delete_team(id)
);

-- 9. Check team members view access: users can view members of teams they belong to or in workspaces they own
CREATE POLICY "Users can view their team members"
ON public.team_members FOR SELECT
USING (
  public.can_view_team_members(team_id)
);

-- 10. Check team members insert access: users can add members if they are team owners/admins or workspace owners
CREATE POLICY "Admins and owners can add team members"
ON public.team_members FOR INSERT
WITH CHECK (
  public.can_add_team_member(team_id)
);

-- -- 11. Check team members update access: users can update members if they are team admins or workspace owners
-- CREATE POLICY "Admins and owners can update team members"
-- ON public.team_members FOR INSERT
-- USING (
--   public.can_update_team_member(team_id)
-- )

-- 12. Check team members delete access: users can remove members if they are team owners/admins or workspace owners
CREATE POLICY "Admins and owners can remove team members"
ON public.team_members FOR DELETE
USING (
  public.can_remove_team_member(team_id)
);

-- 13. Check project view access: users can view projects if they belong to the team
CREATE POLICY "Team members can view projects"
ON public.projects FOR SELECT
USING (
  public.can_view_project(id)
);

-- 14. Check project insert access: users can create projects if they belong to the team
CREATE POLICY "Team members can create projects"
ON public.projects FOR INSERT
WITH CHECK (
  public.can_create_project(team_id)
);

-- 15. Check project update access: users can update projects if they are the creator or a team owner/admin
CREATE POLICY "Team members can update projects"
ON public.projects FOR UPDATE
USING (
  public.can_update_project(id)
);

-- 16. Check project delete access: users can delete projects if they are the creator or a team owner/admin
CREATE POLICY "Team admins can delete projects"
ON public.projects FOR DELETE
USING (
  public.can_delete_project(id)
);

-- 17. Check issue view access: users can view issues if they belong to the team of the project
CREATE POLICY "Team members can view issues"
ON public.issues FOR SELECT
USING (
  public.can_view_issue(id)
);

-- 18. Check issue insert access: users can create issues if they belong to the team of the project
CREATE POLICY "Team members can create issues"
ON public.issues FOR INSERT
WITH CHECK (
  public.can_create_issue(project_id)
);

-- 19. Check issue update access: users can update issues if they are the creator or a team owner/admin
CREATE POLICY "Team members can update issues"
ON public.issues FOR UPDATE
USING (
  public.can_update_issue(id)
);

-- 20. Check issue delete access: users can delete issues if they are the creator or a team owner/admin
CREATE POLICY "Team members can delete issues"
ON public.issues FOR DELETE
USING (
  public.can_delete_issue(id)
);
