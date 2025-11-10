import { MessageCircle } from "lucide-react";

import { Button } from "@/components/ui/button";
import { FaGithub } from "react-icons/fa";
import Navbar from "@/components/navbar";
import { createClient } from "@/lib/supabase/server";

export default async function HelpPage() {
  const supabase = await createClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();
  return (
    <>
      <Navbar isLoggedIn={!!user} />
      <div className="min-h-screen bg-background text-foreground mt-30">
        {/* Header Section */}
        <div className="flex flex-col items-center justify-center px-4 pt-16 pb-20 text-center">
          <h1 className="text-4xl md:text-5xl lg:text-6xl font-bold mb-6 text-balance">
            How can we help?
          </h1>
          <p className="text-lg text-muted-foreground max-w-2xl text-balance">
            Get involved with our open source community, report issues, or
            contribute to the project on GitHub.
          </p>
        </div>

        {/* Main Cards Section */}
        <div className="max-w-4xl mx-auto px-4 pb-20">
          <div className="grid md:grid-cols-2 gap-6 mb-16">
            {/* GitHub Issues Card */}
            <div className="border border-border rounded-lg p-8 hover:border-primary/50 transition-colors">
              <div className="flex items-center gap-3 mb-4">
                <FaGithub className="w-6 h-6" />
                <h2 className="text-xl font-semibold">Report Issues</h2>
              </div>
              <p className="text-muted-foreground mb-6">
                Found a bug or have a feature request? Open an issue on GitHub
                to help us improve the project.
              </p>
              <Button
                asChild
                variant="outline"
                className="gap-2 bg-transparent"
              >
                <a
                  href="https://github.com"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  View GitHub Issues
                  <span>→</span>
                </a>
              </Button>
            </div>

            {/* Discussions Card */}
            <div className="border border-border rounded-lg p-8 hover:border-primary/50 transition-colors">
              <div className="flex items-center gap-3 mb-4">
                <MessageCircle className="w-6 h-6" />
                <h2 className="text-xl font-semibold">Discussions</h2>
              </div>
              <p className="text-muted-foreground mb-6">
                Ask questions, share ideas, and get help from the community via
                GitHub Discussions.
              </p>
              <Button
                asChild
                variant="outline"
                className="gap-2 bg-transparent"
              >
                <a
                  href="https://github.com"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  Join Discussions
                  <span>→</span>
                </a>
              </Button>
            </div>
          </div>
        </div>
      </div>
    </>
  );
}
