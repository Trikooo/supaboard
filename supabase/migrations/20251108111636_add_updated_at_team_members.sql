ALTER TABLE public.team_members
ADD COLUMN updated_at timestamptz DEFAULT now();
