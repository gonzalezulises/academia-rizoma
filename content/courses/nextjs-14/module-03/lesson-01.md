# Server vs Client Components

## Introducción

React Server Components (RSC) son el cambio más significativo en React desde los hooks. En Next.js 14, **todos los componentes son Server Components por defecto**. Entender cuándo usar cada tipo es fundamental para construir aplicaciones eficientes.

## El modelo mental

Piensa en tu aplicación como un árbol de componentes dividido en dos zonas:

```
                    ┌─────────────────────────────┐
                    │      SERVER (Servidor)      │
                    │                             │
                    │  ┌─────────────────────┐    │
                    │  │    RootLayout       │    │
                    │  │    (Server)         │    │
                    │  └──────────┬──────────┘    │
                    │             │               │
                    │  ┌──────────┴──────────┐    │
                    │  │    ProductPage      │    │
                    │  │    (Server)         │    │
                    │  └──────────┬──────────┘    │
                    │             │               │
                    └─────────────┼───────────────┘
                                  │
════════════════════════════════════════════════════
                                  │ "use client" boundary
                    ┌─────────────┼───────────────┐
                    │             │               │
                    │  ┌──────────┴──────────┐    │
                    │  │   AddToCartButton   │    │
                    │  │   (Client)          │    │
                    │  └─────────────────────┘    │
                    │                             │
                    │      CLIENT (Navegador)     │
                    └─────────────────────────────┘
```

## Server Components

Son componentes que **solo se ejecutan en el servidor**. Nunca se envía su código JavaScript al navegador.

```tsx
// Este componente se ejecuta SOLO en el servidor
// app/products/page.tsx

import { db } from '@/lib/database';

export default async function ProductsPage() {
  // Acceso directo a la base de datos
  const products = await db.product.findMany({
    include: { category: true },
  });

  // Las secrets están seguras, nunca llegan al cliente
  console.log(process.env.DATABASE_URL); // Solo visible en logs del servidor

  return (
    <div className="grid grid-cols-3 gap-4">
      {products.map(product => (
        <ProductCard key={product.id} product={product} />
      ))}
    </div>
  );
}
```

### Beneficios de Server Components

| Beneficio | Descripción |
|-----------|-------------|
| **Zero bundle size** | El código no se envía al cliente |
| **Acceso directo a datos** | DB, file system, APIs internas |
| **Secrets seguros** | Variables de entorno nunca expuestas |
| **Mejor performance** | Menos JavaScript = carga más rápida |
| **SEO optimizado** | HTML completo para crawlers |

### Lo que pueden hacer

```tsx
// ✅ Server Components PUEDEN:

// 1. Ser funciones async
async function ProductPage() {
  const data = await fetchData();
  return <div>{data}</div>;
}

// 2. Acceder a la base de datos directamente
import { prisma } from '@/lib/prisma';
const users = await prisma.user.findMany();

// 3. Leer el file system
import { readFile } from 'fs/promises';
const content = await readFile('./data.json', 'utf8');

// 4. Usar secrets
const apiKey = process.env.SECRET_API_KEY;

// 5. Hacer fetch sin cache
const data = await fetch(url, { cache: 'no-store' });
```

### Lo que NO pueden hacer

```tsx
// ❌ Server Components NO pueden:

// 1. Usar hooks de React
const [count, setCount] = useState(0);  // Error!
useEffect(() => {}, []);                 // Error!

// 2. Agregar event handlers
<button onClick={handleClick}>           // Error!

// 3. Usar APIs del navegador
localStorage.getItem('key');             // Error!
window.location;                         // Error!

// 4. Usar context (excepto server context)
useContext(ThemeContext);                // Error!
```

## Client Components

Componentes que se ejecutan en el navegador (y también en el servidor para SSR).

```tsx
'use client';  // Esta directiva es OBLIGATORIA

import { useState, useEffect } from 'react';

export function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount(c => c + 1)}>
      Clicks: {count}
    </button>
  );
}
```

### Cuándo usar Client Components

| Caso de uso | Ejemplo |
|-------------|---------|
| Interactividad | `onClick`, `onChange`, forms |
| Estado local | `useState`, `useReducer` |
| Efectos | `useEffect`, `useLayoutEffect` |
| APIs del navegador | `localStorage`, `geolocation` |
| Hooks custom que usan lo anterior | `useForm`, `useMediaQuery` |
| Librerías que requieren interactividad | Framer Motion, React Query |

```tsx
'use client';

import { useState, useEffect } from 'react';

export function ThemeToggle() {
  const [theme, setTheme] = useState<'light' | 'dark'>('light');

  useEffect(() => {
    // Acceso a localStorage
    const saved = localStorage.getItem('theme') as 'light' | 'dark';
    if (saved) setTheme(saved);
  }, []);

  const toggle = () => {
    const newTheme = theme === 'light' ? 'dark' : 'light';
    setTheme(newTheme);
    localStorage.setItem('theme', newTheme);
    document.documentElement.classList.toggle('dark');
  };

  return (
    <button onClick={toggle}>
      {theme === 'light' ? '🌙' : '☀️'}
    </button>
  );
}
```

## Reglas de composición

### 1. Un Client Component NO puede importar Server Components

```tsx
'use client';

// ❌ ERROR - No puedes importar Server Components en Client Components
import { ServerComponent } from './ServerComponent';

export function ClientComponent() {
  return <ServerComponent />;  // Error en build
}
```

### 2. Pero puede recibirlos como children

