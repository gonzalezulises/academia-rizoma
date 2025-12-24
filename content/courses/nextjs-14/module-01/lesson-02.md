# Arquitectura del App Router

## Introducción

Next.js 14 marca la madurez del **App Router**, una nueva forma de estructurar aplicaciones que reemplaza al Pages Router tradicional. No es solo un cambio de carpetas—es un cambio fundamental en cómo pensamos sobre componentes, data fetching y rendering.

## Pages Router vs App Router

### Pages Router (legacy)

```
pages/
├── index.tsx           → /
├── about.tsx           → /about
├── products/
│   ├── index.tsx       → /products
│   └── [id].tsx        → /products/:id
└── _app.tsx            → Layout global
```

Características del Pages Router:
- Todos los componentes son Client Components
- Data fetching con `getServerSideProps` / `getStaticProps`
- Layouts con `_app.tsx` y `_document.tsx`
- API routes en `/pages/api/`

### App Router (actual)

```
app/
├── page.tsx            → /
├── layout.tsx          → Layout raíz (obligatorio)
├── about/
│   └── page.tsx        → /about
├── products/
│   ├── page.tsx        → /products
│   └── [id]/
│       └── page.tsx    → /products/:id
└── api/
    └── route.ts        → API endpoint
```

## Convenciones de archivos especiales

El App Router usa nombres de archivo reservados con comportamientos específicos:

### `page.tsx` - Define una ruta

```tsx
// app/dashboard/page.tsx → /dashboard
export default function DashboardPage() {
  return <h1>Dashboard</h1>;
}
```

Sin `page.tsx`, la carpeta no es accesible como ruta (útil para organización).

### `layout.tsx` - UI compartida

```tsx
// app/dashboard/layout.tsx
export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex">
      <Sidebar />
      <main className="flex-1">{children}</main>
    </div>
  );
}
```

Los layouts:
- Envuelven todas las páginas y layouts hijos
- **Preservan estado** entre navegaciones
- No se re-renderizan cuando la página hija cambia

### `template.tsx` - Similar a layout pero se re-renderiza

```tsx
// app/dashboard/template.tsx
export default function DashboardTemplate({
  children,
}: {
  children: React.ReactNode;
}) {
  // Se ejecuta en cada navegación
  useEffect(() => {
    logPageView();
  }, []);

  return <div>{children}</div>;
}
```

Usa `template.tsx` cuando necesitas:
- Animaciones de entrada/salida en cada navegación
- Features que dependen de `useEffect` en navegación
- Resetear estado en cada visita

### `loading.tsx` - Estado de carga

```tsx
// app/dashboard/loading.tsx
export default function DashboardLoading() {
  return (
    <div className="animate-pulse">
      <div className="h-8 bg-gray-200 rounded w-1/4 mb-4" />
      <div className="h-4 bg-gray-200 rounded w-3/4" />
    </div>
  );
}
```

Next.js envuelve automáticamente `page.tsx` en un `Suspense` boundary usando `loading.tsx` como fallback.

### `error.tsx` - Manejo de errores

```tsx
'use client'; // Error boundaries deben ser Client Components

export default function DashboardError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div className="p-4 bg-red-50 rounded">
      <h2 className="text-red-800">Algo salió mal</h2>
      <button onClick={reset} className="mt-2 btn">
        Intentar de nuevo
      </button>
    </div>
  );
}
```

### `not-found.tsx` - Página 404

```tsx
// app/not-found.tsx - 404 global
export default function NotFound() {
  return (
    <div className="text-center py-20">
      <h1 className="text-4xl font-bold">404</h1>
      <p>Página no encontrada</p>
      <Link href="/">Volver al inicio</Link>
    </div>
  );
}
```

También puedes invocarla programáticamente:

```tsx
import { notFound } from 'next/navigation';

async function ProductPage({ params }) {
  const product = await getProduct(params.id);

  if (!product) {
    notFound(); // Renderiza not-found.tsx
  }

  return <ProductDetails product={product} />;
}
```

### `route.ts` - API endpoints

```tsx
// app/api/users/route.ts
import { NextResponse } from 'next/server';

export async function GET(request: Request) {
  const users = await getUsers();
  return NextResponse.json(users);
}

export async function POST(request: Request) {
  const body = await request.json();
  const user = await createUser(body);
  return NextResponse.json(user, { status: 201 });
}
```

## Jerarquía de archivos y renderizado

Cuando accedes a `/dashboard/settings`, Next.js compone:

```
app/
├── layout.tsx          ─┐
├── dashboard/          │
│   ├── layout.tsx      ├─→ UI anidada
│   └── settings/       │
│       └── page.tsx    ─┘
```

