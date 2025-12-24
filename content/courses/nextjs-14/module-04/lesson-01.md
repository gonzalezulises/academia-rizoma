# Introducción a Server Actions

## Introducción

Server Actions son funciones asíncronas que se ejecutan en el servidor y pueden ser invocadas desde componentes cliente. Representan un cambio de paradigma: **mutaciones sin API routes**.

## El problema que resuelven

### Antes: API Routes tradicionales

```tsx
// Necesitabas 3 archivos para un simple formulario:

// 1. API Route
// app/api/todos/route.ts
export async function POST(request: Request) {
  const body = await request.json();
  const todo = await db.todo.create({ data: body });
  return Response.json(todo);
}

// 2. Función cliente para llamar la API
// lib/api.ts
export async function createTodo(data: TodoInput) {
  const res = await fetch('/api/todos', {
    method: 'POST',
    body: JSON.stringify(data),
  });
  return res.json();
}

// 3. Componente con el formulario
// components/TodoForm.tsx
'use client';
import { createTodo } from '@/lib/api';

export function TodoForm() {
  const handleSubmit = async (e) => {
    e.preventDefault();
    await createTodo({ title: e.target.title.value });
  };
  // ...
}
```

### Ahora: Server Actions

```tsx
// Todo en un solo archivo:

// app/todos/actions.ts
'use server';

export async function createTodo(formData: FormData) {
  const title = formData.get('title') as string;
  await db.todo.create({ data: { title } });
  revalidatePath('/todos');
}

// app/todos/page.tsx
import { createTodo } from './actions';

export default function TodosPage() {
  return (
    <form action={createTodo}>
      <input name="title" required />
      <button type="submit">Agregar</button>
    </form>
  );
}
```

## Definiendo Server Actions

### Opción 1: Archivo separado con 'use server'

```tsx
// app/actions.ts
'use server';  // Marca TODO el archivo como Server Actions

import { db } from '@/lib/db';
import { revalidatePath } from 'next/cache';

export async function createPost(formData: FormData) {
  const title = formData.get('title') as string;
  const content = formData.get('content') as string;

  await db.post.create({
    data: { title, content },
  });

  revalidatePath('/posts');
}

export async function deletePost(id: string) {
  await db.post.delete({ where: { id } });
  revalidatePath('/posts');
}
```

### Opción 2: Inline en Server Component

```tsx
// app/posts/page.tsx (Server Component)
import { db } from '@/lib/db';
import { revalidatePath } from 'next/cache';

export default async function PostsPage() {
  // Server Action definida inline
  async function createPost(formData: FormData) {
    'use server';  // Marca esta función específica

    const title = formData.get('title') as string;
    await db.post.create({ data: { title } });
    revalidatePath('/posts');
  }

  const posts = await db.post.findMany();

  return (
    <div>
      <form action={createPost}>
        <input name="title" />
        <button>Crear</button>
      </form>

      <ul>
        {posts.map(post => (
          <li key={post.id}>{post.title}</li>
        ))}
      </ul>
    </div>
  );
}
```

## Usando Server Actions en formularios

### Formulario básico

```tsx
// app/contact/page.tsx
import { sendMessage } from './actions';

export default function ContactPage() {
  return (
    <form action={sendMessage}>
      <input name="email" type="email" required />
      <textarea name="message" required />
      <button type="submit">Enviar</button>
    </form>
  );
}

// app/contact/actions.ts
'use server';

export async function sendMessage(formData: FormData) {
  const email = formData.get('email') as string;
  const message = formData.get('message') as string;

  await sendEmail({
    to: 'contact@example.com',
    from: email,
    body: message,
  });

  // Opcional: redirigir después
  redirect('/contact/success');
}
```

### Con argumentos adicionales usando bind

```tsx
// Cuando necesitas pasar datos extra además del formData

'use server';

export async function updatePost(postId: string, formData: FormData) {
  const title = formData.get('title') as string;

  await db.post.update({
    where: { id: postId },
    data: { title },
  });

  revalidatePath('/posts');
}

// En el componente
import { updatePost } from './actions';

export function EditPostForm({ post }) {
  // bind() precompila el primer argumento
  const updateWithId = updatePost.bind(null, post.id);

  return (
    <form action={updateWithId}>
      <input name="title" defaultValue={post.title} />
      <button>Guardar</button>
    </form>
  );
}
```

## Usando Server Actions fuera de formularios

Puedes llamar Server Actions como funciones normales desde Client Components:

```tsx
'use client';

import { useState, useTransition } from 'react';
import { likePost } from './actions';

export function LikeButton({ postId }: { postId: string }) {
  const [isPending, startTransition] = useTransition();
  const [likes, setLikes] = useState(0);

  const handleClick = () => {
    startTransition(async () => {
      const newLikes = await likePost(postId);
      setLikes(newLikes);
    });
  };

  return (
    <button onClick={handleClick} disabled={isPending}>
      {isPending ? '...' : `❤️ ${likes}`}
    </button>
  );
}

// actions.ts
'use server';

export async function likePost(postId: string): Promise<number> {
  const post = await db.post.update({
    where: { id: postId },
    data: { likes: { increment: 1 } },
  });

  return post.likes;
}
```

