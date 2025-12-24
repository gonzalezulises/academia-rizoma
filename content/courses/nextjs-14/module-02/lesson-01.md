# Rutas estáticas y dinámicas

## Introducción

El sistema de rutas de Next.js es **file-based**: la estructura de carpetas define las URLs de tu aplicación. En esta lección dominarás rutas estáticas, dinámicas, catch-all y grupos de rutas.

## Rutas estáticas

Las rutas más simples son las estáticas, donde cada carpeta representa un segmento de URL fijo:

```
app/
├── page.tsx              → /
├── about/
│   └── page.tsx          → /about
├── contact/
│   └── page.tsx          → /contact
└── services/
    ├── page.tsx          → /services
    ├── consulting/
    │   └── page.tsx      → /services/consulting
    └── development/
        └── page.tsx      → /services/development
```

Cada `page.tsx` es el contenido de esa ruta. Sin `page.tsx`, la carpeta solo sirve para organización.

## Rutas dinámicas con [param]

Para rutas que varían (como `/products/1`, `/products/2`), usamos corchetes:

```
app/
└── products/
    ├── page.tsx              → /products
    └── [id]/
        └── page.tsx          → /products/:id
```

### Accediendo al parámetro

```tsx
// app/products/[id]/page.tsx
interface ProductPageProps {
  params: { id: string };
}

export default function ProductPage({ params }: ProductPageProps) {
  return (
    <div>
      <h1>Producto #{params.id}</h1>
    </div>
  );
}
```

### Con async params (Next.js 15+)

```tsx
// app/products/[id]/page.tsx
interface ProductPageProps {
  params: Promise<{ id: string }>;
}

export default async function ProductPage({ params }: ProductPageProps) {
  const { id } = await params;

  const product = await getProduct(id);

  return (
    <div>
      <h1>{product.name}</h1>
    </div>
  );
}
```

## Múltiples parámetros dinámicos

Puedes tener varios segmentos dinámicos:

```
app/
└── blog/
    └── [year]/
        └── [month]/
            └── [slug]/
                └── page.tsx    → /blog/2024/01/mi-post
```

```tsx
// app/blog/[year]/[month]/[slug]/page.tsx
interface BlogPostProps {
  params: {
    year: string;
    month: string;
    slug: string;
  };
}

export default function BlogPost({ params }: BlogPostProps) {
  const { year, month, slug } = params;

  return (
    <article>
      <time>{year}/{month}</time>
      <h1>{slug}</h1>
    </article>
  );
}
```

## Catch-all routes con [...param]

Para capturar múltiples segmentos de URL:

```
app/
└── docs/
    └── [...slug]/
        └── page.tsx    → /docs/a, /docs/a/b, /docs/a/b/c
```

```tsx
// app/docs/[...slug]/page.tsx
interface DocsPageProps {
  params: { slug: string[] };
}

export default function DocsPage({ params }: DocsPageProps) {
  // /docs/react/hooks/usestate → slug = ['react', 'hooks', 'usestate']

  const breadcrumbs = params.slug.join(' > ');

  return (
    <div>
      <nav>{breadcrumbs}</nav>
      <DocContent path={params.slug.join('/')} />
    </div>
  );
}
```

### Optional catch-all con [[...param]]

Los dobles corchetes hacen el parámetro opcional:

```
app/
└── shop/
    └── [[...categories]]/
        └── page.tsx
```

| URL | categories |
|-----|------------|
| `/shop` | `undefined` |
| `/shop/clothing` | `['clothing']` |
| `/shop/clothing/shirts` | `['clothing', 'shirts']` |

```tsx
// app/shop/[[...categories]]/page.tsx
interface ShopPageProps {
  params: { categories?: string[] };
}

export default function ShopPage({ params }: ShopPageProps) {
  const categories = params.categories || [];

  if (categories.length === 0) {
    return <AllProductsPage />;
  }

  return <CategoryPage categories={categories} />;
}
```

## Grupos de rutas con (folder)

Los paréntesis crean grupos que **no afectan la URL**:

```
app/
├── (marketing)/
│   ├── layout.tsx        # Layout solo para marketing
│   ├── page.tsx          → /
│   ├── about/
│   │   └── page.tsx      → /about
│   └── pricing/
│       └── page.tsx      → /pricing
├── (dashboard)/
│   ├── layout.tsx        # Layout diferente para dashboard
│   ├── dashboard/
│   │   └── page.tsx      → /dashboard
│   └── settings/
│       └── page.tsx      → /settings
└── layout.tsx            # Layout raíz
```

