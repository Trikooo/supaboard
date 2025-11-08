-- 11. Check team members update access: users can update members if they are team admins or workspace owners
CREATE POLICY "Admins and owners can update team members"
ON public.team_members FOR UPDATE
USING (
  public.can_update_team_member(team_id)
)
