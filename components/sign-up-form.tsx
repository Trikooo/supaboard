"use client";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import {
  Field,
  FieldDescription,
  FieldError,
  FieldGroup,
  FieldLabel,
  FieldSeparator,
} from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import SupaboardLogo from "@/components/logo";
import { FaGoogle, FaDiscord } from "react-icons/fa";
import { useForm, Controller } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { useState } from "react";
import { toast } from "sonner";
import { createClient } from "@/lib/supabase/client";
import { useRouter } from "next/navigation";
import Link from "next/link";

const signUpSchema = z.object({
  email: z.email({ message: "Invalid email address" }),
});
type SignUpFormData = z.infer<typeof signUpSchema>;

export function SignUpForm({
  className,
  ...props
}: React.ComponentProps<"div">) {
  const router = useRouter();
  const [isLoading, setIsLoading] = useState(false);
  const { control, handleSubmit, reset } = useForm<SignUpFormData>({
    resolver: zodResolver(signUpSchema),
    defaultValues: {
      email: "",
    },
  });

  const onSubmit = async (values: SignUpFormData) => {
    setIsLoading(true);

    try {
      const supabase = createClient();
      const email = values.email;
      const { error } = await supabase.auth.signInWithOtp({
        email: email,
      });
      if (error) throw error;
      reset();
      router.push(`/auth/verify-otp?email=${email}`);
    } catch (error: any) {
      console.error(error);
      toast.error(error.message || "Sign up failed, please try again.");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className={cn("flex flex-col gap-6", className)} {...props}>
      <form onSubmit={handleSubmit(onSubmit)} noValidate>
        <FieldGroup>
          <div className="flex flex-col items-center gap-2 text-center">
            <a
              href="#"
              className="flex flex-col items-center gap-2 font-medium"
            >
              <SupaboardLogo width={180} height={45} className="mb-2" />
              <span className="sr-only">Supaboard</span>
            </a>
            <h1 className="text-xl font-bold">Create a New Account</h1>
            <FieldDescription>
              Already have an account? <Link href="/login">
                <Button variant="link" className="p-0">
                  Sign in
                </Button>
              </Link>
            </FieldDescription>
          </div>

          <Controller
            name="email"
            control={control}
            render={({ field, fieldState }) => (
              <Field data-invalid={fieldState.invalid || undefined}>
                <FieldLabel htmlFor="email">Email</FieldLabel>
                <Input
                  {...field}
                  id="email"
                  type="email"
                  placeholder="m@example.com"
                  aria-invalid={fieldState.invalid || undefined}
                  disabled={isLoading}
                />
                <FieldError
                  errors={fieldState.error ? [fieldState.error] : undefined}
                />
              </Field>
            )}
          />

          <Button
            type="submit"
            loading={isLoading ? "Signing up..." : undefined}
          >
            Sign Up
          </Button>

          <FieldSeparator>Or</FieldSeparator>

          <div className="grid gap-4 sm:grid-cols-2">
            <Button variant="outline" type="button">
              <FaDiscord size={16} />
              Continue with Discord
            </Button>
            <Button variant="outline" type="button" disabled={isLoading}>
              <FaGoogle size={16} />
              Continue with Google
            </Button>
          </div>
        </FieldGroup>
      </form>
      <FieldDescription className="px-6 text-center">
        By continuing, you accept our <a href="#">Terms</a> and{" "}
        <a href="#">Policies</a>.
      </FieldDescription>
    </div>
  );
}