Beneficios:
- Organizar código por contexto
- Layouts diferentes para secciones
- Separar lógica de autenticación

### Ejemplo práctico: Auth vs App

```
app/
├── (auth)/
│   ├── layout.tsx        # Layout sin navbar
│   ├── login/
│   │   └── page.tsx      → /login
│   └── register/
│       └── page.tsx      → /register
├── (app)/
│   ├── layout.tsx        # Layout con navbar y sidebar
│   ├── dashboard/
│   │   └── page.tsx      → /dashboard
│   └── profile/
│       └── page.tsx      → /profile
└── layout.tsx
```

```tsx
// app/(auth)/layout.tsx
export default function AuthLayout({ children }) {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full">
        {children}
      </div>
    </div>
  );
}

// app/(app)/layout.tsx
export default function AppLayout({ children }) {
  return (
    <div className="flex">
      <Sidebar />
      <main className="flex-1 p-8">
        <Navbar />
        {children}
      </main>
    </div>
  );
}
```

## Rutas privadas con _folder

Carpetas que empiezan con `_` son excluidas del routing:

```
app/
├── _components/          # No es una ruta
│   ├── Button.tsx
│   └── Card.tsx
├── _lib/                 # No es una ruta
│   └── utils.ts
└── dashboard/
    └── page.tsx          → /dashboard
```

## Generación estática de rutas dinámicas

Para pre-generar páginas dinámicas en build time:

```tsx
// app/products/[id]/page.tsx
export async function generateStaticParams() {
  const products = await getProducts();

  return products.map((product) => ({
    id: product.id.toString(),
  }));
}

export default async function ProductPage({ params }) {
  const product = await getProduct(params.id);
  return <ProductDetails product={product} />;
}
```

Next.js generará una página estática para cada producto retornado.

## Query params y searchParams

Además de los params de ruta, puedes acceder a query strings:

```tsx
// app/search/page.tsx
// URL: /search?q=laptop&category=electronics

interface SearchPageProps {
  searchParams: { q?: string; category?: string };
}

export default function SearchPage({ searchParams }: SearchPageProps) {
  const { q, category } = searchParams;

  return (
    <div>
      <h1>Resultados para: {q}</h1>
      <p>Categoría: {category}</p>
      <SearchResults query={q} category={category} />
    </div>
  );
}
```

## Tabla de resumen

| Patrón | Ejemplo | Matchea |
|--------|---------|---------|
| `[id]` | `/products/[id]` | `/products/1`, `/products/abc` |
| `[...slug]` | `/docs/[...slug]` | `/docs/a`, `/docs/a/b/c` |
| `[[...slug]]` | `/shop/[[...slug]]` | `/shop`, `/shop/a`, `/shop/a/b` |
| `(group)` | `/(auth)/login` | `/login` (no afecta URL) |
| `_private` | `/_lib/utils` | No matchea (excluido) |

## Errores comunes

### Error 1: Orden de rutas importa

```
app/
├── users/
│   ├── [id]/
│   │   └── page.tsx
│   └── new/              # ¿Qué pasa con /users/new?
│       └── page.tsx
```

Next.js prioriza rutas específicas (`/users/new`) sobre dinámicas (`/users/[id]`).

### Error 2: Params siempre son strings

```tsx
// ❌ Error común
const product = await getProduct(params.id);  // params.id es string

// ✅ Correcto
const product = await getProduct(parseInt(params.id));
```

### Error 3: Olvidar validatecatch-all vacío

```tsx
// app/shop/[[...categories]]/page.tsx
// ❌ Error si categories es undefined
const firstCategory = params.categories[0];

// ✅ Correcto
const categories = params.categories || [];
const firstCategory = categories[0];
```

## Ejercicio práctico

Crea la siguiente estructura de rutas:

1. `/` - Página principal
2. `/products` - Lista de productos
3. `/products/[id]` - Detalle de producto
4. `/categories/[...path]` - Categorías anidadas
5. `(admin)/dashboard` - Dashboard admin
6. `(admin)/users/[id]` - Editar usuario

## Recursos adicionales

- [Next.js Routing Fundamentals](https://nextjs.org/docs/app/building-your-application/routing)
- [Dynamic Routes](https://nextjs.org/docs/app/building-your-application/routing/dynamic-routes)
- [Route Groups](https://nextjs.org/docs/app/building-your-application/routing/route-groups)
