# Tu primera página

## Introducción

Ahora que tienes tu proyecto configurado, es hora de crear tu primera página real. En esta lección aprenderás cómo funcionan las rutas en App Router, cómo crear páginas y layouts, y entenderás el flujo de renderizado.

## Anatomía de una página

Una página en Next.js 14 es un archivo `page.tsx` dentro de la carpeta `app/`:

```tsx
// src/app/page.tsx
export default function HomePage() {
  return (
    <div>
      <h1>Bienvenido a mi sitio</h1>
      <p>Esta es la página principal.</p>
    </div>
  );
}
```

Puntos clave:
- El nombre del archivo **debe** ser `page.tsx` (o `.js`, `.jsx`)
- La función **debe** ser el export default
- Este es un **Server Component** por defecto

## Creando rutas con carpetas

Cada carpeta dentro de `app/` crea un segmento de URL:

```
app/
├── page.tsx                    → /
├── about/
│   └── page.tsx                → /about
├── products/
│   ├── page.tsx                → /products
│   └── [id]/
│       └── page.tsx            → /products/123
└── blog/
    ├── page.tsx                → /blog
    └── [slug]/
        └── page.tsx            → /blog/mi-primer-post
```

### Ejemplo: Página About

```tsx
// src/app/about/page.tsx
export default function AboutPage() {
  return (
    <main className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-4">Sobre nosotros</h1>
      <p className="text-gray-600">
        Somos una empresa dedicada a crear software increíble.
      </p>

      <section className="mt-8">
        <h2 className="text-2xl font-semibold mb-2">Nuestro equipo</h2>
        <ul className="list-disc list-inside">
          <li>María - CEO</li>
          <li>Carlos - CTO</li>
          <li>Ana - Lead Developer</li>
        </ul>
      </section>
    </main>
  );
}
```

Accede a esta página en `http://localhost:3000/about`.

## El layout raíz

El archivo `app/layout.tsx` es **obligatorio** y define la estructura HTML base:

```tsx
// src/app/layout.tsx
import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: {
    template: '%s | Mi Sitio',
    default: 'Mi Sitio',
  },
  description: 'Una aplicación Next.js moderna',
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="es">
      <body className={inter.className}>
        <header className="bg-gray-900 text-white p-4">
          <nav className="container mx-auto flex gap-4">
            <a href="/" className="hover:underline">Inicio</a>
            <a href="/about" className="hover:underline">Sobre nosotros</a>
            <a href="/products" className="hover:underline">Productos</a>
          </nav>
        </header>
        <main>{children}</main>
        <footer className="bg-gray-100 p-4 mt-8 text-center">
          <p>&copy; 2024 Mi Sitio. Todos los derechos reservados.</p>
        </footer>
      </body>
    </html>
  );
}
```

Este layout:
- Define `<html>` y `<body>` (requerido)
- Aplica una fuente de Google
- Incluye header y footer que aparecen en todas las páginas
- Renderiza `{children}` donde irá el contenido de cada página

## Metadata para SEO

Cada página puede exportar metadata:

```tsx
// src/app/about/page.tsx
import type { Metadata } from 'next';

export const metadata: Metadata = {
  title: 'Sobre nosotros',
  description: 'Conoce al equipo detrás de nuestra empresa',
  openGraph: {
    title: 'Sobre nosotros',
    description: 'Conoce al equipo detrás de nuestra empresa',
    images: ['/images/team.jpg'],
  },
};

export default function AboutPage() {
  // ... componente
}
```

Con el template del layout, el título será: "Sobre nosotros | Mi Sitio".

## Página de productos con datos

Creemos una página que simule cargar productos:

```tsx
// src/app/products/page.tsx
import Link from 'next/link';

// Simulamos una base de datos
const products = [
  { id: 1, name: 'Laptop Pro', price: 1299, category: 'Electronics' },
  { id: 2, name: 'Wireless Mouse', price: 49, category: 'Accessories' },
  { id: 3, name: 'Mechanical Keyboard', price: 149, category: 'Accessories' },
  { id: 4, name: '4K Monitor', price: 399, category: 'Electronics' },
];

export const metadata = {
  title: 'Productos',
  description: 'Explora nuestro catálogo de productos',
};

export default function ProductsPage() {
  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Nuestros Productos</h1>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        {products.map((product) => (
          <Link
            key={product.id}
            href={`/products/${product.id}`}
            className="block p-6 bg-white rounded-lg shadow hover:shadow-lg transition-shadow"
          >
            <span className="text-sm text-gray-500">{product.category}</span>
            <h2 className="text-xl font-semibold mt-1">{product.name}</h2>
            <p className="text-2xl font-bold text-blue-600 mt-2">
              ${product.price}
            </p>
          </Link>
        ))}
      </div>
    </div>
  );
}
```

## Rutas dinámicas

Para páginas como `/products/1`, `/products/2`, usamos corchetes:

