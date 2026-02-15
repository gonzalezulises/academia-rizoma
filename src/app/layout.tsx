import type { Metadata } from "next";
import { Inter, Source_Serif_4 } from "next/font/google";
import "./globals.css";
import AccessibilityPanel from "@/components/AccessibilityPanel";
import Footer from "@/components/Footer";

const inter = Inter({
  variable: "--font-inter",
  subsets: ["latin"],
  display: "swap",
});

const sourceSerif = Source_Serif_4({
  variable: "--font-source-serif",
  subsets: ["latin"],
  display: "swap",
});

export const metadata: Metadata = {
  title: {
    default: "Rizoma Academia | Aprende, crece, transforma",
    template: "%s | Rizoma Academia",
  },
  description: "Plataforma de aprendizaje de Rizoma. Cursos de alta calidad en transformación organizacional, liderazgo y desarrollo profesional.",
  keywords: ["aprendizaje", "cursos", "transformación organizacional", "liderazgo", "Rizoma", "educación"],
  authors: [{ name: "Rizoma", url: "https://rizo.ma" }],
  openGraph: {
    type: "website",
    locale: "es_PA",
    url: "https://rizo.ma/academia",
    siteName: "Rizoma Academia",
    title: "Rizoma Academia | Aprende, crece, transforma",
    description: "Plataforma de aprendizaje de Rizoma. Cursos de alta calidad en transformación organizacional.",
  },
  twitter: {
    card: "summary_large_image",
    title: "Rizoma Academia",
    description: "Plataforma de aprendizaje de Rizoma",
  },
  icons: {
    icon: "/academia/favicon.png",
    apple: "/academia/apple-touch-icon.png",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es" suppressHydrationWarning>
      <head>
        <script
          dangerouslySetInnerHTML={{
            __html: `(function(){try{var s=JSON.parse(localStorage.getItem('rizo_a11y_settings')||'{}');if(s.darkMode)document.documentElement.classList.add('dark');if(s.highContrast)document.documentElement.classList.add('high-contrast');if(s.reducedMotion)document.documentElement.classList.add('reduce-motion');if(s.textSize){var m={small:'14px',normal:'16px',large:'18px',xlarge:'20px'};document.documentElement.style.fontSize=m[s.textSize]||'16px'}}catch(e){}})()`,
          }}
        />
      </head>
      <body
        className={`${inter.variable} ${sourceSerif.variable} font-sans antialiased`}
      >
        {children}
        <Footer />
        <AccessibilityPanel />
      </body>
    </html>
  );
}
