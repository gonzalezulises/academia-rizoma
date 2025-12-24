# ¿Por qué Next.js? El problema que resuelve

## Introducción

Si vienes del mundo de React, probablemente has construido SPAs (Single Page Applications) con Create React App o Vite. Estas herramientas son excelentes para muchos casos, pero cuando tu aplicación necesita SEO, mejor performance inicial, o capacidades de servidor, te encuentras con limitaciones fundamentales.

Next.js no es solo "React con extras". Es un **framework de producción** que resuelve problemas reales que enfrentan los equipos al escalar aplicaciones React.

## El problema con Client-Side Rendering (CSR)

En una aplicación React tradicional, el flujo es:

1. El servidor envía un HTML casi vacío
2. El navegador descarga el bundle de JavaScript
3. React ejecuta y renderiza la UI
4. La aplicación se vuelve interactiva

```html
<!-- Lo que recibe el navegador inicialmente -->
<!DOCTYPE html>
<html>
  <head>
    <title>Mi App</title>
  </head>
  <body>
    <div id="root"></div>
    <script src="/static/js/bundle.js"></script>
  </body>
</html>
```

### Problemas de CSR

**1. SEO deficiente**

Los crawlers de Google pueden ejecutar JavaScript, pero no todos lo hacen bien. Otros motores de búsqueda y redes sociales (Twitter, LinkedIn) muestran previews vacíos porque leen el HTML inicial.

**2. Tiempo hasta contenido visible (LCP)**

El usuario ve una pantalla en blanco mientras:
- Se descarga el bundle JS (puede ser varios MB)
- Se parsea y ejecuta JavaScript
- React renderiza el DOM

En conexiones lentas o dispositivos modestos, esto puede tomar varios segundos.

**3. Waterfalls de datos**

```jsx
// Patrón común en CSR - waterfall de requests
function ProductPage() {
  const [product, setProduct] = useState(null);
  const [reviews, setReviews] = useState([]);

  useEffect(() => {
    // Request 1: obtener producto
    fetch('/api/product/123')
      .then(res => res.json())
      .then(data => {
        setProduct(data);
        // Request 2: solo después de tener el producto
        fetch(`/api/reviews?productId=${data.id}`)
          .then(res => res.json())
          .then(setReviews);
      });
  }, []);

  if (!product) return <Spinner />;
  // ...
}
```

El componente primero debe renderizar, luego hacer fetch, luego renderizar de nuevo. Es ineficiente.

## Server-Side Rendering (SSR) al rescate

Con SSR, el servidor genera HTML completo antes de enviarlo:

```jsx
// En Next.js, el servidor ejecuta esto
async function ProductPage({ params }) {
  // Fetch en el servidor - sin waterfall
  const product = await getProduct(params.id);
  const reviews = await getReviews(params.id);

  return (
    <div>
      <h1>{product.name}</h1>
      <p>{product.description}</p>
      <ReviewList reviews={reviews} />
    </div>
  );
}
```

El navegador recibe HTML listo para mostrar:

```html
<!DOCTYPE html>
<html>
  <body>
    <div id="root">
      <div>
        <h1>iPhone 15 Pro</h1>
        <p>El smartphone más avanzado...</p>
        <ul class="reviews">
          <li>Excelente producto - ★★★★★</li>
          <!-- más reviews -->
        </ul>
      </div>
    </div>
  </body>
</html>
```

## Static Site Generation (SSG)

Para contenido que no cambia frecuentemente, podemos generar HTML en **build time**:

```jsx
// Esta página se genera una vez al hacer build
export default async function BlogPost({ params }) {
  const post = await getPost(params.slug);
  return <Article content={post} />;
}

// Next.js genera estas páginas estáticamente
export async function generateStaticParams() {
  const posts = await getAllPosts();
  return posts.map(post => ({ slug: post.slug }));
}
```

Beneficios de SSG:
- **Performance máxima**: HTML servido desde CDN global
- **Costos reducidos**: Sin servidor procesando cada request
- **Escalabilidad infinita**: CDNs manejan millones de requests

## Incremental Static Regeneration (ISR)

ISR combina lo mejor de SSG y SSR:

```jsx
// Regenera la página cada 60 segundos
export const revalidate = 60;

export default async function PricingPage() {
  const prices = await fetchPrices();
  return <PriceTable prices={prices} />;
}
```

La primera request sirve contenido cacheado. En background, Next.js regenera la página si pasó el tiempo de revalidación.

## Hidratación: El puente entre servidor y cliente

Cuando el servidor envía HTML pre-renderizado, React necesita "tomar control" de ese HTML para hacerlo interactivo. Este proceso se llama **hidratación**.

```jsx
// Componente que necesita interactividad
'use client'

export function AddToCartButton({ productId }) {
  const [loading, setLoading] = useState(false);

  async function handleClick() {
    setLoading(true);
    await addToCart(productId);
    setLoading(false);
  }

  return (
    <button onClick={handleClick} disabled={loading}>
      {loading ? 'Agregando...' : 'Agregar al carrito'}
    </button>
  );
}
```

El HTML del botón viene del servidor, pero el `onClick` se adjunta durante la hidratación.

## Por qué Next.js 14 específicamente

Next.js 14 con App Router introduce:

| Feature | Beneficio |
|---------|-----------|
| React Server Components | Componentes que nunca envían JS al cliente |
| Streaming | Envío progresivo de HTML |
| Server Actions | Mutaciones sin API routes |
| Parallel Routes | Múltiples páginas en una vista |
| Partial Prerendering | Lo mejor de SSR y SSG combinados |

## Cuándo NO usar Next.js

Next.js no es la mejor opción para:

- **SPAs puras detrás de login**: Si no necesitas SEO y toda tu app requiere autenticación, un SPA puede ser más simple
- **Aplicaciones tipo Figma/Photoshop**: Apps altamente interactivas donde SSR no aporta valor
- **Prototipos rápidos**: Para un MVP de un día, Vite puede ser más rápido de configurar

## Errores comunes

### Error 1: Pensar que SSR siempre es mejor
SSR tiene overhead. Si tu página es altamente dinámica y personalizada por usuario, el caching es difícil y puedes terminar con peor performance que CSR.

### Error 2: No entender el costo de hidratación
El HTML pre-renderizado es solo la mitad. Si tu bundle JS es enorme, la hidratación será lenta. Next.js 14 mitiga esto con Server Components.

### Error 3: Ignorar la estrategia de caching
Next.js 14 cachea agresivamente. Si no entiendes cómo funciona, verás datos stale y comportamientos inesperados.

## Resumen

| Estrategia | Generación | Cache | Uso ideal |
|------------|------------|-------|-----------|
| CSR | Cliente | - | Apps autenticadas, dashboards |
| SSR | Servidor (cada request) | Por request | Contenido dinámico, personalizado |
| SSG | Build time | CDN | Blogs, documentación, landing pages |
| ISR | Build + revalidación | CDN + tiempo | E-commerce, noticias |

Next.js te permite elegir la estrategia **por ruta**, optimizando cada parte de tu aplicación según sus necesidades.

## Recursos adicionales

- [Documentación oficial de Next.js](https://nextjs.org/docs)
- [React Server Components RFC](https://github.com/reactjs/rfcs/blob/main/text/0188-server-components.md)
- [Web.dev: Rendering patterns](https://web.dev/rendering-on-the-web/)
