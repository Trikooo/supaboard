-- Enums
CREATE TYPE issue_status AS ENUM (
  'backlog',
  'to_do',
  'in_progress',
  'done',
  'cancelled',
  'on_hold'
);

CREATE TYPE issue_priority AS ENUM ('low', 'medium', 'high', 'urgent');
CREATE TYPE role AS ENUM ('owner', 'admin', 'member', 'guest');

-- Ensure pgcrypto is available
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- 1. workspaces
CREATE TABLE public.workspaces (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  name text NOT NULL,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- 2. teams
CREATE TABLE public.teams (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  workspace_id uuid NOT NULL REFERENCES public.workspaces(id) ON DELETE CASCADE,
  name text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- 3. team_members
CREATE TABLE public.team_members (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  team_id uuid NOT NULL REFERENCES public.teams(id) ON DELETE CASCADE,
  user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role role NOT NULL DEFAULT 'member',
  created_at timestamptz DEFAULT now(),
  UNIQUE (team_id, user_id)
);

-- 4. projects
CREATE TABLE public.projects (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  team_id uuid NOT NULL REFERENCES public.teams(id) ON DELETE CASCADE,
  created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  name text NOT NULL,
  description text,
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- 5. issues
CREATE TABLE public.issues (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  project_id uuid NOT NULL REFERENCES public.projects(id) ON DELETE CASCADE,
  created_by uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  assigned_to uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  title text NOT NULL,
  description text,
  status issue_status DEFAULT 'backlog',
  priority issue_priority DEFAULT 'medium',
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now()
);

-- Indexes
CREATE INDEX idx_issues_project_id ON public.issues(project_id);
CREATE INDEX idx_issues_assigned_to ON public.issues(assigned_to);
CREATE INDEX idx_issues_created_by ON public.issues(created_by);
CREATE INDEX idx_issues_status ON public.issues(status);
CREATE INDEX idx_issues_priority ON public.issues(priority);
CREATE INDEX idx_issues_project_status ON public.issues(project_id, status);
CREATE INDEX idx_issues_project_priority ON public.issues(project_id, priority);
CREATE INDEX idx_issues_title ON public.issues(title);
CREATE INDEX idx_issues_created_at ON public.issues(created_at);

-- ===================================
-- Auto-update timestamp triggers
-- ===================================
CREATE OR REPLACE FUNCTION update_timestamp() RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_workspaces_updated_at
BEFORE UPDATE ON public.workspaces
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_teams_updated_at
BEFORE UPDATE ON public.teams
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_projects_updated_at
BEFORE UPDATE ON public.projects
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_issues_updated_at
BEFORE UPDATE ON public.issues
FOR EACH ROW EXECUTE FUNCTION update_timestamp();

CREATE TRIGGER update_team_members_updated_at
BEFORE UPDATE ON public.team_members
FOR EACH ROW EXECUTE FUNCTION update_timestamp();
