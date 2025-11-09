import z from "zod";

const EnvSchema = z.object({
  NEXT_PUBLIC_SUPABASE_URL: z.string().url(),
  NEXT_PUBLIC_SUPABASE_PUBLISHABLE_KEY: z.string(),
  DATABASE_PASSWORD: z.string(),
});

export type ServerEnv = z.infer<typeof EnvSchema>;

const parsed = EnvSchema.safeParse(process.env);
if (!parsed.success) {
  console.error("❌ Invalid environment variables");
  console.error(z.treeifyError(parsed.error).properties);
  throw new Error("Invalid environment variables");
}

export const env = parsed.data;
