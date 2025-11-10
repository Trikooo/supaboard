"use client";
import { cn } from "@/lib/utils";
import { Button } from "@/components/ui/button";
import {
  Field,
  FieldDescription,
  FieldError,
  FieldGroup,
  FieldLabel,
} from "@/components/ui/field";
import {
  InputOTP,
  InputOTPGroup,
  InputOTPSeparator,
  InputOTPSlot,
} from "@/components/ui/input-otp";
import SupaboardLogo from "@/components/logo";
import { useForm, Controller } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import * as z from "zod";
import { useState } from "react";
import { ArrowLeft } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { useRouter, useSearchParams } from "next/navigation";
import { toast } from "sonner";

const verifyOtpSchema = z.object({
  token: z.string().length(8, { message: "Code must be 8 digits" }),
});
type VerifyOtpFormData = z.infer<typeof verifyOtpSchema>;

export function VerifyOtpForm({ className, ...props }: { className?: string }) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const email = searchParams.get("email");
  if (!email) {
    router.push("/login");
  }
  const [isLoading, setIsLoading] = useState(false);
  const { control, handleSubmit } = useForm<VerifyOtpFormData>({
    resolver: zodResolver(verifyOtpSchema),
    defaultValues: {
      token: "",
    },
  });

  const onSubmit = async (values: VerifyOtpFormData) => {
    setIsLoading(true);
    const token = values.token;
    try {
      const supabase = createClient();
      const { data, error } = await supabase.auth.verifyOtp({
        type: "email",
        email: email!,
        token: token,
      });
      if (error) throw error;
      router.push("/dashboard");
    } catch (error: any) {
      toast.error(error.message || "Unable to verify the code");
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className={cn(className, "w-full")} {...props}>
      <form onSubmit={handleSubmit(onSubmit)} noValidate>
        <FieldGroup className="flex flex-col items-center justify-center">
          <div className="flex flex-col items-center gap-2 text-center">
            <h1 className="text-3xl font-bold">Verification</h1>
            <FieldDescription>Enter the code sent to {email}.</FieldDescription>
          </div>
          <div className="flex flex-col gap-8 w-min">
            <Controller
              name="token"
              control={control}
              render={({ field, fieldState }) => (
                <Field data-invalid={fieldState.invalid || undefined}>
                  <div className="flex justify-center">
                    <InputOTP
                      maxLength={8}
                      value={field.value}
                      onChange={field.onChange}
                      disabled={isLoading}
                    >
                      <InputOTPGroup>
                        <InputOTPSlot index={0} />
                        <InputOTPSlot index={1} />
                        <InputOTPSlot index={2} />
                        <InputOTPSlot index={3} />
                      </InputOTPGroup>
                      <InputOTPSeparator />
                      <InputOTPGroup>
                        <InputOTPSlot index={4} />
                        <InputOTPSlot index={5} />
                        <InputOTPSlot index={6} />
                        <InputOTPSlot index={7} />
                      </InputOTPGroup>
                    </InputOTP>
                  </div>
                  <FieldError
                    errors={fieldState.error ? [fieldState.error] : undefined}
                  />
                </Field>
              )}
            />
            <Button
              type="submit"
              loading={isLoading ? "Verifying..." : undefined}
            >
              Verify
            </Button>
          </div>
          <FieldDescription className="flex items-center justify-center">
            <Button
              className="flex items-center gap-1"
              variant="link"
              onClick={() => router.back()}
            >
              <ArrowLeft className="size-4" /> Back
            </Button>
          </FieldDescription>
        </FieldGroup>
      </form>
    </div>
  );
}
