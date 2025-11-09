import React, { useState, useEffect } from "react";
import { useTheme } from "next-themes";
import Image from "next/image";

const SupaboardLogo = ({
  className = "",
  alt = "Supaboard Logo",
  width,
  height,
}: {
  className?: string;
  alt?: string;
  width?: number;
  height?: number;
}) => {
  const { resolvedTheme } = useTheme();
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  if (!mounted) {
    return null;
  }

  const logoSrc =
    resolvedTheme === "dark"
      ? "/logo/supaboard-logo-dark.png"
      : "/logo/supaboard-logo-light.png";
  return (
    <>
      <Image
        src={logoSrc}
        alt={alt}
        className={className}
        width={width}
        height={height}
        style={{ display: "block" }}
      />
      <span className="sr-only">Supaboard</span>
    </>
  );
};

export default SupaboardLogo;
