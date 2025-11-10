// app/landing-page/page.tsx (Next.js App Router)
import Hero from "@/components/landing-page/hero";
import ProductDescription from "@/components/landing-page/product-description";
import Navbar from "@/components/navbar";
import { createClient } from "@/lib/supabase/server";

export default async function LandingPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  return (
    <div>
      <Navbar isLoggedIn={!!user} />
      <Hero />
      <ProductDescription />
    </div>
  );
}
