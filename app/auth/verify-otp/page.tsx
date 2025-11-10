import { VerifyOtpForm } from "@/components/verify-otp-form";
import { Suspense } from "react";

export default function Page() {
  return (
    <Suspense>
      <div className="flex min-h-svh w-full items-center justify-center p-6 md:p-10">
        <div className="w-full flex flex-col items-center justify-center ">
          <VerifyOtpForm />
        </div>
      </div>
    </Suspense>
  );
}
