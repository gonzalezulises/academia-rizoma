# EduPlatform - Contexto del Proyecto

## Descripcion
Plataforma educativa con cursos, lecciones, autenticacion y tracking de progreso.

## Stack Tecnologico
- **Frontend**: Next.js 14 (App Router)
- **Base de datos**: Supabase (PostgreSQL)
- **Autenticacion**: Auth.js + Supabase Auth
- **Storage**: Supabase Storage
- **Estilos**: Tailwind CSS
- **Deploy**: Vercel con CI/CD automatico

## Funcionalidades
- Cursos y lecciones estructurados
- Login/registro con Auth.js
- Tracking de progreso por usuario
- Subida de archivos (videos, PDFs, imagenes)
- Roles: student, instructor, admin

## Estructura de Carpetas
```
src/
├── app/
│   ├── (auth)/login, register
│   ├── (dashboard)/courses, profile
│   └── api/auth
├── components/
├── lib/supabase/
└── types/
```

## Base de Datos (Supabase)
Tablas principales:
- `profiles` - Usuarios extendidos
- `courses` - Cursos
- `lessons` - Lecciones
- `progress` - Progreso del estudiante
- `enrollments` - Inscripciones

## Versionado
- Conventional Commits (feat, fix, docs, chore)
- Husky + Commitlint para validacion
- Standard Version para CHANGELOG automatico

## Seguridad
- Headers de seguridad en next.config.js
- Auditoria con https://web-check.xyz post-deploy
- RLS (Row Level Security) en Supabase

## Variables de Entorno Requeridas
```
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
NEXTAUTH_SECRET=
NEXTAUTH_URL=
```

## Plan Completo
Ver: ~/.claude/plans/wiggly-baking-teapot.md

## Comandos Utiles
```bash
npm run dev      # Desarrollo local
npm run build    # Build de produccion
npm run lint     # Linter
npx standard-version  # Generar nueva version + CHANGELOG
```

## Supabase CLI (Migraciones)

El proyecto esta configurado con Supabase CLI para gestionar migraciones de base de datos.

### Configuracion
```bash
# El proyecto ya esta vinculado. Si necesitas re-vincular:
SUPABASE_ACCESS_TOKEN=$SUPABASE_ACCESS_TOKEN supabase link --project-ref mcssewqlcyfsuznuvtmh
```

### Crear nueva migracion
```bash
# Genera archivo en supabase/migrations/ con timestamp
supabase migration new nombre_descriptivo
```

### Ver estado de migraciones
```bash
SUPABASE_ACCESS_TOKEN=$SUPABASE_ACCESS_TOKEN supabase migration list
```

### Aplicar migraciones pendientes
```bash
SUPABASE_ACCESS_TOKEN=$SUPABASE_ACCESS_TOKEN supabase db push
```

### Migraciones existentes
| Archivo | Descripcion |
|---------|-------------|
| 20251201000001_initial_schema.sql | Schema inicial (profiles, courses, lessons, enrollments, progress) |
| 20251201000002_modules_hierarchy.sql | Modulos y jerarquia de contenido |
| 20251201000003_progress_tracking.sql | Tracking avanzado de progreso |
| 20251201000004_quizzes.sql | Sistema de evaluaciones |
| 20251201000005_forums.sql | Foros y notificaciones |
| 20251201000006_content_management.sql | Recursos y versionado de contenido |
