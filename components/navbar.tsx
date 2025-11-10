import Link from "next/link";
import SupaboardLogo from "./logo";
import { Button } from "./ui/button";

const navElements = {
  links: [
    { label: "Product", url: "/#product-description" },
    { label: "Contact", url: "/contact" },
  ] as { label: string; url: string }[],
};

type NavbarProps = {
  isLoggedIn: boolean;
};

export default function Navbar({ isLoggedIn }: NavbarProps) {
  return (
    <nav className="fixed top-0 left-0 right-0 z-50 bg-background/50 border-b backdrop-blur-sm">
      <div className="max-w-7xl mx-auto px-6 h-16 flex items-center justify-between">
        <div className="flex items-center">
          <SupaboardLogo width={140} height={30} />
        </div>

        <div className="hidden md:flex items-center gap-6 absolute left-1/2 -translate-x-1/2">
          {navElements.links.map(({ label, url }) => (
            <a
              key={url + label}
              href={url}
              className="text-sm text-muted-foreground hover:text-foreground transition-colors"
            >
              {label}
            </a>
          ))}
        </div>

        <div className="flex items-center gap-4">
          {isLoggedIn ? (
            <Link href="/dashboard">
              <Button>Dashboard</Button>
            </Link>
          ) : (
            <>
              <Link href="/auth/login">
                <Button variant="ghost">Log in</Button>
              </Link>
              <Link href="/auth/sign-up">
                <Button>Sign up</Button>
              </Link>
            </>
          )}
        </div>
      </div>
    </nav>
  );
}
