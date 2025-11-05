**Authentication:** Users register and log in through Supabase Auth.

**Workspaces and Teams:** After logging in, a user creates a workspace and adds teams under it. Each team belongs to a single workspace.

**Members:** Team owners add members by their Supabase user ID or email. Members gain access to the team’s projects and issues.

**Projects and Issues:** Team members create projects within their teams. Each project can have multiple issues, which are created and optionally assigned to other team members.

**Access Control:** All authentication and permissions are handled through Supabase Auth and Row-Level Security policies.