## Progressive Enhancement

Los formularios con Server Actions funcionan **sin JavaScript**:

```tsx
// Este formulario funciona aunque JS esté deshabilitado
<form action={createTodo}>
  <input name="title" />
  <button>Crear</button>
</form>
```

Cuando JS está habilitado, Next.js intercepta el submit y:
1. Previene el reload de página
2. Envía la request vía fetch
3. Actualiza la UI sin navegación

## Retornando datos

Las Server Actions pueden retornar valores serializables:

```tsx
'use server';

export async function createUser(formData: FormData) {
  const email = formData.get('email') as string;

  const existing = await db.user.findUnique({ where: { email } });
  if (existing) {
    return { error: 'El email ya está registrado' };
  }

  const user = await db.user.create({
    data: { email },
  });

  return { success: true, userId: user.id };
}
```

Usando el resultado en el cliente:

```tsx
'use client';

import { useActionState } from 'react';
import { createUser } from './actions';

export function SignupForm() {
  const [state, action, isPending] = useActionState(createUser, null);

  return (
    <form action={action}>
      <input name="email" type="email" />
      <button disabled={isPending}>
        {isPending ? 'Creando...' : 'Registrar'}
      </button>

      {state?.error && (
        <p className="text-red-500">{state.error}</p>
      )}

      {state?.success && (
        <p className="text-green-500">Usuario creado!</p>
      )}
    </form>
  );
}
```

## Seguridad

### Siempre valida los datos

```tsx
'use server';

import { z } from 'zod';

const CreatePostSchema = z.object({
  title: z.string().min(1).max(100),
  content: z.string().min(10),
});

export async function createPost(formData: FormData) {
  const rawData = {
    title: formData.get('title'),
    content: formData.get('content'),
  };

  // Validar con Zod
  const result = CreatePostSchema.safeParse(rawData);

  if (!result.success) {
    return { error: result.error.flatten() };
  }

  // Datos validados y tipados
  await db.post.create({ data: result.data });
}
```

### Siempre verifica autenticación

```tsx
'use server';

import { auth } from '@/lib/auth';

export async function deletePost(postId: string) {
  const session = await auth();

  if (!session) {
    throw new Error('No autorizado');
  }

  // Verificar que el usuario sea el dueño
  const post = await db.post.findUnique({
    where: { id: postId },
  });

  if (post?.authorId !== session.user.id) {
    throw new Error('No tienes permiso para eliminar este post');
  }

  await db.post.delete({ where: { id: postId } });
  revalidatePath('/posts');
}
```

## Patrones comunes

### Patrón: Loading state con useFormStatus

```tsx
'use client';

import { useFormStatus } from 'react-dom';

function SubmitButton() {
  const { pending } = useFormStatus();

  return (
    <button type="submit" disabled={pending}>
      {pending ? 'Enviando...' : 'Enviar'}
    </button>
  );
}

// Uso
<form action={submitAction}>
  <input name="email" />
  <SubmitButton />  {/* Debe estar DENTRO del form */}
</form>
```

### Patrón: Múltiples acciones en un formulario

```tsx
// actions.ts
'use server';

export async function saveAsDraft(formData: FormData) {
  // guardar como borrador
}

export async function publish(formData: FormData) {
  // publicar
}

// Componente
import { saveAsDraft, publish } from './actions';

export function PostEditor() {
  return (
    <form>
      <input name="title" />
      <textarea name="content" />

      <button formAction={saveAsDraft}>Guardar borrador</button>
      <button formAction={publish}>Publicar</button>
    </form>
  );
}
```

## Comparación: Server Actions vs API Routes

| Aspecto | Server Actions | API Routes |
|---------|---------------|------------|
| Archivo | `'use server'` | `app/api/.../route.ts` |
| Invocación | `action={fn}` o llamada directa | `fetch('/api/...')` |
| Tipado | End-to-end automático | Manual |
| Progressive Enhancement | ✅ Sí | ❌ No |
| Uso externo | ❌ No (solo mismo origin) | ✅ Sí |
| Webhooks | ❌ No | ✅ Sí |

**Usa Server Actions para**: Formularios, mutaciones internas, acciones de usuario.

**Usa API Routes para**: Webhooks, APIs públicas, integraciones externas.

## Errores comunes

### Error 1: Olvidar 'use server'

```tsx
// ❌ Error: no es una Server Action sin la directiva
export async function createPost(formData: FormData) {
  await db.post.create({ ... });
}

// ✅ Correcto
'use server';

export async function createPost(formData: FormData) {
  await db.post.create({ ... });
}
```

### Error 2: Usar en Client Component sin importar

```tsx
'use client';

// ❌ No puedes definir Server Actions en Client Components
async function createPost(formData: FormData) {
  'use server';  // Error!
}

// ✅ Importa desde archivo con 'use server'
import { createPost } from './actions';
```

## Recursos adicionales

- [Next.js Server Actions](https://nextjs.org/docs/app/building-your-application/data-fetching/server-actions-and-mutations)
- [React useActionState](https://react.dev/reference/react/useActionState)
- [Progressive Enhancement](https://developer.mozilla.org/en-US/docs/Glossary/Progressive_Enhancement)
