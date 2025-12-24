# EduPlatform

Plataforma educativa completa con cursos, evaluaciones, foros y tracking de progreso. Desarrollada con Next.js 14, Supabase y Tailwind CSS.

## Tabla de Contenidos

- [Descripcion General](#descripcion-general)
- [Stack Tecnologico](#stack-tecnologico)
- [Caracteristicas](#caracteristicas)
- [Proceso de Desarrollo](#proceso-de-desarrollo)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Base de Datos](#base-de-datos)
- [Instalacion](#instalacion)
- [Variables de Entorno](#variables-de-entorno)
- [Scripts Disponibles](#scripts-disponibles)

---

## Descripcion General

EduPlatform es una plataforma de aprendizaje en linea que permite a instructores crear cursos estructurados con modulos, lecciones, quizzes y recursos descargables. Los estudiantes pueden inscribirse, seguir su progreso, participar en foros y recibir anuncios.

### Roles de Usuario

| Rol | Permisos |
|-----|----------|
| **Student** | Inscribirse a cursos, ver lecciones, tomar quizzes, participar en foros |
| **Instructor** | Todo lo anterior + crear/editar cursos, subir recursos, publicar anuncios |
| **Admin** | Todo lo anterior + gestionar usuarios y configuracion global |

---

## Stack Tecnologico

| Tecnologia | Uso |
|------------|-----|
| **Next.js 14** | Framework React con App Router y Server Components |
| **TypeScript** | Tipado estatico |
| **Supabase** | Base de datos PostgreSQL, autenticacion y storage |
| **Tailwind CSS** | Estilos utility-first |
| **Vercel** | Deploy con CI/CD automatico |

---

## Caracteristicas

### Gestion de Cursos
- Crear y editar cursos con thumbnail
- Organizar contenido en modulos y lecciones
- Soporte para video (YouTube embebido), texto y recursos
- Publicar/despublicar cursos

### Sistema de Evaluaciones
- Quizzes con multiples tipos de preguntas (MCQ, verdadero/falso, respuesta corta)
- Limite de intentos y tiempo
- Retroalimentacion inmediata
- Calificacion automatica

### Tracking de Progreso
- Progreso por leccion y por curso
- Dashboard personal con cursos en progreso
- Boton "Continuar donde quede"
- Estadisticas de tiempo invertido

### Foros y Comunicacion
- Foro por curso para dudas y discusion
- Respuestas anidadas (hasta 3 niveles)
- Marcar respuestas como solucion
- Sistema de notificaciones en tiempo real

### Recursos Descargables
- Subida de archivos por leccion (PDF, Word, Excel, PowerPoint, imagenes)
- Drag & drop para upload
- Contador de descargas
- Limite de 50MB por archivo

### Anuncios
- Instructores pueden publicar anuncios
- Segmentacion por progreso (todos, no iniciados, en progreso, completados)
- Opcion de fijar anuncios importantes

---

## Proceso de Desarrollo

El proyecto se desarrollo en **5 sprints** siguiendo una metodologia agil:

### Sprint 1: Estructura Basica
**Objetivo:** Establecer la jerarquia de contenido

- Migracion SQL para modulos (`002_modules_hierarchy.sql`)
- Actualizar lecciones con tipos (video, texto, quiz, assignment)
- Pagina de detalle de curso con mapa visual
- Navegacion modulo → leccion
- Componente `CourseMap` para visualizar estructura

**Archivos clave:**
```
src/app/(dashboard)/courses/[id]/page.tsx
src/components/course/CourseMap.tsx
src/components/course/ModuleCard.tsx
```

### Sprint 2: Tracking de Progreso
**Objetivo:** Seguimiento detallado del avance del estudiante

- Migracion SQL para progreso (`003_progress_tracking.sql`)
- Dashboard personal con cursos en progreso
- Barra de progreso por curso
- Boton "Retomar" para continuar
- Tiempo total invertido

**Archivos clave:**
```
src/app/(dashboard)/dashboard/page.tsx
src/components/dashboard/CourseProgressCard.tsx
src/components/dashboard/ProgressBar.tsx
```

### Sprint 3: Evaluaciones (Quizzes)
**Objetivo:** Sistema completo de evaluaciones

- Migracion SQL para quizzes (`004_quizzes.sql`)
- Crear/editar quizzes desde admin
- Interfaz para tomar quiz con temporizador
- Calificacion automatica
- Pantalla de resultados con retroalimentacion

**Archivos clave:**
```
src/app/(dashboard)/courses/[id]/quiz/[quizId]/page.tsx
src/components/quiz/QuizPlayer.tsx
src/components/quiz/QuestionMCQ.tsx
src/components/quiz/QuizResults.tsx
```

### Sprint 4: Foros y Notificaciones
**Objetivo:** Comunicacion entre usuarios

- Migracion SQL para foros (`005_forums.sql`)
- Lista de posts por curso
- Crear y responder posts
- Respuestas anidadas con limite de profundidad
- Marcar como respuesta correcta
- Sistema de notificaciones en tiempo real
- Campana de notificaciones en navbar

**Archivos clave:**
```
src/app/(dashboard)/courses/[id]/forum/page.tsx
src/app/(dashboard)/courses/[id]/forum/[postId]/page.tsx
src/components/forum/PostCard.tsx
src/components/forum/ReplyThread.tsx
src/components/notifications/NotificationBell.tsx
```

### Sprint 5: Polish y Extras
**Objetivo:** Recursos, anuncios y refinamiento

- Migracion SQL para contenido (`006_content_management.sql`)
- Formulario de entrega de assignments
- Sistema de anuncios por instructor
- Recursos descargables por leccion
- Upload con drag & drop
- Versionado de contenido

**Archivos clave:**
```
src/app/(dashboard)/courses/[id]/announcements/page.tsx
src/components/announcements/CreateAnnouncement.tsx
src/components/resources/ResourceUpload.tsx
src/components/resources/ResourceList.tsx
src/components/assignment/SubmissionForm.tsx
```

---

## Estructura del Proyecto

```
edu-platform/
├── src/
│   ├── app/
│   │   ├── (auth)/
│   │   │   ├── login/
│   │   │   └── register/
│   │   ├── (dashboard)/
│   │   │   ├── admin/
│   │   │   │   └── courses/
│   │   │   ├── courses/
│   │   │   │   └── [id]/
│   │   │   │       ├── announcements/
│   │   │   │       ├── forum/
│   │   │   │       ├── lessons/
│   │   │   │       └── quiz/
│   │   │   ├── dashboard/
│   │   │   └── notifications/
│   │   └── api/
│   ├── components/
│   │   ├── announcements/
│   │   ├── assignment/
│   │   ├── course/
│   │   ├── dashboard/
│   │   ├── forum/
│   │   ├── notifications/
│   │   ├── quiz/
│   │   ├── resources/
│   │   └── Navbar.tsx
│   ├── lib/
│   │   └── supabase/
│   │       ├── client.ts
│   │       └── server.ts
│   └── types/
│       └── index.ts
├── supabase/
│   └── migrations/
│       ├── 001_initial_schema.sql
│       ├── 002_modules_hierarchy.sql
│       ├── 003_progress_tracking.sql
│       ├── 004_quizzes.sql
│       ├── 005_forums.sql
│       └── 006_content_management.sql
├── public/
├── CLAUDE.md
└── package.json
```

---

## Base de Datos

### Tablas Principales

| Tabla | Descripcion |
|-------|-------------|
| `profiles` | Usuarios con roles (student, instructor, admin) |
| `courses` | Cursos con instructor y metadata |
| `modules` | Modulos dentro de cursos |
| `lessons` | Lecciones con tipo (video, texto, quiz, assignment) |
| `enrollments` | Inscripciones de usuarios a cursos |
| `progress` | Progreso por leccion |
| `course_progress` | Progreso agregado por curso |

### Tablas de Evaluacion

| Tabla | Descripcion |
|-------|-------------|
| `quizzes` | Configuracion de quizzes |
| `quiz_questions` | Preguntas con opciones |
| `quiz_attempts` | Intentos de usuarios |
| `assignments` | Tareas/entregables |
| `submissions` | Entregas de estudiantes |

### Tablas de Comunicacion

| Tabla | Descripcion |
|-------|-------------|
| `forums` | Foros por curso |
| `forum_posts` | Posts/hilos de discusion |
| `forum_replies` | Respuestas a posts |
| `notifications` | Notificaciones de usuarios |
| `announcements` | Anuncios de instructores |

### Tablas de Contenido

| Tabla | Descripcion |
|-------|-------------|
| `resources` | Archivos descargables |
| `content_versions` | Versionado de lecciones |

---

## Instalacion

```bash
# Clonar repositorio
git clone https://github.com/gonzalezulises/edu-platform.git
cd edu-platform

# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env.local
# Editar .env.local con tus credenciales de Supabase

# Ejecutar migraciones en Supabase
# (Copiar cada archivo de supabase/migrations/ al SQL Editor de Supabase)

# Iniciar servidor de desarrollo
npm run dev
```

---

## Variables de Entorno

Crear archivo `.env.local` con:

```env
NEXT_PUBLIC_SUPABASE_URL=https://tu-proyecto.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=tu-anon-key
SUPABASE_SERVICE_ROLE_KEY=tu-service-role-key
```

---

## Scripts Disponibles

| Comando | Descripcion |
|---------|-------------|
| `npm run dev` | Servidor de desarrollo en localhost:3000 |
| `npm run build` | Build de produccion |
| `npm run start` | Iniciar servidor de produccion |
| `npm run lint` | Ejecutar ESLint |

---

## Deploy

El proyecto se despliega automaticamente en **Vercel** con cada push a `main`.

### Configuracion en Vercel:
1. Conectar repositorio de GitHub
2. Configurar variables de entorno
3. Deploy automatico habilitado

---

## Contribucion

1. Fork del repositorio
2. Crear rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -m 'feat: agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Crear Pull Request

---

## Licencia

MIT License - ver [LICENSE](LICENSE) para detalles.

---

## Creditos

Desarrollado con asistencia de **Claude Code** (Anthropic).

```
Co-Authored-By: Claude Opus 4.5 <noreply@anthropic.com>
```
