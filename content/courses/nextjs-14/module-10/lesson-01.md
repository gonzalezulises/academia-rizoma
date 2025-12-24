# Deploy en Vercel

## Script de Video - Duración: 15 minutos

### Timestamps

- **0:00** - Introducción a Vercel
- **2:00** - Conectando repositorio GitHub
- **5:00** - Configuración del proyecto
- **8:00** - Environment Variables
- **11:00** - Preview Deployments
- **13:00** - Dominios personalizados
- **14:30** - Resumen

---

## 0:00 - Introducción a Vercel

```
[PANTALLA: vercel.com homepage]
```

**Narración:**

"Vercel es la plataforma creada por el equipo detrás de Next.js. Ofrece:

- **Zero-config deployments**: Push and deploy
- **Edge Network global**: Tu app en 100+ regiones
- **Preview deployments**: URL única por cada PR
- **Serverless Functions**: Para API routes y Server Actions
- **Analytics integrado**: Core Web Vitals en tiempo real"

### Por qué Vercel para Next.js

| Feature | Vercel | Otras plataformas |
|---------|--------|-------------------|
| ISR (Incremental Static Regeneration) | ✅ Nativo | ⚠️ Limitado |
| Image Optimization | ✅ Incluido | 💰 Extra |
| Edge Functions | ✅ Nativo | ⚠️ Config manual |
| Preview Deployments | ✅ Automático | ⚠️ Setup requerido |
| Rollbacks instantáneos | ✅ 1-click | ⚠️ Varía |

---

## 2:00 - Conectando repositorio GitHub

```
[PANTALLA: Vercel dashboard → New Project]
```

**Narración:**

"Conectar tu proyecto es simple:"

### Paso 1: Importar repositorio

