-- =====================================================
-- Seed: Curso ONA Fundamentals
-- 2 modulos, 5 lecciones
-- Los ejercicios se definen en YAML, no en la base de datos
-- =====================================================

-- 1. Insertar el curso
INSERT INTO courses (id, title, description, slug, thumbnail_url, is_published)
VALUES (
  'f0a00000-0000-0000-0000-000000000001',
  'Introduccion al Analisis de Redes Organizacionales (ONA)',
  'Aprende a revelar la estructura informal de tu organizacion. Diagnostica silos, cuellos de botella y dependencias usando analisis de redes. Curso practico con casos reales de LATAM, sin necesidad de programar.',
  'ona-fundamentals',
  '/images/courses/ona-fundamentals-thumbnail.svg',
  true
)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description,
  slug = EXCLUDED.slug,
  is_published = EXCLUDED.is_published;

-- 2. Insertar los modulos
INSERT INTO modules (id, course_id, title, description, order_index, is_locked)
VALUES
  ('f0a10000-0000-0000-0000-000000000001', 'f0a00000-0000-0000-0000-000000000001', 'Entendiendo las Redes Ocultas', 'Descubre la diferencia entre organigrama y red informal, aprende las metricas clave y diseña encuestas ONA efectivas.', 1, false),
  ('f0a20000-0000-0000-0000-000000000001', 'f0a00000-0000-0000-0000-000000000001', 'De Datos a Decisiones', 'Identifica patrones problematicos (silos, cuellos de botella, dependencias) y aprende a formular recomendaciones accionables.', 2, false)
ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  description = EXCLUDED.description;

-- 3. Insertar las lecciones
INSERT INTO lessons (id, course_id, module_id, title, content, lesson_type, order_index, duration_minutes, is_required, video_url)
VALUES
  -- Modulo 1: Entendiendo las Redes Ocultas
  ('f0a10100-0000-0000-0000-000000000001', 'f0a00000-0000-0000-0000-000000000001', 'f0a10000-0000-0000-0000-000000000001', 'Organigrama vs Red Informal', 'Ver archivo: content/courses/ona-fundamentals/module-01/lessons/01-organigrama-vs-red.md', 'text', 1, 20, true, null),
  ('f0a10200-0000-0000-0000-000000000001', 'f0a00000-0000-0000-0000-000000000001', 'f0a10000-0000-0000-0000-000000000001', 'Metricas de Centralidad', 'Ver archivo: content/courses/ona-fundamentals/module-01/lessons/02-metricas-centralidad.md', 'text', 2, 30, true, null),
  ('f0a10300-0000-0000-0000-000000000001', 'f0a00000-0000-0000-0000-000000000001', 'f0a10000-0000-0000-0000-000000000001', 'Disenando Encuestas ONA', 'Ver archivo: content/courses/ona-fundamentals/module-01/lessons/03-diseno-encuesta.md', 'text', 3, 25, true, null),

  -- Modulo 2: De Datos a Decisiones
  ('f0a20100-0000-0000-0000-000000000001', 'f0a00000-0000-0000-0000-000000000001', 'f0a20000-0000-0000-0000-000000000001', 'Patrones Problematicos', 'Ver archivo: content/courses/ona-fundamentals/module-02/lessons/04-patrones-problematicos.md', 'text', 1, 35, true, null),
  ('f0a20200-0000-0000-0000-000000000001', 'f0a00000-0000-0000-0000-000000000001', 'f0a20000-0000-0000-0000-000000000001', 'Caso Integrador: Aseguradora del Pacifico', 'Ver archivo: content/courses/ona-fundamentals/module-02/lessons/05-caso-integrador.md', 'text', 2, 30, true, null)

ON CONFLICT (id) DO UPDATE SET
  title = EXCLUDED.title,
  content = EXCLUDED.content;

-- Verificacion
SELECT
    'Curso ONA Fundamentals creado' as status,
    (SELECT COUNT(*) FROM courses WHERE slug = 'ona-fundamentals') as cursos,
    (SELECT COUNT(*) FROM modules WHERE course_id = 'f0a00000-0000-0000-0000-000000000001') as modulos,
    (SELECT COUNT(*) FROM lessons WHERE course_id = 'f0a00000-0000-0000-0000-000000000001') as lecciones;
