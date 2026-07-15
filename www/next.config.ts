import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: "standalone",
  ...(process.env.STATIC_EXPORT === "true" && {
    output: "export",
  }),
};

export default nextConfig;
