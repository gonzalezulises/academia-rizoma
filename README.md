# Academia Rizoma

<p align="center">
  <a href="https://github.com/gonzalezulises/edu-platform/blob/main/LICENSE"><img src="https://img.shields.io/badge/License-MIT-green.svg" alt="MIT License"/></a>
  <a href="https://github.com/gonzalezulises/edu-platform/pulls"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" alt="PRs Welcome"/></a>
  <a href="https://claude.ai"><img src="https://img.shields.io/badge/Made%20with-Claude%20Code-blueviolet?logo=anthropic&logoColor=white" alt="Made with Claude Code"/></a>
</p>

<p align="center">
  <a href="https://nextjs.org/"><img src="https://img.shields.io/badge/Next.js-14-black?logo=next.js&logoColor=white" alt="Next.js"/></a>
  <a href="https://react.dev/"><img src="https://img.shields.io/badge/React-18-61DAFB?logo=react&logoColor=black" alt="React"/></a>
  <a href="https://www.typescriptlang.org/"><img src="https://img.shields.io/badge/TypeScript-5-3178C6?logo=typescript&logoColor=white" alt="TypeScript"/></a>
  <a href="https://nodejs.org/"><img src="https://img.shields.io/badge/Node.js-18+-339933?logo=node.js&logoColor=white" alt="Node.js"/></a>
  <a href="https://tailwindcss.com/"><img src="https://img.shields.io/badge/Tailwind_CSS-3-06B6D4?logo=tailwindcss&logoColor=white" alt="Tailwind CSS"/></a>
</p>

<p align="center">
  <a href="https://supabase.com/"><img src="https://img.shields.io/badge/Supabase-Database-3FCF8E?logo=supabase&logoColor=white" alt="Supabase"/></a>
  <a href="https://www.postgresql.org/"><img src="https://img.shields.io/badge/PostgreSQL-15-4169E1?logo=postgresql&logoColor=white" alt="PostgreSQL"/></a>
</p>

<p align="center">
  <a href="https://pyodide.org/"><img src="https://img.shields.io/badge/Pyodide-Python%20WASM-3776AB?logo=python&logoColor=white" alt="Pyodide"/></a>
  <a href="https://sql.js.org/"><img src="https://img.shields.io/badge/sql.js-SQLite%20WASM-003B57?logo=sqlite&logoColor=white" alt="sql.js"/></a>
  <a href="https://webassembly.org/"><img src="https://img.shields.io/badge/WebAssembly-Enabled-654FF0?logo=webassembly&logoColor=white" alt="WebAssembly"/></a>
  <a href="https://microsoft.github.io/monaco-editor/"><img src="https://img.shields.io/badge/Monaco-Editor-007ACC?logo=visualstudiocode&logoColor=white" alt="Monaco Editor"/></a>
  <a href="https://eslint.org/"><img src="https://img.shields.io/badge/ESLint-Configured-4B32C3?logo=eslint&logoColor=white" alt="ESLint"/></a>
</p>

<p align="center">
  <a href="https://vercel.com/"><img src="https://img.shields.io/badge/Vercel-Deploy-000000?logo=vercel&logoColor=white" alt="Vercel"/></a>
  <a href="https://colab.research.google.com/"><img src="https://img.shields.io/badge/Google_Colab-Integration-F9AB00?logo=googlecolab&logoColor=white" alt="Google Colab"/></a>
  <a href="https://www.nvidia.com/"><img src="https://img.shields.io/badge/NVIDIA_DGX-AI%20Inference-76B900?logo=nvidia&logoColor=white" alt="NVIDIA DGX"/></a>
  <a href="https://www.cloudflare.com/"><img src="https://img.shields.io/badge/Cloudflare-Tunnel-F38020?logo=cloudflare&logoColor=white" alt="Cloudflare Tunnel"/></a>
</p>

---

Plataforma educativa completa con cursos, evaluaciones, **ejercicios interactivos de codigo**, foros, tracking de progreso y **generacion de contenido asistida por IA**. Desarrollada con Next.js 14, Supabase y Tailwind CSS.

## Tabla de Contenidos

