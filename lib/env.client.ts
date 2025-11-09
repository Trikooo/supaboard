import z from "zod";

const ClientEnvSchema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.string().url(),
  NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY: z.string(),
});

export type ClientEnv = z.infer<typeof ClientEnvSchema>;

const parsed = ClientEnvSchema.safeParse({
  NEXT_PUBLIC_SUPABASE_URL: process.env.NEXT_PUBLIC_SUPABASE_URL,
  NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY:
    process.env.NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY,
});

if (!parsed.success) {
  console.error("❌ Invalid client environment variables");
  throw new Error("Invalid client environment variables");
}

export const env = parsed.data;
