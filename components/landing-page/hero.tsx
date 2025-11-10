import { BackgroundBeams } from "../ui/background-beams";
import { Button } from "../ui/button";

export default function Hero() {
  return (
    <>
      {/* Background beams */}
      <BackgroundBeams className="absolute left-0 top-0 -z-50" />
      <div className="flex flex-col items-center justify-center min-h-screen px-6 text-center relative z-10">
        <h1 className="text-5xl md:text-7xl mb-6 font-medium">
          Keep your projects on track
        </h1>
        <p className="text-lg text-muted-foreground mb-8 max-w-2xl">
          Plan, organize, and finish work faster with a simple project
          management system.
        </p>
        <div className="flex items-center justify-center gap-4">
          <Button>Get started</Button>
          <Button variant="outline">Learn more</Button>
        </div>
      </div>
    </>
  );
}
