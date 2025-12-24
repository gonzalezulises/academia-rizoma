# Estrategias de autenticación

## Introducción

La autenticación en aplicaciones modernas tiene múltiples enfoques. Elegir el correcto depende de tu arquitectura, requisitos de seguridad y experiencia de usuario deseada.

## JWT vs Sessions

### JSON Web Tokens (JWT)

Los JWT son tokens auto-contenidos que incluyen toda la información del usuario codificada.

```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.
eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4iLCJpYXQiOjE1MTYyMzkwMjJ9.
SflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c
```

**Estructura:**
1. **Header**: Algoritmo y tipo de token
2. **Payload**: Claims (datos del usuario)
3. **Signature**: Verificación de integridad

```tsx
// Decodificando un JWT (payload)
{
  "sub": "user_123",           // Subject (user ID)
  "email": "user@example.com",
  "role": "admin",
  "iat": 1704067200,           // Issued at
  "exp": 1704153600            // Expires at
}
```

**Ventajas de JWT:**
- **Stateless**: No requiere storage en servidor
- **Escalable**: Cualquier servidor puede validar
- **Cross-domain**: Funciona entre diferentes dominios
- **Mobile-friendly**: Fácil de almacenar en apps nativas

**Desventajas:**
- **No revocable**: Una vez emitido, válido hasta expirar
- **Tamaño**: Más grande que un session ID
- **Storage**: Si se almacena mal, vulnerable a XSS

### Sessions (Cookies)

Las sessions almacenan los datos en el servidor y envían solo un ID al cliente.

```
Cliente                         Servidor
   │                               │
   │ ── Login (credentials) ────> │
   │                               │ Crea session en DB/Redis
   │ <── Set-Cookie: sid=abc123 ──│
   │                               │
   │ ── Request + Cookie ────────>│
   │                               │ Busca session por ID
   │ <── Response + user data ────│
```

**Ventajas de Sessions:**
- **Revocable**: Puedes invalidar al instante
- **Seguro**: Solo un ID viaja, datos en servidor
- **Pequeño**: Cookie minimal
- **HttpOnly**: Protegido contra XSS

**Desventajas:**
- **Stateful**: Requiere storage centralizado
- **Escalabilidad**: Necesita session store compartido
- **Latencia**: Lookup en cada request

## Comparación directa

| Aspecto | JWT | Sessions |
|---------|-----|----------|
| Storage servidor | ❌ No | ✅ Sí |
| Revocación | ❌ Difícil | ✅ Inmediata |
| Escalabilidad | ✅ Fácil | ⚠️ Requiere Redis/DB |
| Tamaño | ⚠️ Grande | ✅ Pequeño |
| Cross-domain | ✅ Fácil | ⚠️ Complejo |
| Seguridad XSS | ⚠️ Cuidado con storage | ✅ HttpOnly cookies |

## Estrategia híbrida (recomendada)

Next.js con Auth.js usa un enfoque híbrido:

1. **JWT para stateless**: Token encriptado en cookie
2. **Database sessions opcional**: Para revocación y datos extensos

```tsx
// auth.config.ts
export const authConfig = {
  session: {
    strategy: 'jwt', // o 'database'
    maxAge: 30 * 24 * 60 * 60, // 30 días
  },
  // ...
};
```

## Providers de autenticación

### 1. Credentials (Email/Password)

```tsx
import Credentials from 'next-auth/providers/credentials';
import bcrypt from 'bcryptjs';

export const authConfig = {
  providers: [
    Credentials({
      name: 'credentials',
      credentials: {
        email: { label: 'Email', type: 'email' },
        password: { label: 'Password', type: 'password' },
      },
      async authorize(credentials) {
        const user = await db.user.findUnique({
          where: { email: credentials.email },
        });

        if (!user) return null;

        const valid = await bcrypt.compare(
          credentials.password,
          user.password
        );

        if (!valid) return null;

        return {
          id: user.id,
          email: user.email,
          name: user.name,
        };
      },
    }),
  ],
};
```

**Pros**: Control total, sin dependencias externas
**Cons**: Responsabilidad de seguridad (hashing, rate limiting)

### 2. OAuth Providers

