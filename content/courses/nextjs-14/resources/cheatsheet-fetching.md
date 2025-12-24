# Next.js 14 Data Fetching Cheatsheet

## Fetch en Server Components

```tsx
// Básico - cacheado por defecto
async function Page() {
  const data = await fetch('https://api.example.com/data');
  const json = await data.json();
  return <div>{json.title}</div>;
}
```

## Opciones de Cache

| Opción | Comportamiento | Equivalente |
|--------|---------------|-------------|
| `cache: 'force-cache'` | Cachea indefinidamente (default) | SSG |
| `cache: 'no-store'` | Nunca cachea | SSR |
| `next: { revalidate: 60 }` | Revalida cada 60s | ISR |

```tsx
// Sin cache (SSR)
const data = await fetch(url, { cache: 'no-store' });

// Revalidar cada hora (ISR)
const data = await fetch(url, { next: { revalidate: 3600 } });

// Cache con tag para invalidación
const data = await fetch(url, { next: { tags: ['posts'] } });
```

## Revalidación

### Time-based

```tsx
// En la página/layout
export const revalidate = 60; // segundos

// O por fetch individual
fetch(url, { next: { revalidate: 60 } });
```

### On-demand

```tsx
// En Server Action o Route Handler
import { revalidatePath, revalidateTag } from 'next/cache';

// Revalidar ruta específica
revalidatePath('/posts');

// Revalidar layout
revalidatePath('/posts', 'layout');

// Revalidar por tag
revalidateTag('posts');
```

## Patrones de Data Fetching

### Sequential (Waterfall)

```tsx
// ⚠️ Una después de otra
async function Page() {
  const user = await getUser();
  const posts = await getPosts(user.id);
  return <Posts posts={posts} />;
}
```

### Parallel

```tsx
// ✅ Simultáneas
async function Page() {
  const [user, posts] = await Promise.all([
    getUser(),
    getPosts(),
  ]);
  return <div>...</div>;
}
```

### Preload Pattern

```tsx
// lib/data.ts
import { cache } from 'react';

export const getUser = cache(async (id: string) => {
  return db.user.findUnique({ where: { id } });
});

export const preloadUser = (id: string) => {
  void getUser(id);
};

// En layout (inicia fetch temprano)
export default function Layout({ params }) {
  preloadUser(params.id);
  return <>{children}</>;
}

// En page (usa el cache)
export default async function Page({ params }) {
  const user = await getUser(params.id);
  return <Profile user={user} />;
}
```

## Streaming con Suspense

```tsx
import { Suspense } from 'react';

export default function Page() {
  return (
    <div>
      <h1>Dashboard</h1>

      <Suspense fallback={<CardSkeleton />}>
        <RevenueCard />
      </Suspense>

      <Suspense fallback={<ChartSkeleton />}>
        <SalesChart />
      </Suspense>
    </div>
  );
}

// Los componentes async se renderizan independientemente
async function RevenueCard() {
  const revenue = await getRevenue();
  return <Card>{revenue}</Card>;
}
```

## loading.tsx automático

```tsx
// app/dashboard/loading.tsx
export default function Loading() {
  return <DashboardSkeleton />;
}

// Equivale a:
<Suspense fallback={<DashboardSkeleton />}>
  <DashboardPage />
</Suspense>
```

## React cache()

```tsx
import { cache } from 'react';

// Deduplicación automática en el mismo render
export const getUser = cache(async (id: string) => {
  const res = await fetch(`/api/users/${id}`);
  return res.json();
});

// Múltiples componentes pueden llamar getUser(id)
// Solo se ejecuta una vez por request
```

## unstable_cache (Next.js)

```tsx
import { unstable_cache } from 'next/cache';

const getCachedUser = unstable_cache(
  async (id: string) => {
    return db.user.findUnique({ where: { id } });
  },
  ['user-cache'], // cache key
  {
    tags: ['users'],
    revalidate: 3600,
  }
);
```

## Server Actions

```tsx
'use server';

import { revalidatePath } from 'next/cache';

export async function createPost(formData: FormData) {
  await db.post.create({
    data: { title: formData.get('title') as string },
  });

  // Revalidar después de mutación
  revalidatePath('/posts');
}
```

## Fetching en Client Components

```tsx
'use client';

import useSWR from 'swr';

const fetcher = (url: string) => fetch(url).then(r => r.json());

export function ClientComponent() {
  const { data, error, isLoading } = useSWR('/api/data', fetcher);

  if (isLoading) return <Spinner />;
  if (error) return <Error />;
  return <div>{data.title}</div>;
}
```

## Patrones de Error

```tsx
// Throw para activar error.tsx
async function Page() {
  const res = await fetch(url);

  if (!res.ok) {
    throw new Error('Failed to fetch');
  }

  return <div>...</div>;
}

// notFound() para 404
import { notFound } from 'next/navigation';

async function Page({ params }) {
  const post = await getPost(params.id);

  if (!post) {
    notFound();
  }

  return <Post post={post} />;
}
```

## Tipos de Renderizado

| Tipo | Cuándo se genera | Cache | Uso |
|------|-----------------|-------|-----|
| Static | Build time | CDN | Blog, docs |
| Dynamic | Request time | No | Dashboard personalizado |
| ISR | Build + revalidate | CDN + tiempo | E-commerce, noticias |
| Streaming | Request time | Parcial | UI progresiva |

## Opt-out de Static Rendering

```tsx
// Cualquiera de estos hace la página dinámica:

// 1. cookies() o headers()
import { cookies } from 'next/headers';

// 2. searchParams en page
export default function Page({ searchParams }) {}

// 3. cache: 'no-store'
fetch(url, { cache: 'no-store' });

// 4. export const dynamic
export const dynamic = 'force-dynamic';

// 5. export const revalidate = 0
export const revalidate = 0;
```

## Segment Config Options

```tsx
// Forzar estático
export const dynamic = 'force-static';
export const revalidate = false;

// Forzar dinámico
export const dynamic = 'force-dynamic';
export const revalidate = 0;

// Runtime
export const runtime = 'edge'; // o 'nodejs'

// Región preferida
export const preferredRegion = 'iad1';
```

## Quick Reference

```tsx
// SSG (Static)
const data = await fetch(url);
// or
export const dynamic = 'force-static';

// SSR (Dynamic)
const data = await fetch(url, { cache: 'no-store' });
// or
export const dynamic = 'force-dynamic';

// ISR (Incremental)
const data = await fetch(url, { next: { revalidate: 60 } });
// or
export const revalidate = 60;
```
