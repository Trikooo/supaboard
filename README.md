# Supaboard

A real-time collaboration and project management tool built on Supabase.

## What is this?

Supaboard is a practical example of what you can build using only Supabase services. It handles workspaces, boards, tasks, comments, and file uploads without relying on external backend infrastructure.

The goal is simple: show how Supabase Auth, Postgres, Realtime, Storage, and Edge Functions can work together to create a complete application.

## Features

- User authentication with email/password and OAuth
- Workspaces with role-based permissions (owner, member, guest)
- Project boards with tasks that update in real-time
- File attachments for tasks
- Notifications via Edge Functions
- Activity logs stored in Postgres
- Full-text search (with optional vector search)
- Scheduled reminders

## Stack

- **Database**: Supabase Postgres with Row Level Security
- **Auth**: Supabase Auth
- **API**: Supabase Edge Functions
- **Realtime**: Supabase Realtime
- **Storage**: Supabase Storage
- **Frontend**: Next.js with the Supabase JS SDK
- **UI**: shadcn/ui and Tailwind

## Getting Started

This project is built with the Supabase Next.js starter [template](https://supabase.com/docs/guides/getting-started/quickstarts/nextjs).


Clone and set up the project:

```bash
git clone https://github.com/<username>/supaboard.git
cd supaboard
npm install
```

The starter template uses `.env.example` for configuration.

```bash
NEXT_PUBLIC_SUPABASE_URL=your-project-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

In the root directory:
```bash
cp .env.local .env.local
```
Start the development server:

```bash
npm run dev
```

Open [localhost:3000](http://localhost:3000) in your browser.

## Front-end Deployment

Vercel. to remove CI/CD friction.

## License

MIT
