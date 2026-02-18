import type { NextConfig } from "next";

const securityHeaders = [
  {
    key: 'X-DNS-Prefetch-Control',
    value: 'on'
  },
  {
    key: 'Strict-Transport-Security',
    value: 'max-age=63072000; includeSubDomains; preload'
  },
  {
    key: 'X-Frame-Options',
    value: 'SAMEORIGIN'
  },
  {
    key: 'X-Content-Type-Options',
    value: 'nosniff'
  },
  {
    key: 'Referrer-Policy',
    value: 'origin-when-cross-origin'
  },
  {
    key: 'Permissions-Policy',
    value: 'camera=(), microphone=(), geolocation=()'
  },
  {
    key: 'Content-Security-Policy',
    value: [
      "default-src 'self'",
      "script-src 'self' 'unsafe-eval' 'unsafe-inline' https://vercel.live https://*.vercelinsights.com https://cdn.jsdelivr.net https://tally.so",
      "style-src 'self' 'unsafe-inline' https://fonts.googleapis.com https://cdn.jsdelivr.net",
      "font-src 'self' https://fonts.gstatic.com https://cdn.jsdelivr.net",
      "img-src 'self' data: blob: https: http:",
      "media-src 'self' https:",
      "connect-src 'self' https://*.supabase.co wss://*.supabase.co https://ollama.rizo.ma https://api.anthropic.com https://www.googleapis.com https://vercel.live https://*.vercelinsights.com",
      "frame-src 'self' https://www.youtube.com https://www.youtube-nocookie.com https://player.vimeo.com https://colab.research.google.com https://vercel.live https://tally.so",
      "worker-src 'self' blob:",
    ].join('; ')
  }
];

// Determina si estamos en producción (Vercel) o desarrollo local
const isProduction = process.env.VERCEL_ENV === 'production' || process.env.NODE_ENV === 'production';
const basePath = isProduction ? '/academia' : '';

const nextConfig: NextConfig = {
  // Base path para servir desde rizo.ma/academia
  basePath,
  assetPrefix: basePath,

  // Exponer basePath a componentes cliente
  env: {
    NEXT_PUBLIC_BASE_PATH: basePath,
  },

  // Incluir archivos de contenido en el bundle serverless
  outputFileTracingIncludes: {
    '/api/exercises/[exerciseId]': ['./content/**/*', './config/**/*'],
  },

  async headers() {
    return [
      {
        source: '/:path*',
        headers: securityHeaders,
      },
    ];
  },
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: '*.supabase.co',
      },
      {
        protocol: 'https',
        hostname: 'rizo.ma',
      },
    ],
  },
};

export default nextConfig;