```tsx
// ✅ CORRECTO - Pasar como children o props

// app/layout.tsx (Server Component)
import { ClientWrapper } from './ClientWrapper';
import { ServerComponent } from './ServerComponent';

export default function Layout() {
  return (
    <ClientWrapper>
      <ServerComponent />  {/* Pre-renderizado en servidor */}
    </ClientWrapper>
  );
}

// components/ClientWrapper.tsx
'use client';

export function ClientWrapper({ children }: { children: React.ReactNode }) {
  const [isOpen, setIsOpen] = useState(true);

  return (
    <div className={isOpen ? 'block' : 'hidden'}>
      {children}  {/* Renderiza el Server Component */}
    </div>
  );
}
```

### 3. La directiva 'use client' crea un boundary

Cuando usas `'use client'`, ese archivo y **todo lo que importa** se vuelve parte del bundle del cliente:

```tsx
'use client';

// Estos módulos se incluyen en el bundle del cliente
import { Button } from './Button';      // Ahora es Client Component
import { utils } from './utils';         // Incluido en bundle
import { heavyLibrary } from 'heavy-lib'; // ⚠️ Todo el peso va al cliente
```

## Patrones recomendados

### Patrón 1: Hojas del árbol como Client Components

```tsx
// app/dashboard/page.tsx (Server Component)
import { getMetrics } from '@/lib/analytics';
import { MetricsChart } from './MetricsChart';  // Client

export default async function DashboardPage() {
  const metrics = await getMetrics();  // Fetch en servidor

  return (
    <div>
      <h1>Dashboard</h1>
      {/* Pasa datos serializables al cliente */}
      <MetricsChart data={metrics} />
    </div>
  );
}

// app/dashboard/MetricsChart.tsx
'use client';

import { LineChart } from 'recharts';

export function MetricsChart({ data }) {
  // Interactividad con la librería de gráficos
  return <LineChart data={data} />;
}
```

### Patrón 2: Server Component wrapper

```tsx
// Fetch datos en Server Component, renderiza en Client

// app/products/[id]/page.tsx
import { ProductDetails } from './ProductDetails';

export default async function ProductPage({ params }) {
  const product = await getProduct(params.id);
  const reviews = await getReviews(params.id);

  return (
    <ProductDetails
      product={product}
      reviews={reviews}
    />
  );
}

// app/products/[id]/ProductDetails.tsx
'use client';

import { useState } from 'react';

export function ProductDetails({ product, reviews }) {
  const [selectedImage, setSelectedImage] = useState(0);

  // Toda la interactividad aquí
  return (
    <div>
      <ImageGallery
        images={product.images}
        selected={selectedImage}
        onSelect={setSelectedImage}
      />
      <ReviewList reviews={reviews} />
    </div>
  );
}
```

### Patrón 3: Composition con slots

```tsx
// components/Modal.tsx
'use client';

import { useState } from 'react';

interface ModalProps {
  trigger: React.ReactNode;
  content: React.ReactNode;  // Puede ser Server Component
}

export function Modal({ trigger, content }: ModalProps) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <>
      <div onClick={() => setIsOpen(true)}>{trigger}</div>
      {isOpen && (
        <div className="modal">
          {content}  {/* Server Component renderizado aquí */}
          <button onClick={() => setIsOpen(false)}>Cerrar</button>
        </div>
      )}
    </>
  );
}

// Uso en Server Component
import { Modal } from './Modal';
import { ProductPreview } from './ProductPreview';  // Server Component

export default async function Page() {
  return (
    <Modal
      trigger={<button>Ver producto</button>}
      content={<ProductPreview />}  // Server Component pasado como prop
    />
  );
}
```

## Serialización: La frontera

Los datos que pasan de Server a Client Components deben ser **serializables** (convertibles a JSON):

```tsx
// ✅ Tipos serializables
const validProps = {
  string: "hello",
  number: 42,
  boolean: true,
  null: null,
  array: [1, 2, 3],
  object: { key: "value" },
  date: new Date().toISOString(),  // Convertido a string
};

// ❌ No serializables
const invalidProps = {
  function: () => {},           // Error!
  class: new MyClass(),         // Error!
  symbol: Symbol('x'),          // Error!
  map: new Map(),               // Error!
  set: new Set(),               // Error!
  undefined: undefined,          // Se pierde
};
```

## Errores comunes

### Error 1: Usar hooks sin 'use client'

```tsx
// ❌ Error: useState no funciona en Server Components
import { useState } from 'react';

export function Counter() {
  const [count, setCount] = useState(0);  // Runtime error!
  return <button>{count}</button>;
}
```

### Error 2: Olvidar que children funciona

```tsx
// ❌ Intentando importar Server Component
'use client';
import { HeavyServerComponent } from './Heavy';

// ✅ Recibirlo como children
'use client';
export function Wrapper({ children }) {
  return <div className="wrapper">{children}</div>;
}
```

### Error 3: Pasar funciones como props

```tsx
// ❌ Las funciones no son serializables
<ClientComponent onSubmit={handleSubmit} />

// ✅ Usar Server Actions en su lugar
<ClientComponent action={submitAction} />
```

## Decisión rápida

```
¿Necesito...?

useState/useEffect/useContext → 'use client'
onClick/onChange/onSubmit    → 'use client'
localStorage/window          → 'use client'
Librería interactiva         → 'use client'

Fetch de datos               → Server Component
Acceso a DB                  → Server Component
Variables de entorno         → Server Component
Renderizado estático         → Server Component
```

## Recursos adicionales

- [React Server Components RFC](https://github.com/reactjs/rfcs/blob/main/text/0188-server-components.md)
- [Next.js: Server and Client Components](https://nextjs.org/docs/app/building-your-application/rendering/server-components)
- [Patterns: Composition](https://nextjs.org/docs/app/building-your-application/rendering/composition-patterns)
