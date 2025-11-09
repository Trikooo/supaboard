import type { Database } from "@/supabase/types";

export async function createClient() {
  if (typeof window === "undefined") {
    // Server
    const { cookies } = await import("next/headers");
    const { createServerClient } = await import("@supabase/ssr");
    const cookieStore = await cookies();

    return createServerClient<Database>(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!,
      {
        cookies: {
          getAll() {
            return cookieStore.getAll();
          },
          setAll(cookiesToSet) {
            try {
              cookiesToSet.forEach(({ name, value, options }) =>
                cookieStore.set(name, value, options)
              );
            } catch {
              // Ignore if called from Server Component with middleware
            }
          },
        },
      }
    );
  } else {
    // Client
    const { createBrowserClient } = await import("@supabase/ssr");

    return createBrowserClient<Database>(
      process.env.NEXT_PUBLIC_SUPABASE_URL!,
      process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY!
    );
  }
}
