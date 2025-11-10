import { Card, CardContent } from "@/components/ui/card";
import { Plus } from "lucide-react";
import Image from "next/image";
import { Button } from "../ui/button";
import Link from "next/link";
export default function ProductDescription() {
  return (
    <section id="product-description" className="min-h-screen  px-20 py-20">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-6 text-center space-y-6">
          <h1 className="text-6xl lg:text-7xl font-normal leading-tight">
            Supaboard is Still Being Cooked
          </h1>
          <p className="text-muted-foreground text-lg leading-relaxed max-w-md mx-auto">
            You can sign up and explore the features we currently have.
          </p>
          <Link href="/sign-up">
            <Button>Sign up</Button>
          </Link>
        </div>
      </div>
    </section>
  );
}
