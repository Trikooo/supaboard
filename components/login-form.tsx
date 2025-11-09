"use client";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import {
  Field,
  FieldDescription,
  FieldGroup,
  FieldLabel,
  FieldSeparator,
} from "@/components/ui/field";
import { Input } from "@/components/ui/input";
import SupaboardLogo from "@/components/logo";
import { FaGoogle } from "react-icons/fa";
import { FaDiscord } from "react-icons/fa";

export function LoginForm({
  className,
  ...props
}: React.ComponentProps<"div">) {
  return (
    <div className={cn("flex flex-col gap-6", className)} {...props}>
      <form>
        <FieldGroup>
          <div className="flex flex-col items-center gap-2 text-center">
            <a
              href="/"
              className="flex flex-col items-center gap-2 font-medium"
            >
              <SupaboardLogo width={180} height={45} className="mb-2" />
            </a>
            <h1 className="text-xl font-bold">Sign in to Your Account</h1>
            <FieldDescription>
              Don't have an account? <a href="/sign-up">Sign up</a>
            </FieldDescription>
          </div>
          <Field>
            <FieldLabel htmlFor="email">Email</FieldLabel>
            <Input
              id="email"
              type="email"
              placeholder="m@example.com"
              required
            />
          </Field>
          <Field>
            <Button type="submit">Login</Button>
          </Field>
          <FieldSeparator>Or</FieldSeparator>
          <Field className="grid gap-4 sm:grid-cols-2">
            <Button variant="outline" type="button">
              <FaDiscord size={4} />
              Continue with Discord
            </Button>
            <Button variant="outline" type="button">
              <FaGoogle size={4} />
              Continue with Google
            </Button>
          </Field>
        </FieldGroup>
      </form>
      <FieldDescription className="px-6 text-center">
        By continuing, you accept our <a href="#">Terms</a> and{" "}
        <a href="#">Policies</a>.
      </FieldDescription>
    </div>
  );
}
