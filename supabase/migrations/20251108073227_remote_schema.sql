drop extension if exists "pg_net";

alter table "public"."issues" enable row level security;

alter table "public"."projects" enable row level security;

alter table "public"."team_members" enable row level security;

alter table "public"."teams" enable row level security;

alter table "public"."workspaces" enable row level security;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_user_admin_team_ids(user_uuid uuid)
 RETURNS TABLE(team_id uuid)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  SELECT team_id FROM team_members
  WHERE user_id = user_uuid AND role IN ('owner', 'admin');
$function$
;

CREATE OR REPLACE FUNCTION public.get_user_project_ids(user_uuid uuid)
 RETURNS TABLE(project_id uuid)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  SELECT p.id FROM projects p
  WHERE p.team_id IN (SELECT team_id FROM get_user_team_ids(user_uuid));
$function$
;

CREATE OR REPLACE FUNCTION public.get_user_team_ids(user_uuid uuid)
 RETURNS TABLE(team_id uuid)
 LANGUAGE sql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
  SELECT team_id FROM team_members WHERE user_id = user_uuid;
$function$
;


  create policy "Team members can create issues"
  on "public"."issues"
  as permissive
  for insert
  to public
with check ((project_id IN ( SELECT get_user_project_ids.project_id
   FROM public.get_user_project_ids(auth.uid()) get_user_project_ids(project_id))));



  create policy "Team members can delete issues"
  on "public"."issues"
  as permissive
  for delete
  to public
using ((project_id IN ( SELECT get_user_project_ids.project_id
   FROM public.get_user_project_ids(auth.uid()) get_user_project_ids(project_id))));



  create policy "Team members can update issues"
  on "public"."issues"
  as permissive
  for update
  to public
using ((project_id IN ( SELECT get_user_project_ids.project_id
   FROM public.get_user_project_ids(auth.uid()) get_user_project_ids(project_id))));



  create policy "Team members can view issues"
  on "public"."issues"
  as permissive
  for select
  to public
using ((project_id IN ( SELECT get_user_project_ids.project_id
   FROM public.get_user_project_ids(auth.uid()) get_user_project_ids(project_id))));



  create policy "Team admins can delete projects"
  on "public"."projects"
  as permissive
  for delete
  to public
using ((team_id IN ( SELECT get_user_admin_team_ids.team_id
   FROM public.get_user_admin_team_ids(auth.uid()) get_user_admin_team_ids(team_id))));



  create policy "Team members can create projects"
  on "public"."projects"
  as permissive
  for insert
  to public
with check ((team_id IN ( SELECT get_user_team_ids.team_id
   FROM public.get_user_team_ids(auth.uid()) get_user_team_ids(team_id))));



  create policy "Team members can update projects"
  on "public"."projects"
  as permissive
  for update
  to public
using ((team_id IN ( SELECT get_user_team_ids.team_id
   FROM public.get_user_team_ids(auth.uid()) get_user_team_ids(team_id))));



  create policy "team members can view projects"
  on "public"."projects"
  as permissive
  for select
  to public
using ((team_id IN ( SELECT get_user_team_ids.team_id
   FROM public.get_user_team_ids(auth.uid()) get_user_team_ids(team_id))));



  create policy "Admins and owners can add team members"
  on "public"."team_members"
  as permissive
  for insert
  to public
with check (((team_id IN ( SELECT get_user_admin_team_ids.team_id
   FROM public.get_user_admin_team_ids(auth.uid()) get_user_admin_team_ids(team_id))) OR (team_id IN ( SELECT t.id
   FROM (public.teams t
     JOIN public.workspaces w ON ((w.id = t.workspace_id)))
  WHERE (w.owner_id = auth.uid())))));



  create policy "Admins and owners can remove team members"
  on "public"."team_members"
  as permissive
  for delete
  to public
using (((team_id IN ( SELECT get_user_admin_team_ids.team_id
   FROM public.get_user_admin_team_ids(auth.uid()) get_user_admin_team_ids(team_id))) OR (team_id IN ( SELECT t.id
   FROM (public.teams t
     JOIN public.workspaces w ON ((w.id = t.workspace_id)))
  WHERE (w.owner_id = auth.uid())))));



  create policy "Users can view their team members"
  on "public"."team_members"
  as permissive
  for select
  to public
using (((team_id IN ( SELECT get_user_team_ids.team_id
   FROM public.get_user_team_ids(auth.uid()) get_user_team_ids(team_id))) OR (team_id IN ( SELECT t.id
   FROM (public.teams t
     JOIN public.workspaces w ON ((w.id = t.workspace_id)))
  WHERE (w.owner_id = auth.uid())))));



  create policy "Users can view teams they belong to"
  on "public"."teams"
  as permissive
  for select
  to public
using (((id IN ( SELECT get_user_team_ids.team_id
   FROM public.get_user_team_ids(auth.uid()) get_user_team_ids(team_id))) OR (workspace_id IN ( SELECT w.id
   FROM public.workspaces w
  WHERE (w.owner_id = auth.uid())))));



  create policy "Workspace owners and admins can update teams"
  on "public"."teams"
  as permissive
  for update
  to public
using (((workspace_id IN ( SELECT workspaces.id
   FROM public.workspaces
  WHERE (workspaces.owner_id = auth.uid()))) OR (id IN ( SELECT get_user_admin_team_ids.team_id
   FROM public.get_user_admin_team_ids(auth.uid()) get_user_admin_team_ids(team_id)))));



  create policy "Workspace owners can create teams"
  on "public"."teams"
  as permissive
  for insert
  to public
with check ((workspace_id IN ( SELECT workspaces.id
   FROM public.workspaces
  WHERE (workspaces.owner_id = auth.uid()))));



  create policy "Workspace owners can delete teams"
  on "public"."teams"
  as permissive
  for delete
  to public
using ((workspace_id IN ( SELECT workspaces.id
   FROM public.workspaces
  WHERE (workspaces.owner_id = auth.uid()))));



  create policy "Owners can delete their workspaces"
  on "public"."workspaces"
  as permissive
  for delete
  to public
using ((owner_id = auth.uid()));



  create policy "Owners can update their workspaces"
  on "public"."workspaces"
  as permissive
  for update
  to public
using ((owner_id = auth.uid()));



  create policy "Users can create workspaces"
  on "public"."workspaces"
  as permissive
  for insert
  to public
with check ((auth.uid() IS NOT NULL));



  create policy "Users can view their workspaces"
  on "public"."workspaces"
  as permissive
  for select
  to public
using (((owner_id = auth.uid()) OR (id IN ( SELECT t.workspace_id
   FROM public.teams t
  WHERE (t.id IN ( SELECT get_user_team_ids.team_id
           FROM public.get_user_team_ids(auth.uid()) get_user_team_ids(team_id)))))));