```tsx
import Google from 'next-auth/providers/google';
import GitHub from 'next-auth/providers/github';

export const authConfig = {
  providers: [
    Google({
      clientId: process.env.GOOGLE_CLIENT_ID,
      clientSecret: process.env.GOOGLE_CLIENT_SECRET,
    }),
    GitHub({
      clientId: process.env.GITHUB_ID,
      clientSecret: process.env.GITHUB_SECRET,
    }),
  ],
};
```

**Pros**: Sin manejo de passwords, confianza del usuario
**Cons**: Dependencia de terceros, menos control

### 3. Magic Links (Passwordless)

```tsx
import Email from 'next-auth/providers/email';

export const authConfig = {
  providers: [
    Email({
      server: process.env.EMAIL_SERVER,
      from: process.env.EMAIL_FROM,
    }),
  ],
};
```

**Flujo:**
1. Usuario ingresa email
2. Recibe link con token único
3. Click en link → autenticado

**Pros**: Sin passwords que recordar/hackear
**Cons**: Dependencia del email, fricción adicional

## Flujo de autenticación en Next.js

```
┌─────────────────────────────────────────────────────────────┐
│                        CLIENTE                               │
│                                                              │
│  ┌──────────┐     ┌──────────┐     ┌──────────────────┐    │
│  │  Login   │────>│  Auth.js │────>│ Middleware check │    │
│  │  Page    │     │  signIn()│     │ (cada request)   │    │
│  └──────────┘     └──────────┘     └────────┬─────────┘    │
│                                              │              │
└──────────────────────────────────────────────┼──────────────┘
                                               │
                                               ▼
┌─────────────────────────────────────────────────────────────┐
│                        SERVIDOR                              │
│                                                              │
│  ┌──────────────┐    ┌──────────────┐    ┌──────────────┐  │
│  │ Validate     │───>│ Create       │───>│ Set Cookie   │  │
│  │ Credentials  │    │ Session/JWT  │    │ (HttpOnly)   │  │
│  └──────────────┘    └──────────────┘    └──────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Consideraciones de seguridad

### 1. Siempre usa HTTPS

```tsx
// next.config.js
module.exports = {
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'Strict-Transport-Security',
            value: 'max-age=63072000; includeSubDomains; preload',
          },
        ],
      },
    ];
  },
};
```

### 2. Cookies seguras

```tsx
// Auth.js configura esto automáticamente en producción
cookies: {
  sessionToken: {
    name: '__Secure-next-auth.session-token',
    options: {
      httpOnly: true,
      sameSite: 'lax',
      path: '/',
      secure: true, // Solo HTTPS
    },
  },
}
```

### 3. CSRF Protection

Auth.js incluye protección CSRF automática para acciones de mutación.

### 4. Rate Limiting

```tsx
// Implementar en login
import { Ratelimit } from '@upstash/ratelimit';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(5, '1 m'), // 5 intentos por minuto
});

async function authorize(credentials) {
  const { success } = await ratelimit.limit(credentials.email);

  if (!success) {
    throw new Error('Demasiados intentos. Intenta más tarde.');
  }

  // ... validar credentials
}
```

## Cuándo usar cada estrategia

| Caso de uso | Estrategia recomendada |
|-------------|------------------------|
| App interna/corporativa | Sessions + OAuth (Google Workspace) |
| SaaS B2C | OAuth + Magic Links |
| App móvil + web | JWT (compartido entre plataformas) |
| Microservicios | JWT (validación distribuida) |
| Alta seguridad (banca) | Sessions + MFA + hardware keys |

## Resumen

1. **JWT**: Stateless, escalable, ideal para APIs y microservicios
2. **Sessions**: Seguro, revocable, ideal para apps web tradicionales
3. **Híbrido**: Lo mejor de ambos mundos (Auth.js default)
4. **OAuth**: Delega autenticación a providers confiables
5. **Magic Links**: Passwordless, buena UX, requiere email confiable

En la próxima lección implementaremos Auth.js (NextAuth v5) paso a paso.

## Recursos adicionales

- [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
- [JWT.io](https://jwt.io/)
- [Auth.js Documentation](https://authjs.dev/)