Resultado renderizado:

```tsx
<RootLayout>
  <DashboardLayout>
    <SettingsPage />
  </DashboardLayout>
</RootLayout>
```

## Server Components por defecto

En App Router, **todos los componentes son Server Components** a menos que declares `'use client'`.

```tsx
// Este componente se ejecuta SOLO en el servidor
async function ProductList() {
  // Puedes hacer await directamente
  const products = await db.products.findMany();

  return (
    <ul>
      {products.map(p => (
        <li key={p.id}>{p.name}</li>
      ))}
    </ul>
  );
}
```

Beneficios:
- **Cero JavaScript** enviado al cliente para este componente
- Acceso directo a bases de datos, file system, secrets
- Mejor performance y menor bundle size

## Colocación de archivos

Puedes colocar archivos no-página junto a tus rutas:

```
app/
├── dashboard/
│   ├── page.tsx
│   ├── Dashboard.module.css  ← Estilos locales
│   ├── actions.ts            ← Server Actions
│   ├── hooks.ts              ← Custom hooks
│   └── components/
│       ├── Chart.tsx
│       └── Stats.tsx
```

Solo `page.tsx`, `layout.tsx`, etc. son tratados especialmente. Los demás archivos son código normal.

## Metadata y SEO

```tsx
// app/products/[id]/page.tsx
import type { Metadata } from 'next';

// Metadata estática
export const metadata: Metadata = {
  title: 'Productos',
  description: 'Catálogo de productos',
};

// O metadata dinámica
export async function generateMetadata({ params }): Promise<Metadata> {
  const product = await getProduct(params.id);

  return {
    title: product.name,
    description: product.description,
    openGraph: {
      images: [product.image],
    },
  };
}
```

## Estructura recomendada

```
app/
├── (auth)/                    # Grupo - no afecta URL
│   ├── login/
│   │   └── page.tsx           → /login
│   └── register/
│       └── page.tsx           → /register
├── (dashboard)/               # Otro grupo
│   ├── layout.tsx             # Layout solo para dashboard
│   ├── dashboard/
│   │   └── page.tsx           → /dashboard
│   └── settings/
│       └── page.tsx           → /settings
├── api/
│   └── webhooks/
│       └── route.ts
├── layout.tsx                 # Layout raíz
├── page.tsx                   → /
└── globals.css
```

## Errores comunes

### Error 1: Olvidar que layouts no se re-renderizan

```tsx
// ❌ Esto NO funcionará como esperas
// app/dashboard/layout.tsx
export default function DashboardLayout({ children }) {
  const pathname = usePathname(); // Hook reactivo

  // Este console.log NO se ejecuta en cada navegación
  console.log('Current path:', pathname);

  return <div>{children}</div>;
}
```

El layout se renderiza una vez y preserva estado. Para lógica en cada navegación, usa `template.tsx` o un componente cliente interno.

### Error 2: No entender la jerarquía de error boundaries

```
app/
├── layout.tsx        ← error.tsx NO captura errores aquí
├── error.tsx         ← Captura errores de page.tsx
└── page.tsx
```

Para capturar errores del root layout, necesitas `global-error.tsx` en la raíz.

### Error 3: Usar `'use client'` innecesariamente

```tsx
// ❌ No necesitas 'use client' solo para renderizar
'use client'
export function ProductCard({ product }) {
  return <div>{product.name}</div>;
}

// ✅ Esto es un Server Component válido
export function ProductCard({ product }) {
  return <div>{product.name}</div>;
}
```

Solo usa `'use client'` cuando necesites:
- Hooks (`useState`, `useEffect`, `useContext`)
- Event handlers (`onClick`, `onChange`)
- APIs del navegador (`localStorage`, `window`)

## Resumen

| Archivo | Propósito |
|---------|-----------|
| `page.tsx` | Define contenido de la ruta |
| `layout.tsx` | UI compartida, preserva estado |
| `template.tsx` | Como layout pero se re-renderiza |
| `loading.tsx` | Fallback mientras carga |
| `error.tsx` | Boundary de errores |
| `not-found.tsx` | Página 404 |
| `route.ts` | API endpoint |

El App Router es más que una nueva estructura de carpetas. Es un cambio de paradigma que aprovecha React Server Components para construir aplicaciones más eficientes.

## Recursos adicionales

- [Next.js Routing Documentation](https://nextjs.org/docs/app/building-your-application/routing)
- [File Conventions Reference](https://nextjs.org/docs/app/api-reference/file-conventions)