```tsx
// src/app/products/[id]/page.tsx
import { notFound } from 'next/navigation';
import Link from 'next/link';

const products = [
  { id: 1, name: 'Laptop Pro', price: 1299, description: 'La mejor laptop para profesionales' },
  { id: 2, name: 'Wireless Mouse', price: 49, description: 'Mouse ergonómico inalámbrico' },
  { id: 3, name: 'Mechanical Keyboard', price: 149, description: 'Teclado mecánico RGB' },
  { id: 4, name: '4K Monitor', price: 399, description: 'Monitor 4K de 27 pulgadas' },
];

// Función para obtener producto (simula DB)
function getProduct(id: number) {
  return products.find(p => p.id === id);
}

// Genera metadata dinámica
export async function generateMetadata({ params }: { params: { id: string } }) {
  const product = getProduct(parseInt(params.id));

  if (!product) {
    return { title: 'Producto no encontrado' };
  }

  return {
    title: product.name,
    description: product.description,
  };
}

// Componente de la página
export default function ProductPage({ params }: { params: { id: string } }) {
  const product = getProduct(parseInt(params.id));

  if (!product) {
    notFound();
  }

  return (
    <div className="container mx-auto px-4 py-8">
      <Link
        href="/products"
        className="text-blue-600 hover:underline mb-4 inline-block"
      >
        ← Volver a productos
      </Link>

      <div className="bg-white rounded-lg shadow-lg p-8 mt-4">
        <h1 className="text-4xl font-bold">{product.name}</h1>
        <p className="text-gray-600 mt-4 text-lg">{product.description}</p>
        <p className="text-3xl font-bold text-blue-600 mt-6">
          ${product.price}
        </p>

        <button className="mt-8 bg-blue-600 text-white px-8 py-3 rounded-lg hover:bg-blue-700 transition-colors">
          Agregar al carrito
        </button>
      </div>
    </div>
  );
}
```

### Importante sobre params en Next.js 15+

En Next.js 15, `params` es una Promise:

```tsx
// Next.js 15+
export default async function ProductPage({
  params
}: {
  params: Promise<{ id: string }>
}) {
  const { id } = await params;
  const product = getProduct(parseInt(id));
  // ...
}
```

## Navegación con Link

Usa el componente `Link` en lugar de `<a>` para navegación del lado del cliente:

```tsx
import Link from 'next/link';

export function Navigation() {
  return (
    <nav className="flex gap-4">
      {/* Navegación básica */}
      <Link href="/">Inicio</Link>

      {/* Con estilos */}
      <Link
        href="/about"
        className="text-blue-600 hover:underline"
      >
        Sobre nosotros
      </Link>

      {/* Ruta dinámica */}
      <Link href={`/products/${productId}`}>
        Ver producto
      </Link>

      {/* Desactivar prefetch */}
      <Link href="/heavy-page" prefetch={false}>
        Página pesada
      </Link>
    </nav>
  );
}
```

## Página 404 personalizada

```tsx
// src/app/not-found.tsx
import Link from 'next/link';

export default function NotFound() {
  return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center">
        <h1 className="text-6xl font-bold text-gray-300">404</h1>
        <h2 className="text-2xl font-semibold mt-4">Página no encontrada</h2>
        <p className="text-gray-600 mt-2">
          Lo sentimos, la página que buscas no existe.
        </p>
        <Link
          href="/"
          className="inline-block mt-6 bg-blue-600 text-white px-6 py-2 rounded hover:bg-blue-700"
        >
          Volver al inicio
        </Link>
      </div>
    </div>
  );
}
```

## Estructura completa del proyecto

Después de esta lección, tu estructura debería verse así:

```
src/app/
├── layout.tsx              # Layout raíz con header/footer
├── page.tsx                # Página principal (/)
├── not-found.tsx           # Página 404 global
├── globals.css             # Estilos globales
├── about/
│   └── page.tsx            # /about
└── products/
    ├── page.tsx            # /products
    └── [id]/
        └── page.tsx        # /products/:id
```

## Errores comunes

### Error 1: Olvidar el export default

```tsx
// ❌ Error: La página no exporta un componente por defecto
export function AboutPage() {
  return <div>About</div>;
}

// ✅ Correcto
export default function AboutPage() {
  return <div>About</div>;
}
```

### Error 2: Usar anchor tags en lugar de Link

```tsx
// ❌ Causa full page reload
<a href="/about">About</a>

// ✅ Navegación del lado del cliente
<Link href="/about">About</Link>
```

### Error 3: Carpeta sin page.tsx

```
app/
└── components/         # ❌ No es una ruta, solo organización
    └── Button.tsx
```

Las carpetas sin `page.tsx` no crean rutas, solo sirven para organizar código.

## Resumen

| Concepto | Archivo/Patrón |
|----------|----------------|
| Página | `page.tsx` |
| Layout | `layout.tsx` |
| Ruta estática | `app/about/page.tsx` → `/about` |
| Ruta dinámica | `app/products/[id]/page.tsx` → `/products/123` |
| 404 | `not-found.tsx` |
| Navegación | Componente `Link` |
| Metadata | Export `metadata` o función `generateMetadata` |

## Ejercicio práctico

Crea las siguientes páginas para practicar:

1. `/contact` - Página de contacto con un formulario básico
2. `/blog` - Lista de posts de blog
3. `/blog/[slug]` - Página individual de un post

## Recursos adicionales

- [App Router: Pages and Layouts](https://nextjs.org/docs/app/building-your-application/routing/pages-and-layouts)
- [Dynamic Routes](https://nextjs.org/docs/app/building-your-application/routing/dynamic-routes)
- [Link Component](https://nextjs.org/docs/app/api-reference/components/link)
