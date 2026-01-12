import type { Metadata } from "next";
import { Inter, Source_Serif_4 } from "next/font/google";
import "./globals.css";

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
    icon: "/academia/favicon.ico",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es">
      <body
        className={`${inter.variable} ${sourceSerif.variable} font-sans antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