1. Ve a [vercel.com/new](https://vercel.com/new)
2. Click en "Continue with GitHub"
3. Autoriza Vercel en GitHub
4. Selecciona tu repositorio

```
[PANTALLA: Lista de repositorios]
```

### Paso 2: Configurar proyecto

```
Project Name: my-nextjs-app
Framework Preset: Next.js (auto-detectado)
Root Directory: ./
Build Command: npm run build (default)
Output Directory: .next (default)
Install Command: npm install (default)
```

**Narración:**

"Vercel detecta automáticamente que es un proyecto Next.js y configura todo correctamente."

---

## 5:00 - Configuración del proyecto

```
[PANTALLA: Project Settings en Vercel]
```

### next.config.js para producción

```javascript
// next.config.js
/** @type {import('next').NextConfig} */
const nextConfig = {
  // Optimizaciones de imagen
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'images.unsplash.com',
      },
      {
        protocol: 'https',
        hostname: 'avatars.githubusercontent.com',
      },
    ],
  },

  // Headers de seguridad
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'X-Frame-Options',
            value: 'DENY',
          },
          {
            key: 'X-Content-Type-Options',
            value: 'nosniff',
          },
          {
            key: 'Referrer-Policy',
            value: 'origin-when-cross-origin',
          },
        ],
      },
    ];
  },

  // Logs de build
  logging: {
    fetches: {
      fullUrl: true,
    },
  },
};

module.exports = nextConfig;
```

### Verificar build local antes de deploy

```bash
# Build de producción local
npm run build

# Verificar que no hay errores
npm run start

# Visitar http://localhost:3000
```

---

## 8:00 - Environment Variables

```
[PANTALLA: Vercel → Project → Settings → Environment Variables]
```

**Narración:**

"Las variables de entorno en Vercel se manejan de forma segura:"

### Tipos de variables

| Tipo | Prefijo | Accesible en |
|------|---------|--------------|
| Server | (ninguno) | Server Components, API Routes |
| Public | `NEXT_PUBLIC_` | Ambos (incluido en bundle) |

```
[PANTALLA: Agregando variables]
```

### Variables típicas

```
# Base de datos
DATABASE_URL = postgresql://...

# Auth
NEXTAUTH_SECRET = tu-secret-muy-largo-y-aleatorio
NEXTAUTH_URL = https://tu-dominio.vercel.app

# Servicios externos
STRIPE_SECRET_KEY = sk_live_...
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY = pk_live_...

# APIs
OPENAI_API_KEY = sk-...
```

### Ambientes

Vercel soporta diferentes valores por ambiente:

- **Production**: `main` branch
- **Preview**: Otros branches y PRs
- **Development**: Desarrollo local

```
[PANTALLA: Selector de ambiente para cada variable]
```

**Tip**: Usa valores de test/sandbox en Preview, producción solo en Production.

---

## 11:00 - Preview Deployments

```
[PANTALLA: GitHub PR con comentario de Vercel]
```

**Narración:**

"Cada Pull Request obtiene su propia URL de preview:"

### Flujo

1. Creas un PR en GitHub
2. Vercel detecta automáticamente
3. Hace build del branch
4. Comenta en el PR con la URL
5. Actualiza con cada push

```
✅ Vercel
Preview: https://my-app-git-feature-xyz.vercel.app

Built with commit abc1234
```

### Protección de previews

```javascript
// Opcional: proteger previews con password
// vercel.json
{
  "password": {
    "preview": "mi-password-secreto"
  }
}
```

### Comentarios en Preview

Vercel incluye toolbar para comentarios visuales en previews, útil para review de diseño.

---

## 13:00 - Dominios personalizados

```
[PANTALLA: Project → Settings → Domains]
```

**Narración:**

"Configurar tu dominio personalizado:"

### Paso 1: Agregar dominio

1. Ve a Settings → Domains
2. Ingresa tu dominio: `miapp.com`
3. Click "Add"

### Paso 2: Configurar DNS

Vercel te da las opciones:

**Opción A: Nameservers (recomendado)**
```
ns1.vercel-dns.com
ns2.vercel-dns.com
```

**Opción B: A Record**
```
A   @   76.76.21.21
```

**Opción C: CNAME**
```
CNAME   www   cname.vercel-dns.com
```

### Paso 3: SSL automático

Vercel configura SSL/TLS automáticamente con Let's Encrypt.

### Subdominios

```
miapp.com          → Producción
www.miapp.com      → Redirect a miapp.com
api.miapp.com      → API separada (opcional)
staging.miapp.com  → Preview de staging branch
```

---

## 14:30 - Resumen

```
[PANTALLA: Checklist final]
```

### Checklist de deploy

- [ ] Build local exitoso (`npm run build`)
- [ ] Variables de entorno configuradas
- [ ] Dominios verificados
- [ ] SSL activo
- [ ] Preview deployments funcionando
- [ ] Rollback testeado

### Comandos útiles de Vercel CLI

```bash
# Instalar CLI
npm i -g vercel

# Login
vercel login

# Deploy desde local (para testing)
vercel

# Deploy a producción
vercel --prod

# Ver logs
vercel logs

# Listar deployments
vercel ls

# Pull env vars a .env.local
vercel env pull
```

### Monitoreo post-deploy

1. **Vercel Analytics**: Core Web Vitals
2. **Function Logs**: Errores en Serverless
3. **Build Logs**: Problemas de build

---

## Configuración avanzada

### vercel.json

```json
{
  "buildCommand": "npm run build",
  "framework": "nextjs",
  "regions": ["iad1", "sfo1"],
  "functions": {
    "app/api/**/*.ts": {
      "memory": 1024,
      "maxDuration": 30
    }
  },
  "crons": [
    {
      "path": "/api/cron/daily",
      "schedule": "0 0 * * *"
    }
  ]
}
```

### Monorepo support

```json
// vercel.json en root
{
  "projects": [
    {
      "name": "web",
      "root": "apps/web"
    },
    {
      "name": "docs",
      "root": "apps/docs"
    }
  ]
}
```

---

## Recursos adicionales

- [Vercel Documentation](https://vercel.com/docs)
- [Next.js Deployment Guide](https://nextjs.org/docs/deployment)
- [Vercel CLI Reference](https://vercel.com/docs/cli)
- [Status Page](https://vercel-status.com/)
