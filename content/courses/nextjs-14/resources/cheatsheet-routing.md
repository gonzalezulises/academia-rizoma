# Next.js 14 Routing Cheatsheet

## Estructura de archivos especiales

| Archivo | Propósito |
|---------|-----------|
| `page.tsx` | UI única para la ruta |
| `layout.tsx` | UI compartida (preserva estado) |
| `template.tsx` | Como layout pero se re-renderiza |
| `loading.tsx` | Loading UI con Suspense |
| `error.tsx` | Error boundary |
| `not-found.tsx` | 404 UI |
| `route.ts` | API endpoint |
| `default.tsx` | Fallback para parallel routes |

## Patrones de rutas

### Rutas dinámicas

```
app/
├── blog/
│   └── [slug]/
│       └── page.tsx     → /blog/hello-world
```

```tsx
// Acceder al parámetro
export default function Page({ params }: { params: { slug: string } }) {
  return <h1>Post: {params.slug}</h1>;
}
```

### Catch-all routes

```
app/
├── docs/
│   └── [...slug]/
│       └── page.tsx     → /docs/a/b/c
```

```tsx
// params.slug = ['a', 'b', 'c']
```

### Optional catch-all

```
app/
├── shop/
│   └── [[...categories]]/
│       └── page.tsx     → /shop, /shop/a, /shop/a/b
```

### Grupos de rutas

```
app/
├── (marketing)/         → No afecta URL
│   ├── layout.tsx       → Layout para marketing
│   └── about/
│       └── page.tsx     → /about
├── (app)/
│   ├── layout.tsx       → Layout diferente
│   └── dashboard/
│       └── page.tsx     → /dashboard
```

## Parallel Routes

```
app/
├── @team/
│   └── page.tsx
├── @analytics/
│   └── page.tsx
├── layout.tsx           → Recibe team y analytics como props
└── page.tsx
```

```tsx
// layout.tsx
export default function Layout({
  children,
  team,
  analytics,
}: {
  children: React.ReactNode;
  team: React.ReactNode;
  analytics: React.ReactNode;
}) {
  return (
    <div>
      {children}
      <div className="grid grid-cols-2">
        {team}
        {analytics}
      </div>
    </div>
  );
}
```

## Intercepting Routes

| Convención | Intercepta |
|------------|------------|
| `(.)` | Mismo nivel |
| `(..)` | Un nivel arriba |
| `(..)(..)` | Dos niveles arriba |
| `(...)` | Desde root |

```
app/
├── feed/
│   └── page.tsx
├── photo/
│   └── [id]/
│       └── page.tsx        → /photo/123 (página completa)
└── @modal/
    └── (.)photo/
        └── [id]/
            └── page.tsx    → Intercepta /photo/123 como modal
```

## Navegación

### Link component

```tsx
import Link from 'next/link';

// Básico
<Link href="/about">About</Link>

// Con parámetros
<Link href={`/blog/${post.slug}`}>Read more</Link>

// Sin prefetch
<Link href="/heavy" prefetch={false}>Heavy page</Link>

// Scroll to top disabled
<Link href="/page" scroll={false}>No scroll</Link>

// Replace history
<Link href="/new" replace>Replace</Link>
```

### Programmatic navigation

```tsx
'use client';
import { useRouter } from 'next/navigation';

function Component() {
  const router = useRouter();

  // Navegar
  router.push('/dashboard');

  // Reemplazar (sin agregar a history)
  router.replace('/login');

  // Refresh (revalidar data)
  router.refresh();

  // Volver
  router.back();

  // Adelante
  router.forward();
}
```

### usePathname y useSearchParams

```tsx
'use client';
import { usePathname, useSearchParams } from 'next/navigation';

function Component() {
  const pathname = usePathname();
  // /dashboard/settings

  const searchParams = useSearchParams();
  // ?tab=general → searchParams.get('tab') = 'general'
}
```

## Metadata

### Estática

```tsx
export const metadata = {
  title: 'My Page',
  description: 'Page description',
};
```

### Dinámica

```tsx
export async function generateMetadata({ params }) {
  const post = await getPost(params.id);
  return {
    title: post.title,
    openGraph: {
      images: [post.image],
    },
  };
}
```

### Template de título

```tsx
// layout.tsx
export const metadata = {
  title: {
    template: '%s | My Site',
    default: 'My Site',
  },
};

// page.tsx
export const metadata = {
  title: 'About', // → "About | My Site"
};
```

## Generación estática

```tsx
// Pre-generar rutas dinámicas
export async function generateStaticParams() {
  const posts = await getPosts();
  return posts.map(post => ({
    slug: post.slug,
  }));
}
```

## Redirecciones

```tsx
// En Server Component
import { redirect } from 'next/navigation';

async function Page() {
  const user = await getUser();
  if (!user) {
    redirect('/login');
  }
}
```

```tsx
// En next.config.js
module.exports = {
  async redirects() {
    return [
      {
        source: '/old-path',
        destination: '/new-path',
        permanent: true, // 308
      },
    ];
  },
};
```

## Rewrites

```tsx
// next.config.js
module.exports = {
  async rewrites() {
    return [
      {
        source: '/api/:path*',
        destination: 'https://api.example.com/:path*',
      },
    ];
  },
};
```

## Route Handlers (API)

```tsx
// app/api/posts/route.ts
import { NextResponse } from 'next/server';

export async function GET() {
  const posts = await getPosts();
  return NextResponse.json(posts);
}

export async function POST(request: Request) {
  const body = await request.json();
  const post = await createPost(body);
  return NextResponse.json(post, { status: 201 });
}
```

### Rutas dinámicas

```tsx
// app/api/posts/[id]/route.ts
export async function GET(
  request: Request,
  { params }: { params: { id: string } }
) {
  const post = await getPost(params.id);
  return NextResponse.json(post);
}
```

## Cookies y Headers

```tsx
import { cookies, headers } from 'next/headers';

// En Server Component o Route Handler
const cookieStore = cookies();
const token = cookieStore.get('token');

const headersList = headers();
const userAgent = headersList.get('user-agent');
```

## Tips rápidos

1. **Carpetas sin `page.tsx`** = No son rutas, solo organización
2. **`(folder)`** = Grupos que no afectan URL
3. **`_folder`** = Carpetas privadas excluidas del routing
4. **Layouts preservan estado** al navegar entre páginas hijas
5. **Templates se re-renderizan** en cada navegación
6. **`loading.tsx`** usa Suspense automáticamente
7. **`error.tsx`** debe ser Client Component