- [Descripcion General](#descripcion-general)
- [Stack Tecnologico](#stack-tecnologico)
- [Caracteristicas](#caracteristicas)
- [Wizard de Creacion de Lecciones (4C)](#wizard-de-creacion-de-lecciones-4c)
- [Infraestructura de IA](#infraestructura-de-ia)
- [Sistema de Ejercicios Interactivos](#sistema-de-ejercicios-interactivos)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Base de Datos](#base-de-datos)
- [Creacion de Cursos](#creacion-de-cursos)
- [Instalacion](#instalacion)
- [Variables de Entorno](#variables-de-entorno)
- [Scripts Disponibles](#scripts-disponibles)

---

## Descripcion General

EduPlatform es una plataforma de aprendizaje en linea que permite a instructores crear cursos estructurados con modulos, lecciones, quizzes, **ejercicios de codigo interactivos** y recursos descargables. Los estudiantes pueden inscribirse, seguir su progreso, ejecutar codigo Python/SQL en el navegador y participar en foros.

Incluye un **wizard de creacion de lecciones con IA** basado en el modelo pedagogico 4C (Connection, Concepts, Concrete Practice, Conclusions), con generacion de contenido respaldada por un servidor NVIDIA DGX Spark ejecutando Qwen2.5:72B.

### Roles de Usuario

| Rol | Permisos |
|-----|----------|
| **Student** | Inscribirse a cursos, ver lecciones, ejecutar ejercicios, tomar quizzes, participar en foros |
| **Instructor** | Todo lo anterior + crear/editar cursos, usar wizard 4C, generar contenido con IA |
| **Admin** | Todo lo anterior + gestionar usuarios, reordenar modulos/lecciones, configuracion global |

---

## Stack Tecnologico

| Tecnologia | Uso |
|------------|-----|
| **Next.js 14** | Framework React con App Router y Server Components |
| **TypeScript** | Tipado estatico |
| **Supabase** | Base de datos PostgreSQL, autenticacion y storage |
| **Tailwind CSS** | Estilos utility-first |
| **Pyodide** | Python en el navegador (WebAssembly) |
| **sql.js** | SQLite en el navegador (WebAssembly) |
| **Monaco Editor** | Editor de codigo (el mismo de VS Code) |
| **@dnd-kit** | Drag-and-drop para reordenar bloques de contenido |
| **Qwen2.5:72B** | Modelo de IA para generacion de contenido (NVIDIA DGX) |
| **Cloudflare Tunnel** | Exposicion segura del servidor DGX a produccion |
| **Vercel** | Deploy con CI/CD automatico |

---

## Caracteristicas

### Gestion de Cursos
- Crear y editar cursos con thumbnail
- Organizar contenido en modulos y lecciones
- **Reordenar modulos y lecciones** con controles up/down
- Soporte para video (YouTube embebido), texto y recursos
- Publicar/despublicar cursos

### Wizard de Creacion de Lecciones (4C)
- **Wizard de 6 pasos** basado en el modelo pedagogico 4C
- Generacion de contenido asistida por IA en cada paso
- Validacion en tiempo real con checklist de calidad
- Busqueda de videos de YouTube integrada
- Drag-and-drop para reordenar bloques conceptuales
- Editor Monaco para markdown y codigo
- Guardado de borradores con auto-recuperacion

### Sistema de Ejercicios Interactivos
- **Python Playground**: Ejecutar Python en el navegador con Pyodide
- **SQL Playground**: Ejecutar SQL con sql.js
- **Google Colab Integration**: Lanzar notebooks en Colab
- Editor Monaco con syntax highlighting
- Tests automatizados con puntuacion
- Hints progresivos

### Sistema de Evaluaciones
- Quizzes con multiples tipos de preguntas (MCQ, verdadero/falso, respuesta corta)
- Limite de intentos y tiempo
- Retroalimentacion inmediata
- Calificacion automatica

### Tracking de Progreso
- Progreso por leccion, ejercicio y curso
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

---

## Wizard de Creacion de Lecciones (4C)

El wizard guia a instructores a traves de 6 pasos para crear lecciones pedagogicamente estructuradas:

| Paso | Nombre | Descripcion |
|------|--------|-------------|
| 1 | **Metadata** | Titulo, modulo, duracion, objetivos de aprendizaje, nivel Bloom |
| 2 | **Connection** | Hook inicial (pregunta, historia, analogia, demo) con editor markdown |
| 3 | **Concepts** | Bloques conceptuales con drag-drop, busqueda de video, editor markdown |
| 4 | **Practice** | Ejercicios interactivos con editor de codigo, tests y hints |
| 5 | **Conclusions** | Preguntas de quiz, resumen y conexion con temas futuros |
| 6 | **Review** | Checklist de validacion, preview markdown, guardar/publicar |

Cada paso (2-5) incluye un boton de **generacion con IA** que produce contenido estructurado basado en el titulo, objetivos y contexto de la leccion.

### Validacion en Tiempo Real

El wizard valida 6 reglas de calidad:
- Las 4 fases del modelo 4C presentes
- Ratio de practica entre 40-50% del tiempo total
- Minimo 2 ejercicios interactivos
- Minimo 5 preguntas de quiz
- Objetivos cubiertos por ejercicios/quiz
- Duracion coherente con contenido

### Acceso

- **Admin** → Cursos → Seleccionar curso → "Wizard 4C" (boton verde)
- Ruta: `/admin/lessons/new?courseId=X`
- Edicion: `/admin/lessons/[id]/edit`

---

## Infraestructura de IA

### Arquitectura Dual-Provider

La plataforma usa un sistema de IA con fallback automatico:

```
Request → DGX Spark (Qwen2.5:72B) → Si falla → Claude API (Sonnet) → Si falla → Error graceful
```

| Provider | Modelo | Endpoint | Timeout |
|----------|--------|----------|---------|
| **Local (DGX)** | Qwen2.5:72B via Ollama | `ollama.rizo.ma/v1` | 120s |
| **Cloud (fallback)** | Claude Sonnet | `api.anthropic.com/v1` | 60s |

### NVIDIA DGX Spark

- **Hardware**: NVIDIA GB10 Grace Blackwell, 128GB memoria unificada
- **Software**: Ollama ejecutando Qwen2.5:72B
- **Red privada**: Tailscale (100.116.242.33:11434) para desarrollo local
- **Red publica**: Cloudflare Tunnel (`ollama.rizo.ma`) para produccion en Vercel

### Cloudflare Tunnel

El servidor DGX se expone de forma segura a traves de un tunel Cloudflare:

```
Vercel (produccion) → ollama.rizo.ma → Cloudflare Tunnel → DGX localhost:11434
```

- Tunnel ID: `dgx-ollama`
- DNS: `ollama.rizo.ma` → DGX
- Protocolo: HTTPS terminado en Cloudflare, HTTP al DGX local

### API Routes

| Ruta | Metodo | Descripcion |
|------|--------|-------------|
| `/api/admin/ai/generate` | POST | Generacion de contenido IA (connection, concepts, practice, quiz) |
| `/api/admin/search-videos` | POST | Busqueda de videos en YouTube Data API v3 |

---

## Sistema de Ejercicios Interactivos

### Arquitectura

```
content/
  courses/
    python-data-science/          # Curso
      course.yaml                 # Configuracion del curso
      module-01/                  # Modulo
        module.yaml               # Configuracion del modulo
        lessons/                  # Lecciones en Markdown
          01-variables.md
        exercises/                # Ejercicios en YAML
          ex-01-hola-mundo.yaml
  shared/
    datasets/                     # CSVs compartidos
    schemas/                      # Schemas SQL
```

### Formato de Ejercicio (YAML)

```yaml
id: ex-01-hola-mundo
type: code-python              # code-python | sql | colab | quiz
title: "Tu primer programa"
description: "Aprende a usar print()"
instructions: |
  Escribe un programa que imprima "Hola, Mundo!"
difficulty: beginner           # beginner | intermediate | advanced
estimated_time_minutes: 5
points: 10
runtime_tier: pyodide          # pyodide | jupyterlite | colab

starter_code: |
  # Escribe tu codigo aqui

solution_code: |
  print("Hola, Mundo!")

test_cases:
  - id: test-output
    name: "Output correcto"
    test_code: |
      import sys
      from io import StringIO
      # Capturar output y verificar
    points: 10

hints:
  - "Usa la funcion print()"
  - "El texto va entre comillas"

tags:
  - python-basico
  - print
```

### Embeds en Markdown

Los ejercicios se insertan en las lecciones con comentarios HTML:

```markdown
# Variables y Tipos de Datos

Aprende sobre variables en Python...

## Ejercicio: Tu primer print

<!-- exercise:ex-01-hola-mundo -->

## Siguiente tema...
```

### Componentes Clave

| Componente | Ubicacion | Funcion |
|------------|-----------|---------|
| `CodePlayground` | `src/components/exercises/` | Editor + runner Python |
| `SQLPlayground` | `src/components/exercises/` | Editor + runner SQL |
| `Exercise` | `src/components/exercises/` | Orquestador de tipos |
| `usePyodide` | `src/hooks/` | Hook para Python runtime |
| `useSQLite` | `src/hooks/` | Hook para SQL runtime |
| `MarkdownRenderer` | `src/components/course/` | Parser de embeds |
| `embed-parser` | `src/lib/content/` | Detecta `<!-- exercise:id -->` |
| `loaders` | `src/lib/content/` | Carga YAML y datasets |

### API de Ejercicios

```
GET /api/exercises/[exerciseId]?course=slug&module=module-id

Response:
{
  "exercise": { ... },      // Sin solution_code
  "datasets": { ... },      // CSVs cargados
  "schema": "..."           // Schema SQL si aplica
}
```

---

## Estructura del Proyecto

```
academia-rizoma/
├── src/
│   ├── app/
│   │   ├── (auth)/login, register
│   │   ├── (dashboard)/
│   │   │   ├── admin/
│   │   │   │   ├── courses/[id]/       # Admin curso (reordenar modulos/lecciones)
│   │   │   │   └── lessons/
│   │   │   │       ├── new/            # Wizard nueva leccion
│   │   │   │       └── [id]/edit/      # Wizard editar leccion
│   │   │   ├── courses/[id]/lessons/[lessonId]/
│   │   │   └── dashboard/
│   │   └── api/
│   │       ├── admin/
│   │       │   ├── ai/generate/        # Generacion IA
│   │       │   └── search-videos/      # Busqueda YouTube
│   │       └── exercises/[exerciseId]/
│   ├── components/
│   │   ├── admin/
│   │   │   └── lesson-wizard/          # Wizard 4C completo
│   │   │       ├── LessonWizard.tsx    # Orquestador principal
│   │   │       ├── types.ts           # Tipos y constantes
│   │   │       ├── hooks/
│   │   │       │   ├── useLessonWizard.ts   # Estado (useReducer)
│   │   │       │   └── useAIGeneration.ts   # Hook de IA
│   │   │       ├── steps/             # 6 pasos del wizard
│   │   │       │   ├── MetadataStep.tsx
│   │   │       │   ├── ConnectionStep.tsx
│   │   │       │   ├── ConceptsStep.tsx
│   │   │       │   ├── PracticeStep.tsx
│   │   │       │   ├── ConclusionsStep.tsx
│   │   │       │   └── ReviewStep.tsx
│   │   │       └── shared/            # Componentes compartidos
│   │   │           ├── AIGenerateButton.tsx
│   │   │           ├── BlockList.tsx
│   │   │           ├── ExerciseEditor.tsx
│   │   │           ├── MarkdownEditor.tsx
│   │   │           ├── QuizEditor.tsx
│   │   │           ├── ValidationChecklist.tsx
│   │   │           └── VideoSearch.tsx
│   │   ├── exercises/          # Playgrounds interactivos
│   │   └── course/             # MarkdownRenderer, LessonPlayer
│   ├── hooks/
│   │   ├── usePyodide.ts       # Python runtime
│   │   └── useSQLite.ts        # SQL runtime
│   ├── lib/
│   │   ├── ai/                 # Servicio de IA
│   │   │   ├── service.ts      # Dual provider (DGX/Claude)
│   │   │   └── prompts.ts      # Templates 4C
│   │   ├── content/            # Loaders y parsers
│   │   └── supabase/
│   └── types/
│       ├── index.ts
│       └── exercises.ts
├── content/                    # Contenido declarativo
│   ├── courses/
│   └── shared/
├── supabase/
│   └── migrations/
├── CLAUDE.md                   # Contexto para Claude Code
├── CLAUDE_COURSE_GUIDE.md      # Guia para crear cursos
└── package.json
```

---

## Base de Datos

### Tablas Principales

| Tabla | Descripcion |
|-------|-------------|
| `profiles` | Usuarios con roles |
| `courses` | Cursos con instructor |
| `modules` | Modulos dentro de cursos |
| `lessons` | Lecciones con contenido markdown |
| `lesson_metadata` | Metadata pedagogica, wizard state, objetivos, nivel Bloom |
| `course_exercises` | Ejercicios asociados a cursos/modulos/lecciones |
| `enrollments` | Inscripciones |
| `progress` | Progreso por leccion |
| `exercise_progress` | Progreso por ejercicio interactivo |
| `quizzes` | Evaluaciones por leccion |
| `quiz_questions` | Preguntas individuales de quiz |

### Tabla lesson_metadata

```sql
CREATE TABLE lesson_metadata (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES lessons(id) ON DELETE CASCADE,
  learning_objectives JSONB DEFAULT '[]',
  bloom_level TEXT,
  connection_type TEXT,
  practice_ratio DECIMAL(3,2),
  estimated_duration_minutes INTEGER,
  validation_result JSONB DEFAULT '{}',
  ai_provider TEXT,
  wizard_state JSONB,     -- Estado completo para edicion y recuperacion
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(lesson_id)
);
```

### Tabla exercise_progress

```sql
CREATE TABLE exercise_progress (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES profiles(id),
  exercise_id TEXT NOT NULL,
  status TEXT DEFAULT 'not_started',  -- not_started, in_progress, completed, failed
  current_code TEXT,                   -- Ultimo codigo guardado
  attempts INTEGER DEFAULT 0,
  score DECIMAL(10,2),
  max_score DECIMAL(10,2),
  test_results JSONB DEFAULT '[]',
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  UNIQUE(user_id, exercise_id)
);
```

### Migraciones

| Archivo | Descripcion |
|---------|-------------|
| `20251201000001_initial_schema.sql` | Schema inicial |
| `20251201000002_modules_hierarchy.sql` | Modulos |
| `20251201000003_progress_tracking.sql` | Tracking |
| `20251201000004_quizzes.sql` | Evaluaciones |
| `20251201000005_forums.sql` | Foros |
| `20251201000006_content_management.sql` | Recursos |
| `20251225000001_interactive_exercises.sql` | Tabla exercise_progress |
| `20251225000002_seed_python_course.sql` | Curso Python |
| `20251225000003_update_python_course_content.sql` | Contenido markdown |
| `20260216000001_course_generation.sql` | Generacion de cursos |
| `20260216000004_lesson_metadata.sql` | Metadata de lecciones (wizard 4C) |
| `20260216000005_lessons_admin_policy.sql` | RLS: admins gestionan lecciones |

---

## Creacion de Cursos

### Metodo 1: Wizard 4C (Recomendado)

1. Ir a **Admin** → **Cursos** → Seleccionar curso
2. Click en **"Wizard 4C"**
3. Seguir los 6 pasos del wizard
4. Usar IA para generar contenido en cada paso
5. Revisar validacion y publicar

### Metodo 2: Creacion Rapida

Formulario basico disponible en la misma pagina de administracion del curso (titulo, tipo, contenido, video URL, duracion).

### Metodo 3: Contenido Declarativo

Ver **[CLAUDE_COURSE_GUIDE.md](CLAUDE_COURSE_GUIDE.md)** para instrucciones detalladas sobre:

- Crear un nuevo curso con ejercicios interactivos
- Estructura de archivos YAML
- Agregar al base de datos
- Deploy

---

## Instalacion

```bash
# Clonar repositorio
git clone https://github.com/gonzalezulises/academia-rizoma.git
cd academia-rizoma

# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env.local

# Iniciar servidor de desarrollo
npm run dev
```

---

## Variables de Entorno

```env
# Supabase (requerido)
NEXT_PUBLIC_SUPABASE_URL=https://tu-proyecto.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=tu-anon-key
SUPABASE_ACCESS_TOKEN=tu-access-token  # Para CLI

# IA - DGX Spark (opcional, habilita generacion local)
AI_LOCAL_ENDPOINT=https://ollama.rizo.ma/v1   # o http://100.116.242.33:11434/v1 para dev local
AI_LOCAL_MODEL=qwen2.5:72b

# IA - Claude API (opcional, fallback si DGX no responde)
ANTHROPIC_API_KEY=tu-api-key

# YouTube Data API (opcional, habilita busqueda de videos en wizard)
YOUTUBE_API_KEY=tu-youtube-api-key
```

---

## Scripts Disponibles

| Comando | Descripcion |
|---------|-------------|
| `npm run dev` | Servidor de desarrollo |
| `npm run build` | Build de produccion |
| `npm run lint` | Ejecutar ESLint |
| `node scripts/seed-python-course.mjs` | Seed de curso Python |

### Supabase CLI

```bash
# Aplicar migraciones
source .env.local && supabase db push --linked

# Ver estado de migraciones
source .env.local && supabase migration list
```

---

## Deploy

El proyecto se despliega automaticamente en **Vercel** con cada push a `main`.

**Importante:** Los archivos en `content/` se incluyen en el build y estan disponibles para la API.

### Variables de Entorno en Vercel

Configurar en Vercel Dashboard → Settings → Environment Variables:
- `NEXT_PUBLIC_SUPABASE_URL`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- `AI_LOCAL_ENDPOINT` → `https://ollama.rizo.ma/v1`
- `AI_LOCAL_MODEL` → `qwen2.5:72b`
- `ANTHROPIC_API_KEY` (opcional, fallback)
- `YOUTUBE_API_KEY` (opcional)

---

## Cursos Disponibles

| Curso | Modulos | Ejercicios | Estado |
|-------|---------|------------|--------|
| Introduccion a Python | 1 | 13 | Publicado |
| Introduccion a Scikit-Learn | 4 | 10 | Publicado |
| Fundamentos de SQL | 1 | 16 | Publicado |

**Total:** 6 modulos, 39 ejercicios interactivos

---

## Licencia

Este proyecto esta licenciado bajo la **MIT License** - ver el archivo [LICENSE](LICENSE) para mas detalles.

---

## Autor

**Ulises Gonzalez** - *Fundador de Rizoma* @ [Rizo.ma](https://rizo.ma)

[![Website](https://img.shields.io/badge/Website-ulises--gonzalez-blue?style=flat-square&logo=google-chrome&logoColor=white)](https://ulises-gonzalez-site.vercel.app)
[![GitHub](https://img.shields.io/badge/GitHub-gonzalezulises-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/gonzalezulises)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-ulisesgonzalez-0A66C2?style=flat-square&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/ulisesgonzalez/)
[![Kaggle](https://img.shields.io/badge/Kaggle-ulisesgonzalez-20BEFF?style=flat-square&logo=kaggle&logoColor=white)](https://www.kaggle.com/ulisesgonzalez)
[![Medium](https://img.shields.io/badge/Medium-gonzalezulises-000000?style=flat-square&logo=medium&logoColor=white)](https://medium.com/@gonzalezulises)

[![Email](https://img.shields.io/badge/Email-ulises%40rizo.ma-EA4335?style=flat-square&logo=gmail&logoColor=white)](mailto:ulises@rizo.ma)
[![Calendly](https://img.shields.io/badge/Calendly-Schedule%20Meeting-006BFF?style=flat-square&logo=calendly&logoColor=white)](https://calendly.com/gonzalezulises)

---

## Creditos

Desarrollado con asistencia de **Claude Code** (Anthropic).



---

<p align="center">
  <sub>Built with passion in Panama</sub>
</p>
